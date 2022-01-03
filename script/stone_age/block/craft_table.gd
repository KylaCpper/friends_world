extends Base_Block

func _ready() -> void:
	pass
func _event(world_pos3:Vector3,block_name:String,dire:int) -> bool:
	Overall.gui_node_node.change_ui("composite","craft_table")
	return true
#func _mouse_left(world_pos3:Vector3,block_name:String,dire:int) -> bool:
#	return false
