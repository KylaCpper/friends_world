extends Base_Block
func _ready() -> void:
	pass
func _random_tick(pos3:Vector3,block:Dictionary,block_key:String) -> void:
	return
	var num = randi() % 1000
	if num < 100:
		var pos3_ = pos3 + Vector3(0,1,0)
		if !Overall.terrain_main_node.get_name_(pos3_):
			Overall.terrain_main_node.add_block(pos3_,"grass")
			if num < 1:
	#			var dis = abs(Vector2(pos3_.x,pos3_.z).distance_to(Vector2(Overall.player_node.translation.x,Overall.player_node.translation.z)))
	#			if dis > 32 && dis < 128:
				Overall.entity_node_node.add_entity("wild_pig",pos3_)

