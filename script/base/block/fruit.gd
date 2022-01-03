extends Base_Block
func _ready() -> void:
	pass
func _update(pos3:Vector3,block_key:String,dire:int) -> void:
	if Overall.terrain_main_node.is_exist(pos3):
		var name = Overall.terrain_main_node.get_name_(pos3+Vector3(0,1,0))
		var block = Block.get(block_key)
		
		if "plant" in block:
			var names = block.plant[1]
			if names.size() > 0:
				var be := false
				for d in names:
					if name == d:
						be = true
						break
				if !be:
					.fall(pos3,block_key,dire)

#			Overall.terrain_main_node.damage(pos3)
#			Overall.terrain_main_node.create_fall_drop(pos3,block_key)
		
func _random_tick(pos3:Vector3,block:Dictionary,block_key:String) -> void:
	_grow(pos3,block,block_key)
	
func _event(pos3:Vector3,block_name:String,dire:int) -> bool:
#	var name = Overall.terrain_main_node.get_name_(pos3)
	var block = Block.get(block_name)
	if !block.plant[0]:
		var arr = str2var(block.other)
		Overall.terrain_main_node.add_block(pos3,arr[0])
		Overall.bar_node.add_item({"name":arr[1],"num":1,"hp":0})
		return true
	else:
		return false
func _fertilizer(pos3:Vector3,item_key:String) -> void:
	var item = Item.get(item_key)
	Overall.hand_sub("num")
	var block_name = Overall.terrain_main_node.get_name_(pos3)
	var block = Block.get(block_name)
	if !((randi() % block.tick) < int(item.other)):return
	_grow(pos3,block,block_name)
func _grow(pos3:Vector3,block:Dictionary,block_key:String) -> void:
	if "plant" in block:
		var plant = block.plant
		if plant:
			if plant[0]:
				var names = block.plant[1]
				var name = Overall.terrain_main_node.get_name_(pos3+Vector3(0,1,0))
				if names.size() > 0:
					var be := false
					for d in names:
						if name == d:
							be = true
							break
					if be:
						Overall.terrain_main_node.add_block(pos3,plant[0])
				else:
					Overall.terrain_main_node.add_block(pos3,plant[0])
			else:
				if randi()%10<3:
					fall(pos3,block_key,0)
#					Overall.terrain_main_node.damage(pos3)
#					Overall.terrain_main_node.create_fall_drop(pos3,block_key)
