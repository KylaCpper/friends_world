extends Base_Block
class_name Multe_Block



func find(pos3:Vector3,block_name:String,name_:String) -> void:

	find_child(pos3,block_name,name_,{})

func find_child(pos3:Vector3,block_name:String,name_:String,map:Dictionary) -> void:
	if map.size() > 100:return
	map[pos3] = true
	for offset in Config.VEC_ORDER2:
		var pos3_ = pos3 + offset
		var b_n = Overall.terrain_main_node.get_name_(pos3_)
		if b_n == name_:
			Block.get(name_).script._check_building(pos3_)
			return
		if b_n == block_name:
			if !pos3_ in map:
				find_child(pos3_,block_name,name_,map)
		



func find_update(pos3:Vector3,block_name:String,name_:String) -> void:

	find_child_update(pos3,block_name,name_,{})

func find_child_update(pos3:Vector3,block_name:String,name_:String,map:Dictionary) -> void:
	if map.size() > 100:return
	map[pos3] = true
	for offset in Config.VEC_ORDER2:
		var pos3_ = pos3 + offset
		var b_n = Overall.terrain_main_node.get_name_(pos3_)
		if b_n == name_:
			Block.get(name_).script._multe_update(pos3_)
			return
		if b_n == block_name:
			if !pos3_ in map:
				find_child_update(pos3_,block_name,name_,map)
		

