extends GridMap

var offset := Vector3(0,0,0)
func _ready():
	CollisionGroup.collision(self,"block")
#	Overall.grid_node = self
#	if Net.status:
#		if Net.id!=1:
#			Net.rpc_id(1,"send_data_plane",Net.id)
#	for x in range(32):
#		for z in range(32):
#			for y in range(32):
#				add_block(1,Vector3(x,y,z))
#增加方块
func place(world_pos3:Vector3,name_:String,orthogonal=0,update:=true) -> bool:
	var block_pos3=get_pos3(world_pos3)
#	var block_pos3 = Vector3(pos3[0],pos3[1],pos3[2])
	if Terrain.is_in_map(block_pos3):
		if Terrain.map[block_pos3]:
			return false
	if get_cell_item(block_pos3[0],block_pos3[1],block_pos3[2])!=-1:
		return false
	if update:
		var world_block_vec3 = get_global_block_pos3(world_pos3)
		if !Overall.terrain_node_node.can_place(world_block_vec3):
			return false
	Terrain.map[block_pos3]=name_
	add_block(block_pos3,name_,orthogonal)
	return true
func add_block(block_pos3:Vector3,name_:String,orthogonal:int) -> void:
	set_cell_item(block_pos3[0],block_pos3[1],block_pos3[2],Block.get(name_).id,orthogonal)
	
	
func get_name_(world_pos3:Vector3) -> String:
	var block_pos3 = get_pos3(world_pos3)
	var id = get_cell_item(block_pos3.x,block_pos3.y,block_pos3.z)
	return Block.get_name_from_id_grid(id)
# 只是方块内部知道的位置，不代表实际位置
func get_pos3(world_pos3:Vector3) -> Vector3:
#	world_pos3 = world_pos3
	return Vector3(int(world_pos3.x),int(world_pos3.y),int(world_pos3.z))
# 给的已经消除过offset
static func get_pos3_place(world_block_pos3_no_offset:Vector3) -> Vector3:
	return Vector3(int(world_block_pos3_no_offset.x),int(world_block_pos3_no_offset.y),int(world_block_pos3_no_offset.z))
# 实际位置
static func get_global_block_pos3(pos3:Vector3) -> Vector3:
#	pos3 = pos3+ $"../../../".offset + $"../../".offset 
	var world_block_pos3 = Vector3(floor(pos3.x),floor(pos3.y),floor(pos3.z))
#	world_block_pos3 *= 2
	world_block_pos3 += Vector3(0.5,0.5,0.5)
	return world_block_pos3

#######
#去除方块
func damage(world_pos3:Vector3,update:=true) -> bool:
	var block_pos3=get_pos3(world_pos3)
#	var block_vec3 = Vector3(block_vec3[0],block_vec3[1],block_vec3[2])
	#map 去除
#	Terrain.is_in_map(block_pos3)
#	Terrain.map[block_pos3] = null
	set_cell_item(block_pos3[0],block_pos3[1],block_pos3[2],-1)
	return true

func update() -> void:
	pass

#
