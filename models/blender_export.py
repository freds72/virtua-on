import bpy
import bmesh
import argparse
import sys
import math
from mathutils import Vector, Matrix
from collections import defaultdict

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
        return "{:04x}".format(x + 0x8000)
    # 1 byte
    return "{:02x}".format(x)

# short must be between -127/127
def pack_short(x):
    h = "{:02x}".format(int(round(x+128,0)))
    if len(h)!=2:
        raise Exception('Unable to convert: {} into a byte: {}'.format(x,h))
    return h

# float must be between -3.2/+3.2
def pack_float(x):
    h = "{:02x}".format(int(round(32*x+128,0)))
    if len(h)!=2:
        raise Exception('Unable to convert: {} into a byte: {}'.format(x,h))
    return h
# double must be between -2046/+2046
def pack_double(x):
    h = "{}".format(tohex(16*x+16384,16))
    if len(h)!=4:
        raise Exception('Unable to convert: {} into a double-byte: {}'.format(x,h))
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

def export_object(obcontext):
    # data
    s = ""
    obdata = obcontext.data
    bm = bmesh.new()
    bm.from_mesh(obdata)

    # create vertex group lookup dictionary for names
    vgroup_names = {vgroup.index: vgroup.name for vgroup in obcontext.vertex_groups}
    # create dictionary of vertex group assignments per vertex
    vgroups = {v.index: [vgroup_names[g.group] for g in v.groups] for v in obdata.vertices}

    # create a map loop index -> vertex index (see: https://www.python.org/dev/peps/pep-0274/)
    loop_vert = {l.index:l.vertex_index for l in obdata.loops}

    # vertices
    s = s + pack_variant(len(obdata.vertices))
    mat_world = obcontext.matrix_world
    for v in obdata.vertices:
        pos_world = mat_world * v.co
        s = s + "{}{}{}".format(pack_short(pos_world.x), pack_short(pos_world.z), pack_short(pos_world.y))

    # normals must be computed

    # faces
    s = s + pack_variant(len(obdata.polygons))
    for i in range(len(obdata.polygons)):
        f=obdata.polygons[i]
        fs = ""
        # bit layout:
        # quad:      5
        # dual-side: 4
        # color:     0-3
        is_dual_sided = False
        color = 1
        len_verts =len(f.loop_indices)
        if len_verts>4:
             raise Exception('Face: {} too many vertices: {}'.format(i,len_verts))
        if len(obcontext.material_slots)>0:
            slot = obcontext.material_slots[f.material_index]
            mat = slot.material
            is_dual_sided = mat.game_settings.use_backface_culling==False
            color = diffuse_to_p8color(mat.diffuse_color)

        fs = fs + "{:02x}".format(
            (32 if len_verts==4 else 0) + 
            (16 if is_dual_sided else 0) + 
            color)

        # + vertex id (= edge loop)
        for li in f.loop_indices:
            fs = fs + pack_variant(loop_vert[li]+1)
        # done
        s = s + fs
    
    # voxels
    voxels=defaultdict(set)
    for v in bm.verts:
        pos_world = mat_world * v.co
        x = (pos_world.x + 128)
        y = (pos_world.y + 128)
        if x<0 or y<0 or x>255 or y>255:
            raise Exception('Invalid vertex: {}'.format(pos_world))
        voxel = int(math.floor(x/8)) + 16*int(math.floor(y/8))
        if voxel<0 or voxel>255:
            raise Exception('Invalid voxel id: {} for {}/{}'.format(voxel,x,y))
        # find all connected faces
        # register in voxel
        for face in v.link_faces:
            voxels[voxel].add(face.index)

    # export voxels
    # number of cells
    s = s + "{:02x}".format(len(voxels.keys()))
    for k,v in voxels.items():
        # voxel ID
        s = s + "{:02x}".format(k)   
        # number of faces
        if len(v)>255:
            raise Exception('Voxel: {}/{} has too many faces: {}'.format(voxel%16,round(k/16,0),len(v)))
        s = s + pack_variant(len(v))
        # face indices
        for i in v:
            s = s + pack_variant(i+1)

    return s

# model data
s = ""

# select first mesh object
obcontext = [o for o in scene.objects if o.type == 'MESH' and o.layers[0]][0]

# object name
name = obcontext.name.lower()
s = s + "{:02x}".format(len(name))
for c in name:
    s = s + "{:02x}".format(charset.index(c)+1)

# scale (custom scene property)
model_scale = scene.get("scale", 1)
s = s + "{:02x}".format(model_scale)

s = s + export_object(obcontext)

#
with open(args.out, 'w') as f:
    f.write(s)

