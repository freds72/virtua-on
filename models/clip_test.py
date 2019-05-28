import bpy
import bmesh
import argparse
import sys
import math
import mathutils
from mathutils import Vector, Matrix
from collections import defaultdict

def voxel_bbox2d_intersects(i,j,w,b):
  return (abs(i - b[0]) * 2 < (w + b[2])) and (abs(j - b[1]) * 2 < (w + b[3]))

def verts_to_bbox2d(verts):
    xs = [v.co.x for v in verts]
    ys = [v.co.y for v in verts]
    return (min(xs), min(ys), max(xs)-min(xs), max(ys)-min(ys))

voxel_w = 8
voxel_planes = (
        (Vector((0,0,0)),(0,-1,0)),
        (Vector((voxel_w,0,0)),(1,0,0)),
        (Vector((voxel_w,voxel_w,0)),(0,1,0)),
        (Vector((0,voxel_w,0)),(-1,0,0))
    )
    
scene = bpy.context.scene
obcontext = [o for o in scene.objects if o.type == 'MESH' and o.layers[0]][0]
obdata = obcontext.data
bm = bmesh.from_edit_mesh( obdata )

# clip face against voxel borders
res = bmesh.ops.bisect_plane(bm, geom = bm.verts[:] + bm.edges[:] + bm.faces[0:1], dist = 0, plane_co = (0,0,0),plane_no = (1,0,0), clear_outer = True)
print(res)
bmesh.ops.split_edges(bm, edges=[e for e in res['geom_cut'] if isinstance(e, bmesh.types.BMEdge)])                
    
bmesh.update_edit_mesh(obdata)  