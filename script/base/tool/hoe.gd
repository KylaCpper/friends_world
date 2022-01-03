extends Base_Tool
func _ready() -> void:
	pass
func _event(pos3:Vector3,item_key:String,is_air:bool) -> bool:
	if is_air:return false
	var block_key = Overall.terrain_main_node.get_key(pos3)
	if block_key:
		if block_key == "dirt" || block_key == "grass_dirt":
			Overall.terrain_main_node.add_block(pos3,"farmland")
			Overall.hand_sub("hp")
	
	return true
