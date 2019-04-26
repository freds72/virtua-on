import bpy

print("--- set vertices to grid ---")
print(bpy.context.selected_objects)
for ob in bpy.context.selected_objects:
    print(ob.name)
    if ob.type == "MESH":
        mesh = ob.data
        mat_world = ob.matrix_world
        for vert in mesh.vertices:
            pos_world = mat_world * vert.co
            pos_world.x = round(pos_world.x,0)
            pos_world.y = round(pos_world.y,0)
            pos_world.z = round(pos_world.z,0)
            print(pos_world)
            vert.co = mat_world.inverted() * pos_world
