extends Base_Block
class_name Gravity
func _ready() -> void:
	pass
func _update(pos3:Vector3,block_name:String,dire:int) -> void:
#	._update(pos3,block_name,dire)
	var name = Overall.terrain_main_node.get_name_(pos3+Vector3(0,-1,0))
	if name:
		if Block.get_entity(name):return 
	.fall(pos3,block_name,dire)

