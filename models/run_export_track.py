import os
from subprocess import Popen, PIPE
import re
import tempfile
import random
import math

local_dir = os.path.dirname(os.path.realpath(__file__))
blender_dir = os.path.expandvars("%programfiles%/Blender Foundation/Blender")
pico_dir = os.path.join("D:","pico-8_0.1.12c")

def call(args):
    proc = Popen(args, stdout=PIPE, stderr=PIPE)
    out, err = proc.communicate()
    exitcode = proc.returncode
    #
    return exitcode, out, err

# data buffer
s = ""
# 3d models
file_list = ['big_forest_genesis']
s = s + "{:02x}".format(len(file_list))
for blend_file in file_list:
    print("Exporting: {}.blend".format(blend_file))
    fd, path = tempfile.mkstemp()
    try:
        os.close(fd)
        exitcode, out, err = call([os.path.join(blender_dir,"blender.exe"),os.path.join(local_dir,blend_file + ".blend"),"--background","--python",os.path.join(local_dir,"blender_export_track.py"),"--","--out",path])
        if err:
            raise Exception('Unable to load: {}. Exception: {}'.format(blend_file,err))
        print("exit: {} \n out:{}\n err: {}\n".format(exitcode,out,err))
        with open(path, 'r') as outfile:
            s = s + outfile.read()
    finally:
        os.remove(path)

# pico-8 map format
#       0x0    gfx
#		0x1000 gfx2/map2 (shared)
#		0x2000 map
#		0x3000 gfx_props
#		0x3100 song
#		0x3200 sfx (??? doesn't work)
#		0x4300 user data

#if len(s)>2*0x4300:
#    raise Exception('Data string too long: {} / {} bytes'.format(int(round(len(s)/2,0)),0x4300))

def pack_variant(x):
    if x>0x7fff:
      raise Exception('Unable to convert: {} into a 1 or 2 bytes'.format(x))
    # 2 bytes
    if x>127:
        h = "{:04x}".format(x + 0x8000)
        if len(h)!=4:
            raise Exception('Unable to convert: {} into a word: {}'.format(x,h))
        return h
    # 1 byte
    h = "{:02x}".format(x)
    if len(h)!=2:
        raise Exception('Unable to convert: {} into a byte: {}'.format(x,h))
    return h

def to_cart(s,cart_id):
    cart="""\
pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- data cart for virtua racing on pico
local data="{}"
local mem=0x3100
for i=1,#data,2 do
    poke(mem,tonum("0x"..sub(data,i,i+1)))
    mem+=1
end
cstore()
"""
    tmp=s[:2*0x2000]
    # swap bytes
    gfx_data = ""
    for i in range(0,len(tmp),2):
        gfx_data = gfx_data + tmp[i+1:i+2] + tmp[i:i+1]
    cart += "__gfx__\n"
    cart += re.sub("(.{128})", "\\1\n", gfx_data, 0, re.DOTALL)

    gfx_props=s[2*0x3000:2*0x3100]
    if len(gfx_props)>0:
        cart += "__gff__\n"
        cart += re.sub("(.{256})", "\\1\n", gfx_props, 0, re.DOTALL)

    map_data=s[2*0x2000:2*0x3000]
    if len(map_data)>0:
        cart += "__map__\n"
        cart += re.sub("(.{256})", "\\1\n", map_data, 0, re.DOTALL)

    # save track cart + export cryptic music+sfx part
    sfx_data=s[2*0x3100:2*0x4300]
    cart_path = os.path.join(local_dir, "..", "carts", "track_{}.p8".format(cart_id))
    f = open(cart_path, "w")
    f.write(cart.format(sfx_data))
    f.close()

    # run cart
    exitcode, out, err = call([os.path.join(pico_dir,"pico8.exe"),"-x",cart_path])
    if err:
        raise Exception('Unable to process pico-8 cart: {}. Exception: {}'.format(cart_path,err))

# multi-cart export
start = 0
cart_id = 0
cart_data = s[:2*0x4300]
while len(cart_data)>0:
    to_cart(cart_data, cart_id)
    # next cart
    cart_id += 1
    start += 2*0x4300
    cart_data = s[start:start+2*0x4300]
