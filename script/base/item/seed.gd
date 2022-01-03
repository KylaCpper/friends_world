extends Base_Item
func _ready() -> void:
	pass
func _event(pos3:Vector3,item_key:String,is_air:bool) -> bool:
	var block_key = Overall.terrain_main_node.get_key(pos3)
	if block_key:
		var item = Item.get(item_key)
		if item.plant[1]:
			for d in item.plant[1]:
				if block_key == d:
					if !Overall.terrain_main_node.get_key(pos3+Vector3(0,1,0)):
						Overall.terrain_main_node.place(pos3+Vector3(0,1,0),item.plant[0])
						Overall.hand_sub("num")
					return true
		else:
			if !Overall.terrain_main_node.get_key(pos3+Vector3(0,1,0)):
				Overall.terrain_main_node.place(pos3+Vector3(0,1,0),item.plant[0])
				Overall.hand_sub("num")
				return true
	return false
