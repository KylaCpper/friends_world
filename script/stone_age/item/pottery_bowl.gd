extends Base_Item
func _ready() -> void:
	pass
func _event(pos3:Vector3,item_key:String,is_air:bool) -> bool:
	var all_pos3 = Overall.terrain_main_node.check(CollisionGroup.ALL)
	if all_pos3:
		pos3 = all_pos3
		var block_key = Overall.terrain_main_node.get_key(pos3)
		if block_key:
			var item = Item.get(block_key)
			if item.class == "block":
				if item.liquid:
					if item.branch[2] == "water":
						Overall.terrain_main_node.add_block(pos3,item.branch[1])
						Overall.bar_node.sub_num()
						Overall.bar_node.add_item({"name":"pottery_bowl_water","num":1,"hp":0})
						return true
	return false
func _eated() -> bool:
	if Function.rand() >= 5:
		Overall.buff_node.add_buff("have_loose_bowels")
	if Function.rand() >= 20:
		Overall.buff_node.add_buff("parasite")
	return false
