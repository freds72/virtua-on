import os
from subprocess import Popen, PIPE
import re
import tempfile
import random
import math

local_dir = os.path.dirname(os.path.realpath(__file__))
blender_dir = os.path.expandvars("%programfiles%/Blender Foundation/Blender")

def call(args):
    proc = Popen(args, stdout=PIPE, stderr=PIPE)
    out, err = proc.communicate()
    exitcode = proc.returncode
    #
    return exitcode, out, err

# data buffer
s = ""

# 3d models
file_list = ['title_car','title_track','title_markings']
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

def to_cart(s, name):
    # pico-8 map format
    # 4096 bytes -> map
    if len(s)>=2*4096:
        raise Exception('Data string too long ({})'.format(len(s)))

    cart = ""
    cart_path = os.path.join(local_dir, "..", "carts", name)
    with open(cart_path, 'r', encoding='utf8') as content_file:
        # 0: skip
        # 1: replacing
        # 2: next section
        state = 0
        pattern = re.compile('__([a-z]+)__$')
        for line in content_file:
            match = pattern.match(line)
            if match:
                if match.group(1)=='map':
                    state = 1
                elif state==2:
                    state = 0  # any other group after map: write back

            if state==0:
                cart += line
            elif state==1:
                map_data=s
                if len(map_data)>0:
                    cart += "__map__\n"
                    cart += re.sub("(.{256})", "\\1\n", map_data, 0, re.DOTALL)
                    cart += "\n"
                # skip any old data
                state=2

    f = open(cart_path, "w", encoding='utf8')
    f.write(cart)
    f.close()

to_cart(s,"title.p8")