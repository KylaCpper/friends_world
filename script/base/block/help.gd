extends Base_Block
var list := {}
func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	if pos3_arr in list:
		Overall.terrain_main_node.damage(list[pos3_arr])
	else:
		Overall.terrain_main_node.set_voxel(pos3,0)


func fall(pos3:Vector3,block_name:String,dire:int) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	if pos3_arr in list:
		Overall.terrain_main_node.damage(list[pos3_arr])
		Overall.terrain_node_node.create_drop(pos3,{"name":"water_wheel","num":1})
	else:
		Overall.terrain_main_node.set_voxel(pos3,0)
