extends Gravity
class_name Sapling
var name_ = "sapling"
var models = Generator.tree_models
var models_count := 10

func _ready() -> void:
	pass
func _fertilizer(pos3:Vector3,item_key:String) -> void:
	var item = Item.get(item_key)
	Overall.hand_sub("num")
	var block_name = Overall.terrain_main_node.get_name_(pos3)
	var block = Block.get(block_name)
	if !((randi() % block.tick) < int(item.other)):return
	_grow(pos3,Block.get(name_),name_)
func _random_tick(pos3:Vector3,block:Dictionary,block_key:String) -> void:
	_grow(pos3,block,block_key)

func _grow(pos3:Vector3,block:Dictionary,block_key:String) -> void:
		var down_block_key = Overall.terrain_main_node.get_key(pos3+Vector3(0,-1,0))
		if block.plant[1]:
			for d in block.plant[1]:
				if down_block_key == d:
					var vt := Overall.terrain_main_node.get_voxel_tool()
					var i := randi() % models_count
					var model = models[i]
					pos3 -= model.offset
					var aabb := AABB(pos3, model.size)
					if vt.is_area_editable(aabb):
						var size = model.size
						for x in size.x:
							for y in size.y:
								for z in size.z:
									if x!=0 && y != 0 && z !=0:
										if model.voxels.get_voxel(x,y,z,0)>0:
											var g_p = Vector3(pos3.x+x,pos3.y+y,pos3.z+z)
											if vt.get_voxel(g_p)>0:
												Overall.terrain_main_node.damage(g_p,false)
												Overall.terrain_main_node.create_fall_drop(g_p,block_key)
						vt.paste(pos3, 
							model.voxels, 0, 0)
								
						return 
		else:
			var vt := Overall.terrain_main_node.get_voxel_tool()
			var i := randi() % models_count
			var model = models[i]
			pos3 -= model.offset
			var aabb := AABB(pos3, model.size)
			if vt.is_area_editable(aabb):
				var size = model.size
				for x in size.x:
					for y in size.y:
						for z in size.z:
							if x!=0 && y != 0 && z !=0:
								if model.voxels.get_voxel(x,y,z,0)>0:
									var g_p = Vector3(pos3.x+x,pos3.y+y,pos3.z+z)
									if vt.get_voxel(g_p)>0:
										Overall.terrain_main_node.damage(g_p,false)
										Overall.terrain_main_node.create_fall_drop(g_p,block_key)
										
				vt.paste(pos3, 
					model.voxels, 0, 0)
						
				return 
