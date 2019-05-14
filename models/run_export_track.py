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
file_list = ['donutstrack']
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

s = ""
for i in range(0x4300):
    s += "{:02x}".format(i%256)

if len(s)>2*0x4300:
    raise Exception('Data string too long: {} / {} bytes'.format(len(s),2*0x4300))

cart="""\
pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- data cart for virtua racing on pico
local data="{}"
local mem=0x3200
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

music_data=s[2*0x3100:2*0x3200]
if len(music_data)>0:
    cart += "__music__\n"
    cart += re.sub("(.{8})", "00 \\1\n", music_data, 0, re.DOTALL)

# save track cart + export cryptic sfx part
sfx_data=s[2*0x3200:2*0x4300]
cart_path = os.path.join(local_dir, "..", "carts", "track.p8")
f = open(cart_path, "w")
f.write(cart.format(sfx_data))
f.close()

# run cart
exitcode, out, err = call([os.path.join(pico_dir,"pico8.exe"),"-x",cart_path])
if err:
    raise Exception('Unable to process pico-8 cart: {}. Exception: {}'.format(cart_path,err))

