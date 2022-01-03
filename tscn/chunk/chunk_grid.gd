extends GridMap
var chunk := Vector3(0,0,0)
func _ready():
#	add_to_group("grid")
	CollisionGroup.collision(self,"block")
#	Overall.grid_node = self
	if Net.status:
		if Net.id!=1:
			Net.rpc_id(1,"send_data_plane",Net.id)

func add_block(data:Dictionary) -> void:
	var block_pos3 = get_block_pos3(data.world_pos3)
	var orthogonal = data.dire
	if typeof(Terrain.map[block_pos3]) == TYPE_ARRAY:
		orthogonal = Terrain.map[block_pos3][1]
	set_cell_item(block_pos3[0],block_pos3[1],block_pos3[2],Block.get(data.name_).id,orthogonal)

#增加方块
func place(data:Dictionary) -> bool:
	var block_pos3 = get_block_pos3(data.world_pos3)
	if !Terrain.is_in_map(block_pos3):
		
		if get_cell_item(block_pos3[0],block_pos3[1],block_pos3[2])!=-1:
			return false
		if data.update:
			if Overall.terrain_node_node.can_place(block_pos3*2+Vector3(1,1,1)):
				add_block(data)
				Terrain.map[block_pos3]=data.name_
				if Block.get(data.name_).dire == 0:
					Terrain.map[block_pos3]=[data.name_,data.dire]
				return true
		else:
			add_block(data)
			Terrain.map[block_pos3]=data.name_
			if Block.get(data.name_).dire != 0:
				Terrain.map[block_pos3]=[data.name_,data.dire]
			return true
	return false
	
	
func get_name_(world_pos3:Vector3) -> String:
	var block_pos3 = get_block_pos3(world_pos3)
	var id = get_cell_item(block_pos3.x,block_pos3.y,block_pos3.z)
	return Block.get_name_from_id_grid(id)

# 只是方块内部知道的位置，不代表实际位置
static func get_block_pos3(world_pos3:Vector3) -> Vector3:
	return Vector3(int(floor(world_pos3.x)),int(floor(world_pos3.y)),int(floor(world_pos3.z)))
	
# 实际位置
static func get_global_block_pos3(pos3:Vector3) -> Vector3:
	var world_block_pos3 = Vector3(floor(pos3.x),floor(pos3.y),floor(pos3.z))
#	world_block_pos3 *= 2
	world_block_pos3 += Vector3(0.5,0.5,0.5)
	return world_block_pos3

#######
#去除方块
func damage(world_pos3:Vector3,update:=true) -> bool:
	var block_pos3=get_block_pos3(world_pos3)
	#map 去除
	if Terrain.is_in_map(block_pos3):
		set_cell_item(block_pos3[0],block_pos3[1],block_pos3[2],-1)
		Terrain.map[block_pos3] = null
		return true
	else:
		return false
func update() -> void:
	pass
######
#func create_car(car,tr):
#	if Net.status:
#		rpc("create_car",car,tr)
#	var tscn=load("res://scenes/model/car/car"+str(car)+".tscn").instance()
#	tscn.translation=tr
#	add_child(tscn)
#func _on_event(id,obj):
#	if Net.status:
#		if Net.id==1:
#			_on_event_receive(id,obj.get_path())
#		else:
#			rpc_id(1,"_on_event_receive",id,obj.get_path())
#	else:
#		_on_event_solve(id,obj.get_path())
#master func _on_event_receive(id,path):
#	for i in player_info:
#		if i==1&&Net.id==1:
#			_on_event_solve(id,path)
#		else:
#			rpc_id(i,"_on_event_solve",id,path)
#remote func _on_event_solve(id,path):
#	if has_node(path):
#		get_node(path)._on_event(id)
#############
#func _on_hurt(id,obj=null):
#	if !obj:return
#	if Net.status:
#		if Net.id==1:
#			_on_hurt_(id,obj.get_path())
#		else:
#			rpc_id(1,"_on_hurt_",id,obj.get_path())
#	else:
#		_on_hurt_solve(id,obj.get_path())
#func _on_hurt_(id,path):
#	for i in player_info:
#		if i != id:
#			if i==1&&Net.id==1:
#				_on_hurt_solve(id,path)
#			else:
#				rpc_id(i,"_on_hurt_solve",id,path)
#		else:
#			_on_hurt_solve(id,path)
#func _on_hurt_solve(id,path):
#	if has_node(path):
#		get_node(path)._on_hurt(id)
#
#
#
#
#####
#func _forward(func_name,id,path):
#	if Net.id==1:
#		_on_forward(func_name,id,path)
#	else:
#		rpc_id(1,"_on_forward",func_name,id,path)
#master func _on_forward(func_name,id,path):
#	for i in player_info:
#		if i != id:
#			if i==1&&Net.id==1:
#				_on_forward_solve(func_name,path)
#			else:
#				rpc_id(i,"_on_forward_solve",func_name,path)
#remote func _on_forward_solve(func_name,path):
#	if has_node(path):
#		get_node(path).call(func_name)
#####
#####
#func _forward_1(func_name,id,path,arg1):
#	if Net.id==1:
#		_on_forward_1(func_name,id,path,arg1)
#	else:
#		rpc_id(1,"_on_forward_1",func_name,id,path,arg1)
#master func _on_forward_1(func_name,id,path,arg1):
#	for i in player_info:
#		if i != id:
#			if i==1&&Net.id==1:
#				_on_forward_solve_1(func_name,path,arg1)
#			else:
#				rpc_id(i,"_on_forward_solve_1",func_name,path,arg1)
#remote func _on_forward_solve_1(func_name,path,arg1):
#	if has_node(path):
#		get_node(path).call(func_name,arg1)
#####
#
#
#
#
