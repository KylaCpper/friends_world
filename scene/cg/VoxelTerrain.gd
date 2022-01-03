extends terrain_main


func _event(world_pos3:Vector3) -> bool:
	return false
func _mouse_left(world_pos3:Vector3) -> bool:
	return false
func _walk(pos3:Vector3) -> String:
	return "wood"
#func _input(event):
#	if event.is_action_pressed("q"):
#		vt.mode = VoxelTool.MODE_ADD
#		var i = 0
#		for x in range(-10,10):
#			for z in range(200,210):
#				for y in range(-1,1):
#					i+=1
#					if i > 2048:
#						yield(get_tree(),"idle_frame")
#
#	#					i = 0
#	#				vt.do_sphere(Vector3(x,y,z),2)
#	#				vt.do_point(Vector3(x,y,z))
#					vt.set_voxel(Vector3(x,y,z),1)
func _ready() -> void:
	self.stream = null
			
	self.voxel_library = Terrain.voxel_lib
#	view_distance = 208+16
	self.max_view_distance = 0
#	$Spatial.translation = pos3
#	viewer_path = @"Spatial"

func check(mask:=CollisionGroup.ALL):
	return false
func get_previous_position(mask:=CollisionGroup.ALL):
	return false
func place(vec3:Vector3,name_:String,dire:=0,par:=true) -> bool:
	return false
func damage(block_pos3:Vector3,fall:=false) -> bool:
	return false
func can_place(vec3:Vector3) -> bool:
	var vt := get_voxel_tool()
	var block_pos3 = get_block_pos3(vec3)
	var id = vt.get_voxel(block_pos3)
	if id:
		return false
	else:
		return true
	
func create_par_place(name_:String,block_world_pos3:Vector3) -> void:
	var tscn = place_block_particles.instance()
	tscn.translation = block_world_pos3
	tscn.name_ = name_
	Overall.terrain_node_node.add_child(tscn)
func create_par_damage(name_:String,block_world_pos3:Vector3) -> void:
	var tscn = damage_block_particles.instance()
	tscn.translation = block_world_pos3
	tscn.name_ = name_
	Overall.terrain_node_node.add_child(tscn)

func get_name_(world_pos3:Vector3,ignore_liquid:=false) -> String:
	var vt := get_voxel_tool()
	var id = vt.get_voxel(world_pos3)
	return Block.get_name_from_id(id)
	
func get_block_pos3(world_pos3:Vector3) -> Vector3:
	world_pos3.x = floor(world_pos3.x)
	world_pos3.y = floor(world_pos3.y)
	world_pos3.z = floor(world_pos3.z)
#	world_pos3 += Vector3(0.5,0.5,0.5)
	return world_pos3
func get_global_block_pos3(world_pos3:Vector3) -> Vector3:
	world_pos3.x = floor(world_pos3.x)
	world_pos3.y = floor(world_pos3.y)
	world_pos3.z = floor(world_pos3.z)
	world_pos3 += Vector3(0.5,0.5,0.5)
	return world_pos3

func get_chunk_pos3(world_pos3:Vector3) -> Vector3:
	var chunk_pos3 = world_pos3/16
	chunk_pos3 = Vector3(int(floor(chunk_pos3.x)),int(floor(chunk_pos3.y)),int(floor(chunk_pos3.z)))
	return chunk_pos3

	
