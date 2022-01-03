extends Gravity
const VEC_LIST=[
	Vector3(0,0,-1),
	Vector3(0,0,1),
	Vector3(-1,0,0),
	Vector3(1,0,0),
]
func _ready() -> void:
	pass
func _random_tick(pos3:Vector3,block:Dictionary,block_key:String) -> void:
	if Overall.terrain_main_node.get_name_(pos3) == block_key:
		for offset in VEC_LIST:
			var pos3_ = pos3 + offset
			if Overall.terrain_main_node.get_name_(pos3_) == "water":
				if randi()%10<1:
					Overall.terrain_main_node.add_block(pos3,"sand_clam")
				return
		Overall.terrain_main_node.add_block(pos3,"sand")
