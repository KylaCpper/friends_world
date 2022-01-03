extends Base_Item
func _ready() -> void:
	pass
func _event(pos3:Vector3,item_key:String,is_air:bool) -> bool:
	var block_key = Overall.terrain_main_node.get_key(pos3)
	if block_key == "sand_wet":
		Overall.terrain_main_node.add_block(pos3,"sand_clam")
		Overall.bar_node.sub_num()
	if block_key == "sand_clam":
		return false
	return true
func _eated() -> bool:
	if Function.rand() < 10:
		Overall.buff_node.add_buff("have_loose_bowels")
	if Function.rand() < 30:
		Overall.buff_node.add_buff("parasite")
	return false
