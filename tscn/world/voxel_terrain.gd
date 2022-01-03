extends VoxelTerrain
class_name terrain_main
#var thread := Thread.new()
const voxelstream_class := preload("res://tscn/world/stream.gd")
const voxel_lib_class := preload("res://tscn/world/voxel_lib/voxel_lib.gd")

var damage_block_particles := preload("res://tscn/particle/block/hurt_big.tscn")
var place_block_particles := preload("res://tscn/particle/block/place.tscn")
#export var pos3 := Vector3()
#is_area_editable(aabb)
var arounds = [
	Vector3(0,1,0),
	Vector3(1,0,0),Vector3(-1,0,0),Vector3(0,0,1),Vector3(0,0,-1),
	Vector3(0,-1,0)
]
var update_orders = {}
onready var vt := get_voxel_tool()
func _event(world_pos3:Vector3) -> bool:
	
	var block_pos3 = get_block_pos3(world_pos3)
	var id = vt.get_voxel(block_pos3)
	if id:
		var block_key = Block.list[id]
		var block = Block.get(block_key)
		if "script" in block:
			if block.script.has_method("_event"):
				var dire = Block.get_dire(id)
				return block.script._event(world_pos3,block_key,dire)
			
	return false
func has_event(world_pos3:Vector3) -> bool:
	var block_pos3 = get_block_pos3(world_pos3)
	var id = vt.get_voxel(block_pos3)
	if id:
		var block_key = Block.list[id]
		var block = Block.get(block_key)
		if "script" in block:
			if block.script.has_method("_event"):
				return true
			
	return false
func _mouse_left(world_pos3:Vector3) -> bool:
	var block_pos3 = get_block_pos3(world_pos3)
	var id = vt.get_voxel(block_pos3)
	if id:
		var block_key = Block.list[id]
		var block = Block.get(block_key)
		if "script" in block:
			if block.script.has_method("_mouse_left"):
				var dire = Block.get_dire(id)
				return block.script._mouse_left(world_pos3,block_key,dire)
			
	return false
func singal_place(id:int,block_pos3:Vector3,dire:=0) -> void:
	var block_key = Block.get_name_from_id(id)
	var block = Block.get(block_key)
	if "script" in block:
		if block.script.has_method("_place"):
			block.script._place(block_pos3,block_key,dire)
func singal_damage(id:int,block_pos3:Vector3,dire:=0) -> void:
	var block_key = Block.get_name_from_id(id)
	var block = Block.get(block_key)
	if "script" in block:
		if block.script.has_method("_damage"):
			block.script.call_deferred("_damage",block_pos3,block_key,dire)


func update_around(block_pos3:Vector3) -> void:
	for offset in arounds:
		var block_pos3_be = block_pos3+offset
		var id = vt.get_voxel(block_pos3_be)
		if id:
			var block_key =Block.get_name_from_id(id)
			var block = Block.get(block_key)
			if "script" in block:
				if block.script.has_method("_update"):
					#防止update 过的方块 多次update
					if !block_pos3_be in update_orders:
						update_orders[block_pos3_be] = true
						var dire = Block.get_dire(id,block)
						block.script._update(block_pos3_be,block_key,dire)
						yield(get_tree(),"idle_frame")
						yield(get_tree(),"idle_frame")
						update_orders.erase(block_pos3_be)
						
						
						
						
