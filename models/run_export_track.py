import os
from subprocess import Popen, PIPE
import re
import tempfile
import random
import math
import socket

local_dir = os.path.dirname(os.path.realpath(__file__))
blender_dir = os.path.expandvars("%programfiles%/Blender Foundation/Blender")
pico_dir = ""
if socket.gethostname()=="FRWS3706":
    pico_dir = os.path.join("C:",os.path.sep,"pico-8-0.2.0")
else:
    pico_dir = os.path.join("D:",os.path.sep,"pico-8_0.1.12c")

def call(args):
    proc = Popen(args, stdout=PIPE, stderr=PIPE)
    out, err = proc.communicate()
    exitcode = proc.returncode
    #
    return exitcode, out, err


# pico-8 map format
#       0x0    gfx
#		0x1000 gfx2/map2 (shared)
#		0x2000 map
#		0x3000 gfx_props
#		0x3100 music
#		0x3200 sfx
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

def to_cart(s,cart_name,cart_id):
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

    map_data=s[2*0x2000:2*0x3000]
    if len(map_data)>0:
        cart += "__map__\n"
        cart += re.sub("(.{256})", "\\1\n", map_data, 0, re.DOTALL)

    gfx_props=s[2*0x3000:2*0x3100]
    if len(gfx_props)>0:
        cart += "__gff__\n"
        cart += re.sub("(.{256})", "\\1\n", gfx_props, 0, re.DOTALL)

    # save track cart + export cryptic music+sfx part
    sfx_data=s[2*0x3100:2*0x4300]
    cart_path = os.path.join(local_dir, "..", "carts", "{}_{}.p8".format(cart_name,cart_id))
    f = open(cart_path, "w")
    f.write(cart.format(sfx_data))
    f.close()

    # run cart
    exitcode, out, err = call([os.path.join(pico_dir,"pico8.exe"),"-x",cart_path])
    if err:
        raise Exception('Unable to process pico-8 cart: {}. Exception: {}'.format(cart_path,err))

def export_models():
    # data buffer
    s = ""

    # 3d models
    file_list = ['car_genesis','car_ai_genesis']
    s = s + "{:02x}".format(len(file_list))
    for blend_file in file_list:
        print("Exporting: {}.blend".format(blend_file))
        fd, path = tempfile.mkstemp()
        try:
            os.close(fd)
            exitcode, out, err = call([os.path.join(blender_dir,"blender.exe"),os.path.join(local_dir,blend_file + ".blend"),"--background","--python",os.path.join(local_dir,"blender_export.py"),"--","--out",path])
            if err:
                raise Exception('Unable to loadt: {}. Exception: {}'.format(blend_file,err))
            print("exit: {} \n out:{}\n err: {}\n".format(exitcode,out,err))
            with open(path, 'r') as outfile:
                s = s + outfile.read()
        finally:
            os.remove(path)

    return s

# -------------------------------
# main
cart_data = []
cart_data.append({'data':export_models()})

# format:
# track id: 1 byte
# offset: 2 bytes
track_offsets = {'data':"000000000000000000"}
cart_data.append(track_offsets)

files = {
    'big_forest_genesis':'bigforest',
    'acropolis_genesis':'acropolis',
    'ocean_genesis':'ocean'
}

for blend_file,cart_name in files.items():
    print("Exporting: {}.blend".format(blend_file))
    # data buffer
    s = ""
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
    cart_data.append({'name':cart_name,'data':s})

#
# models -> cart: 0 / offset: 0
# bigforest -> cart: 0 / offset: 9634
# acropolis -> cart: 4 / offset: 7272
# ocean -> cart: 8 / offset: 8486

# multi-cart export to cart set
cart_id = 0
cart_offset = 0
# use yield
def create_data_iterator(record_offsets):
    actual_offsets = ""
    for data_block in cart_data:
        if record_offsets and 'name' in data_block:
            print("{} -> cart: {} / offset: {}".format(data_block['name'], cart_id, cart_offset/2))
            actual_offsets += "{:02x}{:04x}".format(cart_id,int(cart_offset/2))
        for b in data_block['data']:
            yield b
    if record_offsets:
        track_offsets['data']=actual_offsets
    
# dry run to get offsets
i = 0
it = create_data_iterator(True)
for b in it:
    i += 1
    cart_offset+=1
    # full cart?
    if i==2*0x4300:
        cart_id += 1
        cart_offset = 0
        i = 0

# actual export
cart_id = 0
s = ""
it = create_data_iterator(False)
for b in it:
    s += b
    # full cart?
    if len(s)==2*0x4300:
        to_cart(s,"vracing",cart_id)
        cart_id += 1
        s = ""
# remaining data?
if len(s)!=0:
    to_cart(s,"vracing",cart_id)

export_cmd=""
for i in range(0,cart_id+1):
    export_cmd += "vracing_{}.p8 ".format(i)
print("export index.html {} vracing_main.p8 vracing_title.p8".format(export_cmd,version))
print("export vracing.bin {} vracing_main.p8 vracing_title.p8".format(export_cmd,version))

# carts=""
# for i in range(13):
#     carts += "vracing_{}.p8 ".format(i)
# print("export vracing_v03.bin {} vracing_main.p8 vracing_title.p8".format(carts))

# export vracing_v03.bin vracing_0.p8 vracing_1.p8 vracing_2.p8 vracing_3.p8 vracing_4.p8 vracing_5.p8 vracing_6.p8 vracing_7.p8 vracing_8.p8 vracing_9.p8 vracing_10.p8 vracing_11.p8 vracing_12.p8  vracing_main.p8 vracing_title.p8
