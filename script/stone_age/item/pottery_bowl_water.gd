extends Base_Item
func _ready() -> void:
	pass
#func _event(pos3:Vector3,item_key:String,is_air:bool) -> bool:
#	var block_key = Overall.terrain_main_node.get_key(pos3)
#	if block_key == "sand_wet":
#		Overall.terrain_main_node.add_block(pos3,"sand_clam")
#		Overall.bar_node.sub_num()
#	if block_key == "sand_clam":
#		return false
#	return true
func _eated() -> bool:
	Overall.bar_node.add_item({"name":"pottery_bowl","num":1,"hp":0})
	return false