func _walk(pos3:Vector3) -> String:
#	var block_pos3 = get_block_pos3(pos3)
	var audio_name = Block.get_name_from_id(vt.get_voxel(pos3))
	if audio_name == "air":
		var offset_x = pos3.x - int(pos3.x)
		
		if offset_x >=0.5:
			audio_name = Block.get_name_from_id(vt.get_voxel(pos3+Vector3(1,0,0)))
		else:
			audio_name = Block.get_name_from_id(vt.get_voxel(pos3-Vector3(1,0,0)))
		if audio_name == "air":
			var offset_z = pos3.z - int(pos3.z)
			if offset_z >=0.5:
				audio_name = Block.get_name_from_id(vt.get_voxel(pos3+Vector3(0,0,1)))
			else:
				audio_name = Block.get_name_from_id(vt.get_voxel(pos3-Vector3(0,0,1)))
			if audio_name == "air":
				if offset_x >=0.5:
					if offset_z >=0.5:
						audio_name = Block.get_name_from_id(vt.get_voxel(pos3+Vector3(1,0,1)))
					else:
						audio_name = Block.get_name_from_id(vt.get_voxel(pos3+Vector3(1,0,-1)))
				else:
					if offset_z >=0.5:
						audio_name = Block.get_name_from_id(vt.get_voxel(pos3+Vector3(-1,0,1)))
					else:
						audio_name = Block.get_name_from_id(vt.get_voxel(pos3+Vector3(-1,0,-1)))
				
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
#					set_voxel(Vector3(x,y,z),1)
func _on_block_load(cpos3:Vector3) -> void:
	pass
#	var x = str(cpos3.x)
#	var y = str(cpos3.y)
#	var z = str(cpos3.z)
#	if x in list:
#		if y in list[x]:
#			if z in list[x][y]:
#				for pos3_arr in list[x][y][z]:
#					var name_ = list[x][y][z][pos3_arr]
#					var pos3 = Function.arr_vec(pos3_arr)
#					var id = vt.get_voxel(pos3)
#					if Block.get_name_from_id(id) == name_:
#						var block = Block.get(get_name_(pos3))
#
#						var dire = Block.get_dire(id,block)
#						block.script.place_real([pos3,name_,dire])
#				list[x][y].erase(z)
#var list = {}
#func queue_place_real(pos3:Vector3,name_:String) -> void:
#	var cpos3 = get_chunk_pos3(pos3)
#	var x = str(cpos3.x)
#	var y = str(cpos3.y)
#	var z = str(cpos3.z)
#	var pos3_arr = Function.vec_arr(pos3)
#	if x in list:
#		if y in list[x]:
#			if z in list[x][y]:
#				if !pos3_arr in list[x][y][z]:
#					list[x][y][z][pos3_arr] = name_
#			else:
#				list[x][y][z] = {}
#				list[x][y][z][pos3_arr] = name_
#		else:
#			list[x][y] = {}
#			list[x][y][z] = {}
#			list[x][y][z][pos3_arr] = name_
#	else:
#		list[x] = {}
#		list[x][y] = {}
#		list[x][y][z] = {}
#		list[x][y][z][pos3_arr] = name_
func _ready() -> void:
	connect("block_loaded",self,"_on_block_load")
	update_orders = {}
	Overall.terrain_main_node = self
	set_material(0,load("res://tscn/world/terrain0.tres"))
	set_material(1,load("res://tscn/world/terrain1.tres"))
	set_material(2,load("res://tscn/world/terrain2.tres"))
	set_material(3,load("res://tscn/world/terrain3.tres"))
	set_material(4,load("res://tscn/world/terrain4.tres"))
	set_material(5,load("res://tscn/world/terrain5.tres"))
	set_material(6,load("res://tscn/world/terrain6.tres"))
	set_material(7,load("res://tscn/world/terrain7.tres"))

	if !Terrain.voxelstream:
		Terrain.voxelstream = voxelstream_class.new()
		
	self.stream = Terrain.voxelstream
	self.generator = Generator.voxelgenerator
#	self.stream = Generator.voxelgenerator
	self.mesher = Terrain.voxel_mesher
#	view_distance = 208+16
	self.max_view_distance = 208+16
#	$Spatial.translation = pos3

func check(mask:=CollisionGroup.ALL):
	var origin = Overall.player_node.get_camera().get_global_transform().origin
	var forward = Overall.player_node.get_camera().get_global_transform().basis.xform(Vector3(0,0,-1))
	var length = Overall.player_node.get_length()

	var obj = vt.raycast(origin, forward, length,mask)
	if obj:
		var id = vt.get_voxel(obj.position)
		if id:
#			set_voxel(obj.position,0)
			return obj.position

	return false
func get_ray_distance(origin,forward,length,mask:=CollisionGroup.ALL):
	var obj = vt.raycast(origin, forward, length,mask)
	if obj:
		return obj.distance
	else: 
		return false
