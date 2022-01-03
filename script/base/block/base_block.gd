extends Object
class_name Base_Block
var fall_tscn := preload("res://tscn/block/fall/fall.tscn")


func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	_update(pos3,block_name,dire)
func _update(pos3:Vector3,block_name:String,dire:int) -> void:
	var fall := false
	var entity = Block.get_entity(block_name)
	for dire_key in Config.DIRE_ORDER:
		fall = false
		for offset in Config[dire_key]:
			var pos3_ = pos3 + offset
			var name = Overall.terrain_main_node.get_name_(pos3_)
			if !name:
				fall = true
				break
			else:
				if entity:
					if !Block.get_entity(name):
						fall = true
						break 
		if fall == false:
			return
	
	fall(pos3,block_name,dire)
func fall(pos3:Vector3,block_name:String,dire:int) -> void:
	Overall.terrain_main_node.damage(pos3,false)
	Overall.chunks_node_node.rpc1("create_fall_client",[pos3,block_name,dire])
	var tscn = fall_tscn.instance()
	tscn.translation = pos3
	tscn.name_ = block_name
	tscn.dire = dire
	Overall.terrain_node_node.add_child(tscn)
	

