extends Object
var ari_tscn := preload("res://tscn/other/ari.tscn")
func _ready() -> void:
	pass
func _event(world_pos3:Vector3,block_name:String,dire:int) -> bool:
	var tscn = ari_tscn.instance()
	world_pos3.y += 1
	tscn.translation = world_pos3
	Overall.terrain_node_node.add_child(tscn)
	return true