func get_previous_position(mask:=CollisionGroup.ALL):
	var origin = Overall.player_node.get_camera().get_global_transform().origin
	var forward = Overall.player_node.get_camera().get_global_transform().basis.xform(Vector3(0,0,-1))
	var length = Overall.player_node.get_length()
	var obj = vt.raycast(origin, forward, length,mask)
	if obj:
#		var id = vt.get_voxel(obj.previous_position)
#		if !id:
		return obj.previous_position

	return false
func place(vec3:Vector3,block_name:String,dire:=0,par:=true) -> bool:
	var block_pos3 = get_block_pos3(vec3)
	dire = Block.check_dire(block_name,dire)
	var id = Block.get_global_id(block_name,dire)
	if !Overall.terrain_node_node.can_place(block_pos3,0.5,true):
		return false
	
	set_voxel(block_pos3,id)
	if par:
		create_par_place(block_name,block_pos3)
	singal_place(id,block_pos3,dire)
	update_around(block_pos3)
	
	return true
func add_block(pos3:Vector3,block_key:String,dire:=0,update:=false) -> void:
	var id := 0
	if block_key:
		dire = Block.check_dire(block_key,dire)
		id = Block.get_global_id(block_key,dire)
	set_voxel(pos3,id)
	if update:
		singal_place(id,pos3,dire)
		update_around(pos3)
func damage(vec3:Vector3,par:=true) -> bool:
	var block_pos3 = get_block_pos3(vec3)
	var id = vt.get_voxel(block_pos3)
	if id:
		set_voxel(block_pos3,0)
		
		if par:
			create_par_damage(Block.get_name_from_id(id),block_pos3)
		var dire = Block.get_dire(id)
		singal_damage(id,block_pos3,dire)
		update_around(block_pos3)
		return true
	else:
		return false

func place_fall(vec3:Vector3,block_name:String,dire:=0,force:=0.0) -> float:
#	var block_pos3 = vec3
	
	var block_pos3 = get_block_pos3(vec3)
	dire = Block.check_dire(block_name,dire)
	var id = Block.get_global_id(block_name,dire)
	var block = Block.get(block_name)
	var crash := false
	var smash_s = -1
	if block.liquid:
		return force

	if block.script.has_method("_smash"):
		smash_s = block.script._smash(block_pos3,block_name,force,true)
	if !smash_s == 0.0:
		if (force > block.intensity*Config.gravity)||block.smash==2:
			singal_damage(id,block_pos3,dire)
			create_par_damage(block_name,block_pos3)
			create_fall_drop(block_pos3,block_name)
			
			crash = true
	if smash_s == 0.0:
		crash = true
	force = smash(block_pos3+Vector3(0,-1,0),force,block.smash)
	if crash:
		force = 0.0
	else:
		if force <= 0.0:
			set_voxel(block_pos3,id)
			
			singal_place(id,block_pos3,dire)
			create_par_place(block_name,block_pos3)
	update_around(block_pos3)
	return force



func smash(block_pos3:Vector3,force:float,pre_smash:=0) -> float:
	var id = vt.get_voxel(block_pos3)
	if id:
		var block_name = Block.get_name_from_id(id)
		var block = Block.get(block_name)
		if block.script.has_method("_smash"):
			return block.script._smash(block_pos3,block_name,force,false)
		if force > block.intensity*Config.gravity || !block.entity || block.smash==2:
			damage(block_pos3)
			create_fall_drop(block_pos3,block_name)
		force -= block.intensity*Config.gravity
		if force <= 0:
			if pre_smash==1&&!block.entity || block.liquid:
				return 0.01
			
		return force
			
	return 0.0
func create_fall_drop(block_pos3,block_name) -> void:
	block_pos3+=Vector3(0.5,0.5,0.5)
	var block = Block.get(block_name)
	if !block.liquid:
		if "fall" in block.drop:
			for drop in block.drop.fall:
				var success = Overall.terrain_node_node.create_drop(block_pos3,drop)
				if drop.stop && success:return
