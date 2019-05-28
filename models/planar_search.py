import bpy
import bmesh
import sys
import math
import mathutils
from mathutils import Vector, Matrix

epsilon = 0.001

scene = bpy.context.scene

obcontext = [o for o in scene.objects if o.type == 'MESH' and o.layers[0]][0]
obdata = obcontext.data
bm = bmesh.new()
bm.from_mesh(obdata)

group_idx = obcontext.vertex_groups['DETAIL_FACE'].index

group_verts = [v.index for v in obdata.vertices if group_idx in [ vg.group for vg in v.groups ] ]

# detail faces
detail_faces = [f for f in bm.faces if len(f.verts)==len([v for v in f.verts if v.index in group_verts])]

# faces to check against
other_faces = [f for f in bm.faces if f.index not in [f.index for f in detail_faces]]

print("details#: {} other #: {} total#: {}".format(len(detail_faces), len(other_faces), len(bm.faces)))

for f in detail_faces:
    # find coplanar faces
    coplanar = [of for of in other_faces if of.normal.dot(f.normal)>0.95]
    print("detail face: {} coplanar#: {}".format(f.index, len(coplanar)))
    for of in coplanar:
        v = of.verts[0].co - f.verts[0].co
        print("{} is coplanar: {}".format(of.index, f.normal.dot(v)))          
        if abs(f.normal.dot(v))<0.01:  
            # print("{} <-coplanar-> {}".format(f.index, of.index))
            # inside?
            is_inside = True    
            for of_point in of.verts:
                p0 = f.verts[len(f.verts)-1].co - of_point.co
                # shared vertex?
                if p0.length>epsilon:
                    for i_point in range(len(f.verts)):
                        p1 = f.verts[i_point].co - of_point.co
                        # shared vertex or colinear?
                        n = p0.cross(p1)
                        #print("p1: {} / n: {}".format(p1.length, n.length))
                        if p1.length>epsilon and n.length>0.02:
                            n.normalize()                 
                            if f.normal.dot(n)<-epsilon:
                                # is_inside = round(f.normal.dot(n),4)
                                # print("exit: {}".format(f.normal.dot(n)))
                                is_inside = False
                                break
                        p0 = p1.copy()
                # stop checking this other face
                if is_inside == False:
                    break
            print("{} is inside: {}".format(of.index, is_inside))
                
                    