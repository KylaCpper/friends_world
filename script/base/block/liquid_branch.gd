extends Object
const VEC_ORDER := [
	Vector3(0,-1,0),
	Vector3(1,0,0),Vector3(-1,0,0),
	Vector3(0,0,1),Vector3(0,0,-1),
]
const VEC_ORDER2 := [
	Vector3(1,0,0),Vector3(-1,0,0),
	Vector3(0,0,1),Vector3(0,0,-1),
]
const VEC_ORDER3 := [
	Vector3(1,-1,0),Vector3(-1,-1,0),
	Vector3(0,-1,1),Vector3(0,-1,-1),
]
const VEC_ORDER4 := [
	[Vector3(1,0,0),Vector3(-1,0,0),
	Vector3(0,0,1),Vector3(0,0,-1)],
	
	[Vector3(-1,0,0),Vector3(0,0,1),
	Vector3(0,0,-1),Vector3(1,0,0)],
	
	[Vector3(0,0,1),Vector3(0,0,-1),
	Vector3(1,0,0),Vector3(-1,0,0)],
	
	[Vector3(0,0,-1),Vector3(1,0,0),
	Vector3(-1,0,0),Vector3(0,0,1)],
]
var time_update := 2
var time_speed := 0.1
var queue := {}
#func _init() -> void:
#
#	while true:
#		yield(Config.get_tree().create_timer(5.0),"timeout")
#		list_check.clear()
func _place(pos3:Vector3,name:String,dire:int) -> void:
	update(pos3,name,dire)

func update(pos3:Vector3,name:String,dire:int) -> void:
	yield(Overall.get_tree().create_timer(time_speed),"timeout")
	var self_name = "name"
	var name_ = Overall.terrain_main_node.get_name_(pos3+Vector3(0,-1,0))
	#下方方块
	#有方块
	if name_:
		var block_ = Block.get(name_)
		var block = Block.get(name)
		#液体
		if block_.liquid:
			#不为源头
			if block_.branch[0]:
				#相同种类液体
				if block_.branch[2]==block.branch[2]:
					Overall.terrain_main_node.add_block(pos3+Vector3(0,-1,0),block_.branch[0],0,true)
					if block.branch[1]:
						Overall.terrain_main_node.add_block(pos3,block.branch[1],0,true)
					else:
						Overall.terrain_main_node.set_voxel(pos3,0)
				#不同液体
				else:
					pass
			#下方为源头
			else:
				pass

		#非液体
		else:
			#非实体
			if !block_.entity:
				Overall.terrain_main_node.damage(pos3+Vector3(0,-1,0),false)
				Overall.terrain_main_node.add_block(pos3+Vector3(0,-1,0),name,0,true)
		return
	#无方块
	else:
		Overall.terrain_main_node.add_block(pos3+Vector3(0,-1,0),name,0,true)
	
func _update(pos3:Vector3,name:String,dire:int) -> void:
	pass
