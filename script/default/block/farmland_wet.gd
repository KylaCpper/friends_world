extends Base_Block
#const VEC_LIST=[
#	Vector3(-2,0,-2),Vector3(-1,0,-2),Vector3(0,0,-2),
#	Vector3(-2,0,-1),Vector3(-1,0,-1),Vector3(0,0,-1),
#	Vector3(-2,0,1),Vector3(-1,0,1),Vector3(0,0,1),
#	Vector3(-2,0,2),Vector3(-1,0,2),Vector3(0,0,2),
#	Vector3(-2,0,0),Vector3(-1,0,0),Vector3(1,0,0),Vector3(2,0,0),
#	Vector3(2,0,-2),Vector3(1,0,-2),
#	Vector3(2,0,-1),Vector3(1,0,-1),
#	Vector3(2,0,1),Vector3(1,0,1),
#	Vector3(2,0,2),Vector3(1,0,2),
#]
func _ready() -> void:
	pass
func _random_tick(pos3:Vector3,block:Dictionary,block_key:String) -> void:
	if Overall.terrain_main_node.get_name_(pos3) == block_key:
		for offset in Config.VEC_ORDER4:
			var pos3_ = pos3 + offset
			if Overall.terrain_main_node.get_name_(pos3_) == "water":
				return
		Overall.terrain_main_node.add_block(pos3,"farmland")
