import bpy
import bmesh
import argparse
import sys
import math
from mathutils import Vector, Matrix

argv = sys.argv
if "--" not in argv:
    argv = []
else:
   argv = argv[argv.index("--") + 1:]

try:
    parser = argparse.ArgumentParser(description='Exports Blender model as a byte array for wireframe rendering',prog = "blender -b -P "+__file__+" --")
    parser.add_argument('-o','--out', help='Output file', required=True, dest='out')
    args = parser.parse_args(argv)
except Exception as e:
    sys.exit(repr(e))

scene = bpy.context.scene

# charset
charset="_0123456789abcdefghijklmnopqrstuvwxyz"

def tohex(val, nbits):
    return (hex((int(round(val,0)) + (1<<nbits)) % (1<<nbits))[2:]).zfill(nbits>>2)

# variable length packing (1 or 2 bytes)
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

# float must be between -3.2/+3.2
def pack_float(x):
    h = "{:02x}".format(int(round(32*x+128,0)))
    if len(h)!=2:
        raise Exception('Unable to convert: {} into a byte: {}'.format(x,h))
    return h
# double must be between -128/+127 resolution: 0.0078
def pack_double(x):
    h = "{}".format(tohex(128*x+16384,16))
    if len(h)!=4:
        raise Exception('Unable to convert: {} into a word: {}'.format(x,h))
    return h

p8_colors = ['000000','1D2B53','7E2553','008751','AB5236','5F574F','C2C3C7','FFF1E8','FF004D','FFA300','FFEC27','00E436','29ADFF','83769C','FF77A8','FFCCAA']
def diffuse_to_p8color(rgb):
    h = "{:02X}{:02X}{:02X}".format(int(round(255*rgb.r)),int(round(255*rgb.g)),int(round(255*rgb.b)))
    try:
        #print("diffuse:{} -> {}\n".format(rgb,p8_colors.index(h)))
        return p8_colors.index(h)
    except Exception as e:
        # unknown color
        raise Exception('Unknown color: 0x{}'.format(h))

def export_layer(scale,l):
    # data
    s = ""
    layer = [ob for ob in scene.objects if ob.layers[l]]
    if len(layer)>0:
        obcontext = [o for o in layer if o.type == 'MESH'][0]
        obdata = obcontext.data
        bm = bmesh.new()
        bm.from_mesh(obdata)

        # create a map loop index -> vertex index (see: https://www.python.org/dev/peps/pep-0274/)
        loop_vert = {l.index:l.vertex_index for l in obdata.loops}

        vlen = len(obdata.vertices)
        # vertices
        s += pack_variant(vlen)
        for v in obdata.vertices:
            s += "{}{}{}".format(pack_double(v.co.x), pack_double(v.co.z), pack_double(v.co.y))

        # faces
        faces = []
        for i in range(len(obdata.polygons)):
            f=obdata.polygons[i]
            fs = ""
            color = 0x11
            is_dual_sided = False     
            len_verts = len(f.loop_indices)
            if len_verts>4:
                raise Exception('Face: {} has too many vertices: {}'.format(i,len_verts))
            # color / dual sided flag     
            if len(obcontext.material_slots)>0:
                slot = obcontext.material_slots[f.material_index]
                mat = slot.material
                is_dual_sided = mat.game_settings.use_backface_culling==False
                # colors are encoded as hex figures in Blender!
                color = int.from_bytes(bytes.fromhex(mat.name.split('_')[0]),'big')

            # face flags bit layout:
            # tri/quad:  2
            # dual-side: 1
            fs += "{:02x}".format(
                (2 if len_verts==4 else 0) + 
                (1 if is_dual_sided else 0))
            # color
            fs += "{:02x}".format(color)

            # + vertex id (= edge loop)
            for li in f.loop_indices:
                fs += "{:02x}".format(loop_vert[li]+1)
            faces.append({'face': f, 'flip': False, 'data': fs})

        # push face data to buffer (inc. dual sided faces)
        s += "{:02x}".format(len(faces))
        for f in faces:
            s += f['data']
                    
        # normals
        s += "{:02x}".format(len(faces))
        for f in faces:
            flip = -1 if f['flip'] else 1
            f = f['face']
            s += "{}{}{}".format(pack_float(flip * f.normal.x), pack_float(flip * f.normal.z), pack_float(flip * f.normal.y))       
    return s

# model data
s = ""

# select first mesh object
obcontext = [o for o in scene.objects if o.type == 'MESH' and o.layers[0]][0]

# object name
name = obcontext.name.lower()
s += "{:02x}".format(len(name))
for c in name:
    s += "{:02x}".format(charset.index(c)+1)

# scale (custom scene property)
model_scale = scene.get("scale", 1)
s += "{:02x}".format(model_scale)

# model lod selection (+ default value)
lod_dist = scene.get("lod_dist", [32])
s += "{:02x}".format(len(lod_dist))
for i in lod_dist:
    s += "{}".format(pack_double(i))

# layers = lod
ln = 0
ls = ""
for i in range(3):
    layer_data = export_layer(model_scale,i)
    if len(layer_data)>0:
        ln += 1
        ls = ls + layer_data
# number of active lods
s += "{:02x}".format(ln)
s += ls

#
with open(args.out, 'w') as f:
    f.write(s)

