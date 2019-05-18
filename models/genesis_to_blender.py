import sys
import os
import math
import struct
import bpy
import bmesh

def makeMaterial(name, diffuse, culling):
    mat = bpy.data.materials.new(name)
    mat.diffuse_color = diffuse
    mat.diffuse_shader = 'LAMBERT' 
    mat.game_settings.use_backface_culling = culling
    return mat
 

mem_offset = 0x00138200 # Track 1 (Genesis)
# mem_offset = 0x0014c200 # Track 2 (Genesis)
# mem_offset = 0x00164290 # Track 2 (Genesis)
# mem_offset = 0x0014c200
# mem_offset = 0x00108000
# mem_offset = 0xa000 # start of poly data (32x)

# clear materials
for material in bpy.data.materials:
    material.user_clear()
    bpy.data.materials.remove(material)

# Create mesh 
me = bpy.data.meshes.new('track') 

# Create object
ob = bpy.data.objects.new('track', me)   

#ob.location = origin
ob.show_name = True

# Link object to scene
bpy.context.scene.objects.link(ob)

# Get a BMesh representation
bm = bmesh.new()   # create an empty BMesh
bm.from_mesh(me)   # fill it in from a Mesh
 
with open(os.path.join("C:\\Users\\Frederic\\Source\\Repos\\virtua-on\\models","Virtua Racing (USA).md"), 'rb') as rom_file:
    rom_file.seek(mem_offset)
    for o in range(128):
        # format: http://forums.sonicretro.org/index.php?showtopic=38296
        unknown_flag = rom_file.read(1)
        # number of faces
        faces_count = rom_file.read(1)[0]+1
        for i in range(faces_count):
            # colors
            face_colors = rom_file.read(1)[0]
            # face flags
            face_flags = rom_file.read(1)[0]
            # get/create material
            mat_name = "{:02x}{}".format(face_colors & 0xff,"_dual" if 0x40 & face_flags==0 else "")
            mat_index = -1
            mat = ob.data.materials.get(mat_name)
            if mat!=None:
                print("reusing material")
            else:
                color = face_colors / 0xff
                mat = makeMaterial(mat_name,(color,color,color),(0x40 & face_flags)!=0)
                ob.data.materials.append(mat)
                
            # silly loop to find material_index in object context :[
            # https://blender.stackexchange.com/questions/28589/meshs-material-index-is-an-index-into-what
            mat_index = -1
            for i in range(len(ob.material_slots)):
                m = ob.material_slots[i]
                if m.name == mat_name:
                    mat_index = i
                    break
            print("material index: {}".format(mat_index))
            
            vertex_count = 3 if (0x10 & face_flags) == 0x10 else 4
            verts = []
            for k in range(vertex_count):                    
                x = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                y = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                z = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                verts.append(bm.verts.new( (x/256, z/256, y/256) ))            
            new_face = bm.faces.new( verts )
            new_face.material_index = mat_index
            
# remove doubles
bmesh.ops.remove_doubles(bm, verts=bm.verts[:], dist=0.001)
# finalize mesh            
bm.to_mesh(me)