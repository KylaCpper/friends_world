extends Node
var noise := OpenSimplexNoise.new()

var random := RandomNumberGenerator.new()

var seed_num := 1
var world_length = 8
var visible_range = 2
var init_pos3 :=  Vector3(4,0,4)
var player_chunk_pos3 := Vector3(5,0,5)
var height = 256
var current_terrain = null
var map :={}
var map_queue := {}

const voxelstream_class := preload("res://tscn/world/stream.gd")
var voxelstream :voxelstream_class
const voxel_mesher_class := preload("res://tscn/world/voxel_lib/voxel_mesher.gd")
var voxel_mesher :voxel_mesher_class




func _ready() -> void:
#	randomize()
	voxel_mesher = voxel_mesher_class.new()
	seed_num = randi()
	init()
	
func init() -> void:
	noise.seed = seed_num
	noise.period = 128.0
	noise.octaves = 4
#	noise.lacunarity = 2.0
#	noise.persistence = 0.5
	random.seed = seed_num

func add(block_pos3:Vector3,id:int) -> void:
		var cpos3 = get_chunk_pos3(block_pos3)
		var ccpos3 = get_chunk_pos3(cpos3)
		var key1 = [ccpos3.x,ccpos3.y,ccpos3.z]
		var key2 = [cpos3.x,cpos3.y,cpos3.z]
		var key3 = [int(floor(block_pos3.x)),int(floor(block_pos3.y)),int(floor(block_pos3.z))]
		
		if !key1 in Terrain.map:
			Terrain.map[key1]={}
		if !key2 in Terrain.map[key1]:
			Terrain.map[key1][key2]={}
#		if !key3 in Terrain.map[key1][key2]:
#			Terrain.map[key1][key2][key3] = id
		
		Terrain.map[key1][key2][key3] = id
func sub(block_pos3:Vector3) -> void:
		var cpos3 = get_chunk_pos3(block_pos3)
		var ccpos3 = get_chunk_pos3(cpos3)
		var key1 = [ccpos3.x,ccpos3.y,ccpos3.z]
		var key2 = [cpos3.x,cpos3.y,cpos3.z]
		var key3 = [int(floor(block_pos3.x)),int(floor(block_pos3.y)),int(floor(block_pos3.z))]
		if !key1 in Terrain.map:
			Terrain.map[key1]={}
		if !key2 in Terrain.map[key1]:
			Terrain.map[key1][key2]={}
		Terrain.map[key1][key2][key3] = 0
func is_in(pos3) -> bool:
	var box = Save.world.box
	var cpos3 = get_chunk_pos3(pos3)
	var ccpos3 = get_chunk_pos3(cpos3)
	var key1 = [ccpos3.x,ccpos3.y,ccpos3.z]
	var key2 = [cpos3.x,cpos3.y,cpos3.z]
	var key3 = [int(floor(pos3.x)),int(floor(pos3.y)),int(floor(pos3.z))]
	if key1 in box:
		if key2 in box[key1]:
			if key3 in box[key1][key2]:
				return true
	return false
func is_in_id(pos3,id) -> bool:
	var box = Save.world.box
	var cpos3 = get_chunk_pos3(pos3)
	var ccpos3 = get_chunk_pos3(cpos3)
	var key1 = [ccpos3.x,ccpos3.y,ccpos3.z]
	var key2 = [cpos3.x,cpos3.y,cpos3.z]
	var key3 = [int(floor(pos3.x)),int(floor(pos3.y)),int(floor(pos3.z))]
	if key1 in box:
		if key2 in box[key1]:
			if key3 in box[key1][key2]:
				if box[key1][key2][key3] == id:
					return true
	return false
func get_save_from_pos3(pos3):
	var box = Save.world.box
	var cpos3 = get_chunk_pos3(pos3)
	var ccpos3 = get_chunk_pos3(cpos3)
	var key1 = [ccpos3.x,ccpos3.y,ccpos3.z]
	var key2 = [cpos3.x,cpos3.y,cpos3.z]
	var key3 = [int(floor(pos3.x)),int(floor(pos3.y)),int(floor(pos3.z))]
	if key1 in box:
		if key2 in box[key1]:
			if key3 in box[key1][key2]:
				return box[key1][key2][key3]
	return false
