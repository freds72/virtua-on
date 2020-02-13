import bpy
import bmesh
import mathutils
from mathutils import Vector, Matrix

# loop through edges, get vertices in logical order
def get_track_vertices_rec(bm,obcontext,start_vert,track_vg,fwd,side,count,out):
    # end of processing
    if count<0:
        return
    out.append(start_vert)
    # connected verts + switch between bmvert/vert :[
    bm_start_vert = bm.verts[start_vert.index]
    for v in [ob.data.vertices[e.other_vert(bm_start_vert).index] for e in bm_start_vert.link_edges]:
        if track_vg.index in [vg.group for vg in v.groups]:
            # direction?
            next_fwd = v.co - start_vert.co
            if fwd.dot(next_fwd)>0:
                # print("found: {}".format(v.index))
                get_track_vertices_rec(bm,obcontext,v,track_vg,next_fwd,side,count-1,out)
                break

# 
def get_track_vertices(obcontext,side):
    obdata = obcontext.data
    bm = bmesh.new()
    bm.from_mesh(obdata)
    bm.verts.ensure_lookup_table()

    # get first vertex
    chkpt_vg = obcontext.vertex_groups.get('CHECKPT_{}_2'.format(side))
    start_vert = [v for v in obcontext.data.vertices if chkpt_vg.index in [ vg.group for vg in v.groups ]][0]
    track_vg = obcontext.vertex_groups.get('TRACK_{}'.format(side))
    vert_count = len([v for v in obcontext.data.vertices if track_vg.index in [ vg.group for vg in v.groups ]])
    # all tracks are starting 'fwd'
    fwd = Vector((0,1,0))
    out = []
    get_track_vertices_rec(bm,obcontext,start_vert,track_vg,fwd,side,vert_count-1,out)
    return out
   
scene = bpy.context.scene
ob = [o for o in scene.objects if o.name == 'track'][0]
right_track = get_track_vertices(ob,'R')
left_track = get_track_vertices(ob,'L')
rlen = len(right_track)
llen = len(left_track)
if rlen!=llen:
    raise Exception('Right/left track length mismatch: {} vs. {}'.format(rlen,llen))

# export pairs
mat = ob.matrix_world
s = "local track={\n"
for i in range(0,rlen):
    rv = right_track[i]
    lv = left_track[i]
    rloc = mat * rv.co
    lloc = mat * lv.co
    s += "\t{{{},0,{}}},{{{},0,{}}}".format(round(lloc.x,2), round(lloc.y,2), round(rloc.x,2), round(rloc.y,2))
    if i!=rlen-1:
        s += ",\n"
s += "}"
print(s)
