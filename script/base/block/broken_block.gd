extends Base_Block
func _smash(pos3:Vector3,block_name:String,force:float,is_fall:bool) -> float:
	Overall.terrain_main_node.add_block(pos3,"wood_broken",4)
	return 0.0