func get_save_from_id(pos3,id):
	var box = Save.world.box
	var cpos3 = get_chunk_pos3(pos3)
	var ccpos3 = get_chunk_pos3(cpos3)
	var key1 = [ccpos3.x,ccpos3.y,ccpos3.z]
	var key2 = [cpos3.x,cpos3.y,cpos3.z]
	var key3 = [int(floor(pos3.x)),int(floor(pos3.y)),int(floor(pos3.z))]
	if key1 in box:
		if key2 in box[key1]:
			if key3 in box[key1][key2]:
				if box[key1][key2][key3].id == id:
					return box[key1][key2][key3]
	return false
func set_box(pos3,obj):
	var box = Save.world.box
	var cpos3 = get_chunk_pos3(pos3)
	var ccpos3 = get_chunk_pos3(cpos3)
	var key1 = [ccpos3.x,ccpos3.y,ccpos3.z]
	var key2 = [cpos3.x,cpos3.y,cpos3.z]
	var key3 = [int(floor(pos3.x)),int(floor(pos3.y)),int(floor(pos3.z))]
	if !key1 in box:
		box[key1] = {}
	if !key2 in box[key1]:
		box[key1][key2]={}
	box[key1][key2][key3] = obj.model.duplicate(true)
	obj.list[key3] = box[key1][key2][key3]
func set_box_arr(pos3_arr,obj):
	var pos3 = Vector3(pos3_arr[0],pos3_arr[1],pos3_arr[2])
	set_box(pos3,obj)
func del_box(pos3,obj):
	var box = Save.world.box
	var cpos3 = get_chunk_pos3(pos3)
	var ccpos3 = get_chunk_pos3(cpos3)
	var key1 = [ccpos3.x,ccpos3.y,ccpos3.z]
	var key2 = [cpos3.x,cpos3.y,cpos3.z]
	var key3 = [int(floor(pos3.x)),int(floor(pos3.y)),int(floor(pos3.z))]
	if !key1 in box:
		return
	if !key2 in box[key1]:
		return
	box[key1][key2].erase(key3)
	obj.list.erase(key3)
	if box[key1][key2].size() == 0:box[key1].erase(key2)
	if box[key1].size() == 0: box.erase(key1)
func del_box_arr(pos3_arr,obj):
	var pos3 = Vector3(pos3_arr[0],pos3_arr[1],pos3_arr[2])
	del_box(pos3,obj)




func check_building(pos3:Vector3,obj) -> void:
	var terrain_main_node = Overall.terrain_main_node
	var suc := true
	for vec in obj.check_build_vecs:
		var b_m = obj.check_build_mat
		if typeof(vec) == TYPE_ARRAY:
			b_m = vec[1]
			vec = vec[0]
		if terrain_main_node.get_name_(pos3+vec) != b_m:
			suc = false
			break
	if suc:
		building(pos3,2,obj)
		return
	suc = true
	for vec in obj.check_build_vecs:
		var b_m = obj.check_build_mat
		if typeof(vec) == TYPE_ARRAY:
			b_m = vec[1]
			vec = vec[0]
		vec = Vector3(vec.z,vec.y,vec.x)
		if terrain_main_node.get_name_(pos3+vec) != b_m:
			suc = false
			break
	if suc:
		building(pos3,1,obj)
		return
	suc = true
	for vec in obj.check_build_vecs:
		var b_m = obj.check_build_mat
		if typeof(vec) == TYPE_ARRAY:
			b_m = vec[1]
			vec = vec[0]
		vec = Vector3(-vec.x,vec.y,-vec.z)
		if terrain_main_node.get_name_(pos3+vec) != b_m:
			suc = false
			break
	if suc:
		building(pos3,0,obj)
		return
	suc = true
	for vec in obj.check_build_vecs:
		var b_m = obj.check_build_mat
		if typeof(vec) == TYPE_ARRAY:
			b_m = vec[1]
			vec = vec[0]
		vec = Vector3(-vec.z,vec.y,-vec.x)
		if terrain_main_node.get_name_(pos3+vec) != b_m:
			suc = false
			break
	if suc:
		building(pos3,3,obj)
		return
func building(pos3:Vector3,dire:int,obj) ->void:
	var terrain_main_node = Overall.terrain_main_node
	terrain_main_node.damage(pos3,false)
	
	
	for vec in obj.build_vecs:
		var b_m = obj.build_mat
		if typeof(vec) == TYPE_ARRAY:
			b_m = vec[1]
			vec = vec[0]
		if dire == 0:
			vec = Vector3(-vec.x,vec.y,-vec.z)
		if dire == 1:
			vec = Vector3(vec.z,vec.y,vec.x)
		if dire == 3:
			vec = Vector3(-vec.z,vec.y,-vec.x)
		
		terrain_main_node.set_voxel_ignore(pos3+vec,Block.get(b_m).id)
	obj.building(pos3,dire)