#		else:
#			Overall.terrain_node_node.create_drop(block_pos3,{"name":block_name,"num":1})
func is_entity(vec3:Vector3) ->bool:
	var id = vt.get_voxel(vec3)
	if id:
		var block = Block.get(Block.get_name_from_id(id))
		if block.entity:
			return true
		return false
	else:
		return false
func is_exist(vec3:Vector3,ignore_liquid:=false) -> bool:
	var id = vt.get_voxel(vec3)
	if id:
		if ignore_liquid:
			var block = Block.get(Block.get_name_from_id(id))
			if block.liquid:
				return false
		return true
	else:
		return false
func is_liquid(vec3:Vector3) -> bool:
	var id = vt.get_voxel(vec3)
	if id:
		var block = Block.get(Block.get_name_from_id(id))
		return block.liquid
	else:
		return false
func get_block(vec3:Vector3):
	var id = vt.get_voxel(vec3)
	if id:
		var block = Block.get(Block.get_name_from_id(id))
		return block
	else:
		return false
func set_voxel(block_pos3:Vector3,id:int) -> void:
	Overall.chunks_node_node.rpc2("set_voxel_client",block_pos3,id)
	if id == 0:
		var id_ = vt.get_voxel(block_pos3)
		if id_ != 0:
			var bn = Block.get_name_from_id(id_)
#			var script = Block.get(bn).script
#			if "list" in script:
#				var pos3_arr = Function.vec_arr(block_pos3)
#				if pos3_arr in script.list:
#					Terrain.del_box(block_pos3,script)
			Overall.audio_node.damage(bn,block_pos3+Vector3(0.5,0.5,0.5))
	else:
		var id_ = vt.get_voxel(block_pos3)
		if id_ == 0:
			Overall.audio_node.place(Block.get_name_from_id(id),block_pos3+Vector3(0.5,0.5,0.5))
	if Net.is_master():
		Terrain.add(block_pos3,id)
	vt.set_voxel(block_pos3,id)
func set_voxel_client(block_pos3:Vector3,id:int) -> void:
	if id == 0:
		var id_ = vt.get_voxel(block_pos3)
		if id_ != 0:
			Overall.audio_node.damage(Block.get_name_from_id(id_),block_pos3+Vector3(0.5,0.5,0.5))
	else:
		var id_ = vt.get_voxel(block_pos3)
		if id_ == 0:
			Overall.audio_node.place(Block.get_name_from_id(id),block_pos3+Vector3(0.5,0.5,0.5))
	if Net.is_master():
		Terrain.add(block_pos3,id)
	vt.set_voxel(block_pos3,id)
	
func set_voxel_ignore(block_pos3:Vector3,id:int) -> void:
	Overall.chunks_node_node.rpc2("svic",block_pos3,id)
	vt.set_voxel(block_pos3,id)
#set_voxel_ignore_client
func svic(block_pos3:Vector3,id:int) -> void:
	vt.set_voxel(block_pos3,id)
	
var debris_tscn := preload("res://tscn/particle/block/debris.tscn")
var par_places := [
	[Vector3(0,0,0),Vector3(-1,0.5,-1)],
	[Vector3(1,0,1),Vector3(1,0.5,1)],
	[Vector3(0,0,1),Vector3(-1,0.5,1)],
	[Vector3(1,0,0),Vector3(1,0.5,-1)],
	
	[Vector3(0,0,0.33),Vector3(-1,0.5,0)],
	[Vector3(0,0,0.66),Vector3(-1,0.5,0)],
	
	[Vector3(0.33,0,0),Vector3(0,0.5,-1)],
	[Vector3(0.66,0,0),Vector3(0,0.5,-1)],
	
	[Vector3(1,0,0.33),Vector3(1,0.5,0)],
	[Vector3(1,0,0.66),Vector3(1,0.5,0)],
	
	[Vector3(0.33,0,1),Vector3(0,0.5,1)],
	[Vector3(0.66,0,1),Vector3(0,0.5,1)],
]
func create_par_place(block_name:String,block_pos3:Vector3) -> void:
	Overall.chunks_node_node.rpc2("create_par_place_client",block_name,block_pos3)
	if Overall.par_num < 100:
		for data in par_places:
			var debris = debris_tscn.instance()
			var hand = Overall.player_node.get_hand()
			debris.name_ = block_name
			debris._scale(0.9)
			debris.translation = block_pos3+data[0]
			var dire_offset = data[1]
			debris.set_velocity(dire_offset*(randf()+1.0))
			Overall.terrain_node_node.call_deferred("add_child",debris)
		
