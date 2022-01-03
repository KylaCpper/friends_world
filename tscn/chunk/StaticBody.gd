extends StaticBody



const chunk_node_type = preload("res://lib/voxel/src/voxel_mesh.gd")
onready var chunk := $"../"
	
func get_name_(world_pos3:Vector3) -> String:
	var block_vec3 = get_block_pos3(world_pos3)
	var data =	Terrain.map[block_vec3]
	if data:
		if typeof(data) == TYPE_STRING:
			return data
		else:
			return data[0]
	else:
		return ""

# 只是方块内部知道的位置，不代表实际位置
static func get_block_pos3(world_pos3:Vector3) -> Vector3:
	return Vector3(int(floor(world_pos3.x)),int(floor(world_pos3.y)),int(floor(world_pos3.z)))
	
# 实际位置
static func get_global_block_pos3(world_pos3:Vector3) -> Vector3:
	var world_block_pos3 = Vector3(int(world_pos3.x),int(world_pos3.y),int(world_pos3.z))
	world_block_pos3 += Vector3(0.5,0.5,0.5)
	return world_block_pos3
func damage(world_pos3:Vector3,update:=true) -> bool:
	var block_pos3 = get_block_pos3(world_pos3)
	Terrain.map[block_pos3] = null
	$"../".update()
	return true
#	if Terrain.is_in_map(block_pos3):
#		$"../".update()
#		return true
#	else:
#		return false

func place(world_pos3,name_,dire,update) -> bool:
	var block_pos3 = get_block_pos3(world_pos3)
	
	if !Terrain.is_in_map(block_pos3):
		$"../../".change = true
#		旋转方向
		if update:
			if Overall.terrain_node_node.can_place(block_pos3+Vector3(0.5,0.5,0.5)):
				Block.check_dire(name_,dire)
				$"../".update()

				return true
			else:
				
				return false
		else:
			Block.check_dire(name_,dire)
			return true
	else:
		return false
func add_block(block_pos3,name_,dire) -> void:
#	var block_pos3 = get_block_pos3(data.world_pos3)
	pass
#	chunk.set_voxel_from_name(block_pos3,data.name_,data.update)
