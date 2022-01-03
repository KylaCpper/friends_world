extends VoxelTerrain
#var thread := Thread.new()

var damage_block_particles := preload("res://tscn/particle/block/hurt_big.tscn")
var place_block_particles := preload("res://tscn/particle/block/place.tscn")

func _event(world_pos3:Vector3) -> bool:
	var block_pos3 = get_block_pos3(world_pos3)
	var vt := get_voxel_tool()
	var id = vt.get_voxel(block_pos3)
	if id:
		var block = Block.get(Block.list[id])
		if "script" in block:
			if block.script.has_method("_event"):
				return block.script._event(world_pos3)
			
	return false
func _walk(pos3:Vector3) -> String:
	var block_pos3 = get_block_pos3(pos3)
	var vt := get_voxel_tool()
	var audio_name = Block.get_name_from_id(vt.get_voxel(block_pos3))
	return audio_name
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
	set_material(0,load("res://tscn/world/terrain0.tres"))
	set_material(1,load("res://tscn/world/terrain1.tres"))
	set_material(2,load("res://tscn/world/terrain2.tres"))
	set_material(3,load("res://tscn/world/terrain3.tres"))
	set_material(4,load("res://tscn/world/terrain4.tres"))
	set_material(5,load("res://tscn/world/terrain5.tres"))
	set_material(6,load("res://tscn/world/terrain6.tres"))
	set_material(7,load("res://tscn/world/terrain7.tres"))
	self.generator = Generator.voxelgenerator
	self.mesher = Terrain.voxel_mesher
#	view_distance = 208+16
	self.max_view_distance = 208
func place(world_pos3:Vector3,name_:String,dire:=0) -> bool:
	var vt := get_voxel_tool()
	var block_pos3 = get_block_pos3(world_pos3)
	dire = Block.check_dire(name_,dire)
	var id = Block.get_global_id(name_,dire)
	if !vt.get_voxel(block_pos3):
		if !Overall.terrain_node_node.can_place(block_pos3):
			return false
		vt.set_voxel(block_pos3,id)
		var cpos3 = get_chunk_pos3(world_pos3)
		var key = [cpos3.x,cpos3.y,cpos3.z]
		var key2 = [block_pos3.x,block_pos3.y,block_pos3.z]
		if !key in Terrain.map:
			Terrain.map[key]={}
		if !key2 in Terrain.map[key]:
			Terrain.map[key][key2] = id
		Terrain.map[key][key2] = id
		create_par_place(name_,block_pos3)
		return true
	else:
		return false
func damage(world_pos3:Vector3) -> bool:
	var vt := get_voxel_tool()
	var block_pos3 = get_block_pos3(world_pos3)
	var id = vt.get_voxel(block_pos3)
	if id:
		vt.set_voxel(block_pos3,0)
		create_par_damage(Block.get_name_from_id(id),block_pos3)
		return true
	else:
		return false

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

func get_name_(world_pos3:Vector3) -> String:
	var vt := get_voxel_tool()
	var id = vt.get_voxel(world_pos3)
	return Block.get_name_from_id(id)
	
func get_block_pos3(world_pos3:Vector3) -> Vector3:
	world_pos3.x = floor(world_pos3.x)
	world_pos3.y = floor(world_pos3.y)
	world_pos3.z = floor(world_pos3.z)
	world_pos3 += Vector3(0.5,0.5,0.5)
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

