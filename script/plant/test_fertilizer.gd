extends Base_Item
func _ready() -> void:
	pass
func _event(pos3:Vector3,item_key:String,is_air:bool) -> bool:
	var block_key = Overall.terrain_main_node.get_key(pos3)
	if block_key:
		var block = Block.get(block_key)
		if block.script:
			if block.script.has_method("_fertilizer"):
				block.script._fertilizer(pos3,item_key)
	return false
