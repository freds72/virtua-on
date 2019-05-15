import sys
import os
import math
import struct
import bpy
import bmesh

mem_offset = 0x00138200 # Track 1 (Genesis)
# mem_offset = 0x0014c200 # Track 2 (Genesis)
# mem_offset = 0x00164290 # Track 2 (Genesis)
# mem_offset = 0x0014c200
# mem_offset = 0x00108000
# mem_offset = 0xa000 # start of poly data (32x)

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
            # face flags
            face_colors = rom_file.read(1)
            face_flags = rom_file.read(1)
            vertex_count = 3 if (0x10 & face_flags[0]) == 0x10 else 4
            verts = []
            for k in range(vertex_count):                    
                x = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                y = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                z = int.from_bytes(rom_file.read(2), byteorder='big', signed=True)
                verts.append(bm.verts.new( (x/1024, y/1024, z/1024) ))            
            bm.faces.new( verts )
bm.to_mesh(me)