func check_building_forming(pos3:Vector3,obj) -> void:
	var terrain_main_node = Overall.terrain_main_node
	var dire = Block.get_dire(terrain_main_node.get_id(pos3))
	for vec in obj.build_vecs:
		var b_m = obj.build_mat
		if typeof(vec) == TYPE_ARRAY:
			b_m = vec[1]
			vec = vec[0]
		if dire == 0:
			vec = Vector3(-vec.x,vec.y,-vec.z)
		if dire == 1:
			vec = Vector3(vec.z,vec.y,vec.x)
		if dire == 3:
			vec = Vector3(-vec.z,vec.y,-vec.x)
		if terrain_main_node.get_name_(pos3+vec) != b_m:
			unbuilding(pos3,dire,obj)
			break
func unbuilding(pos3:Vector3,dire:int,obj) ->void:
	var terrain_main_node = Overall.terrain_main_node
	terrain_main_node.damage(pos3,false)
	for vec in obj.build_vecs:
		var c_m = obj.check_build_mat
		var b_m = obj.build_mat
		
		if typeof(vec) == TYPE_ARRAY:
			b_m = vec[1]
			vec = vec[0]
		if dire == 0:
			vec = Vector3(-vec.x,vec.y,-vec.z)
		if dire == 1:
			vec = Vector3(vec.z,vec.y,vec.x)
		if dire == 3:
			vec = Vector3(-vec.z,vec.y,-vec.x)
		if terrain_main_node.get_name_(pos3+vec) == b_m:
			terrain_main_node.set_voxel_ignore(pos3+vec,Block.get(obj.check_build_mat).id)
	obj.unbuilding(pos3,dire)
func unbuilding_noself(pos3:Vector3,dire:int,obj) ->void:
	var terrain_main_node = Overall.terrain_main_node
	for vec in obj.build_vecs:
		var c_m = obj.check_build_mat
		var b_m = obj.build_mat
		
		if typeof(vec) == TYPE_ARRAY:
			b_m = vec[1]
			vec = vec[0]
		if dire == 0:
			vec = Vector3(-vec.x,vec.y,-vec.z)
		if dire == 1:
			vec = Vector3(vec.z,vec.y,vec.x)
		if dire == 3:
			vec = Vector3(-vec.z,vec.y,-vec.x)
		if terrain_main_node.get_name_(pos3+vec) == b_m:
			terrain_main_node.set_voxel_ignore(pos3+vec,Block.get(obj.check_build_mat).id)
func get_chunk_pos3(world_pos3:Vector3) -> Vector3:
	var chunk_pos3 = world_pos3/16
	chunk_pos3 = Vector3(int(floor(chunk_pos3.x)),int(floor(chunk_pos3.y)),int(floor(chunk_pos3.z)))
	return chunk_pos3
var debris_tscn = preload("res://tscn/particle/block/debris.tscn")
func create_particles(pos3:Vector3,name_:String,scale:=0.7,num:=5,y:=1.0) -> void:
	Overall.player_node_node.rpc2("create_particles_small",pos3,name_)
	for i in range(num):
		var debris = debris_tscn.instance()
		var hand = Overall.player_node.get_hand()
		debris.name_ = name_
		debris._scale(scale)
		debris.translation = pos3+Vector3(randf()-0.5,0.51,randf()-0.5)
		var dire_offset = Vector3((randf()-0.5)*4,y,(randf()-0.5)*4)
		debris.set_velocity(dire_offset)
		Overall.terrain_node_node.add_child(debris)


func find_block(pos3:Vector3,block_name:String,name_:String,length:=1) -> bool:
	var i = 0
	for y in [-1,1]:
		for ii in length:
			var pos3_ = pos3
			pos3_.y += y*ii
			var b_n = Overall.terrain_main_node.get_name_(pos3_)
			if b_n == name_:
				return true
			elif b_n == block_name:
				pass
			else:
				break
		
	for offset in Config.VEC_ORDER4:
		var pos3_ = pos3
		var length_ = length
		
		for ii in length:
			pos3_ += offset
			var b_n = Overall.terrain_main_node.get_name_(pos3_)
			if b_n == name_:
				return true
			elif b_n == block_name:
				if length_ > 1:
					
					if find_up2(pos3_,block_name,name_,length-1):
						return true
					else:
						if find_down2(pos3_,block_name,name_,length-1):
							return true
				
					match i:
						0:
							if find_left1(pos3_,block_name,name_,length_-1):return true
						1:
							if find_right1(pos3_,block_name,name_,length_-1):return true
						2:
							if find_foward1(pos3_,block_name,name_,length_-1):return true
						3:
							if find_back1(pos3_,block_name,name_,length_-1):return true
				length_ -= 1
			else:
				break
		i +=1
	return false

