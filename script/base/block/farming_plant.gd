extends Gravity
var farming_plant_downs = ["dirt","grass_dirt","farmland","farmland_wet"]
func _ready() -> void:
	pass
func _update(pos3:Vector3,block_key:String,dire:int) -> void:
	._update(pos3,block_key,dire)
	if Overall.terrain_main_node.is_exist(pos3):
		var name = Overall.terrain_main_node.get_name_(pos3+Vector3(0,-1,0))
		var names = farming_plant_downs
		var be := false
		if names:
			for d in names:
				if name == d:
					be = true
					break
		if !be:
			Overall.terrain_main_node.damage(pos3)
			Overall.terrain_main_node.create_fall_drop(pos3,block_key)
		
func _random_tick(pos3:Vector3,block:Dictionary,block_key:String) -> void:
	if "plant" in block:
		var plant = block.plant
		if plant:
			if plant[0]:
				var name = Overall.terrain_main_node.get_name_(pos3+Vector3(0,-1,0))
				if name == "farmland_wet":
					Overall.terrain_main_node.add_block(pos3,plant[0])
				elif name == "farmland":
					if Function.rand()<20:
						Overall.terrain_main_node.add_block(pos3,plant[0])
				else:
					if Function.rand()<5:
						Overall.terrain_main_node.add_block(pos3,plant[0])
#			else:
#				Overall.terrain_main_node.damage(pos3)
#				Overall.terrain_main_node.create_fall_drop(pos3,block_key)
			
