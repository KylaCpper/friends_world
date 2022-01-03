extends Base_Block


func _ready() -> void:
	pass
func _random_tick(pos3:Vector3,block:Dictionary,block_key:String) -> void:
	if Terrain.find_block(pos3,block_key,"wood",5):
		var pos3_ = pos3 + Vector3(0,-1,0)
		if !Overall.terrain_main_node.get_name_(pos3_):
			Overall.terrain_main_node.add_block(pos3_,"apple_grow0")
	else:
		Overall.terrain_main_node.damage(pos3)
#		for drop in block.drop.fall:
		Overall.terrain_node_node.create_drops(pos3,block.drop.fall)