func find_left1(pos3:Vector3,block_name:String,name_:String,length:=1) -> bool:
		var pos3_ = pos3 + Vector3(0,0,-1)
		var b_n = Overall.terrain_main_node.get_name_(pos3_)
		if b_n == name_:
			return true
		elif b_n == block_name:
			if length >1:
				if find_left1(pos3_,block_name,name_,length-1):
					return true
				else:
					if find_down2(pos3_,block_name,name_,length-1):
						return true
					else:
						return find_up2(pos3_,block_name,name_,length-1)
			return false
		else:
			return false
func find_right1(pos3:Vector3,block_name:String,name_:String,length:=1) -> bool:
		var pos3_ = pos3 + Vector3(0,0,1)
		var b_n = Overall.terrain_main_node.get_name_(pos3_)
		if b_n == name_:
			return true
		elif b_n == block_name:
			if length >1:
				if find_right1(pos3_,block_name,name_,length-1):
					return true
				else:
					if find_down2(pos3_,block_name,name_,length-1):
						return true
					else:
						return find_up2(pos3_,block_name,name_,length-1)
			return false
		else:
			return false
func find_foward1(pos3:Vector3,block_name:String,name_:String,length:=1) -> bool:
		var pos3_ = pos3 + Vector3(-1,0,0)
		var b_n = Overall.terrain_main_node.get_name_(pos3_)
		if b_n == name_:
			return true
		elif b_n == block_name:
			if length >1:
				if find_foward1(pos3_,block_name,name_,length-1):
					return true
				else:
					if find_down2(pos3_,block_name,name_,length-1):
						return true
					else:
						return find_up2(pos3_,block_name,name_,length-1)
			return false
		else:
			return false
func find_back1(pos3:Vector3,block_name:String,name_:String,length:=1) -> bool:
		var pos3_ = pos3 + Vector3(1,0,0)
		var b_n = Overall.terrain_main_node.get_name_(pos3_)
		if b_n == name_:
			return true
		elif b_n == block_name:
			if length >1:
				if find_back1(pos3_,block_name,name_,length-1):
					return true
				else:
					if find_down2(pos3_,block_name,name_,length-1):
						return true
					else:
						return find_up2(pos3_,block_name,name_,length-1)
			
			return false
		else:
			return false
func find_up2(pos3:Vector3,block_name:String,name_:String,length:=1) -> bool:
		var pos3_ = pos3 + Vector3(0,1,0)
		var b_n = Overall.terrain_main_node.get_name_(pos3_)
		if b_n == name_:
			return true
		elif b_n == block_name:
			if length >1:
				return find_down2(pos3_,block_name,name_,length-1)
			else:
				return false
		else:
			return false
func find_down2(pos3:Vector3,block_name:String,name_:String,length:=1) -> bool:
		var pos3_ = pos3 + Vector3(0,-1,0)
		var b_n = Overall.terrain_main_node.get_name_(pos3_)
		if b_n == name_:
			return true
		elif b_n == block_name:
			if length >1:
				return find_down2(pos3_,block_name,name_,length-1)
			else:
				return false
		else:
			return false
		
	
	
func find_block_direct(pos3:Vector3,indirect:String,name_:String,length:=1) -> bool:
	for offset in Config.VEC_ORDER2:
		var pos3_ = pos3
		for i in length:
			pos3_ = pos3_ + offset
			var b_n = Overall.terrain_main_node.get_name_(pos3_)
			if b_n == name_:
				return true
			elif b_n == indirect:
				pass
			else:
				break
	return false
	
	
func find_conform_block(pos3:Vector3,dires:Array,b_n:String):
	var dire = Block.get_dire(Overall.terrain_main_node.get_id(pos3))
	for i in range(4):
		if dire == i:
			for offset in dires[i]:
				var p = offset[0]+pos3
				var bid = Overall.terrain_main_node.get_id(p)
				if bid:
					var name_ = Block.get_name_from_id(bid)
					if name_ == b_n:
						if Block.get_dire(bid) == offset[1]:
							return p
	return false