func create_par_damage(block_name:String,block_pos3:Vector3) -> void:
	Overall.chunks_node_node.rpc2("create_par_damage_client",block_name,block_pos3)
	if Overall.par_num < 100:
		for i in range(8):
			var debris = debris_tscn.instance()
			var hand = Overall.player_node.get_hand()
			debris.name_ = block_name
			debris._scale(0.9)
			debris.translation = block_pos3+Vector3(randf(),randf(),randf())
			var dire_offset = Vector3((randf()-0.5)*2,1.0,(randf()-0.5)*2)
			debris.set_velocity(dire_offset)
			Overall.terrain_node_node.call_deferred("add_child",debris)

func create_par_place_client(block_name:String,block_pos3:Vector3) -> void:
	if Overall.par_num < 100:
		for data in par_places:
			var debris = debris_tscn.instance()
			var hand = Overall.player_node.get_hand()
			debris.name_ = block_name
			debris._scale(0.9)
			debris.translation = block_pos3+data[0]
			var dire_offset = data[1]
			debris.set_velocity(dire_offset*(randf()+1.0))
			Overall.terrain_node_node.call_deferred("add_child",debris)
func create_par_damage_client(block_name:String,block_pos3:Vector3) -> void:
	if Overall.par_num < 100:
		for i in range(8):
			var debris = debris_tscn.instance()
			var hand = Overall.player_node.get_hand()
			debris.name_ = block_name
			debris._scale(0.9)
			debris.translation = block_pos3+Vector3(randf(),randf(),randf())
			var dire_offset = Vector3((randf()-0.5)*2,1.0,(randf()-0.5)*2)
			debris.set_velocity(dire_offset)
			Overall.terrain_node_node.call_deferred("add_child",debris)
func get_name_(world_pos3:Vector3,ignore_liquid:=false) -> String:
	world_pos3 = get_block_pos3(world_pos3)
	var id = vt.get_voxel(world_pos3)
	if id:
		var name_ = Block.get_name_from_id(id)
		if ignore_liquid:
			var block = Block.get(name_)
			if block.liquid:
				return ""
		return name_
	else:
		return ""
func get_id(world_pos3:Vector3) -> int:
	world_pos3 = get_block_pos3(world_pos3)
	var id = vt.get_voxel(world_pos3)
	return id
func get_key(world_pos3:Vector3,ignore_liquid:=false) -> String:
	return get_name_(world_pos3,ignore_liquid)

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


func _process(delta:float) -> void:
	if !Net.is_master():return
	var r = 100
	var center = Overall.player_node.transform.origin.floor()
	var area = AABB(center - Vector3(r, r, r), Vector3(r, r, r)*2)
	vt.run_blocky_random_tick(
		area, 1024, funcref(self, "_random_tick"),
		16)
func _random_tick(pos3: Vector3, value: int) -> void:
	var block_key = Block.get_name_from_id(value)
	var block = Block.get(block_key)
	if block.script.has_method("_random_tick"):
		if !((randi() % block.tick) < 10):return
		block.script._random_tick(pos3,block,block_key)
func is_area(aabb) -> bool:
	return vt.is_area_editable(aabb)
#client

			
var fall_tscn := preload("res://tscn/block/fall/fall.tscn")
func create_fall_client(args:Array) -> void:
	var pos3 = args[0]
	var block_name = args[1]
	var dire = args[2]

	var tscn = fall_tscn.instance()
	tscn.translation = pos3
	tscn.name_ = block_name
	tscn.dire = dire
	Overall.terrain_node_node.add_child(tscn)
