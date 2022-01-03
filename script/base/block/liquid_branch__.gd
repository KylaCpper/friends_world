extends Object
const VEC_ORDER = [
	Vector3(0,-1,0),
	Vector3(1,0,0),Vector3(-1,0,0),
	Vector3(0,0,1),Vector3(0,0,-1),
]
const VEC_ORDER2 = [
	Vector3(1,0,0),Vector3(-1,0,0),
	Vector3(0,0,1),Vector3(0,0,-1),
]
func _ready() -> void:
	pass
var time_update := 2
var time_speed := 0.1
var list_check := {}
func _init() -> void:
	while true:
		yield(Config.get_tree().create_timer(5.0),"timeout")
		list_check.clear()
func _place(pos3:Vector3,name:String,dire:int) -> void:
	check(pos3,name,dire)
#	var block = Block.get(name)
	yield(Overall.get_tree().create_timer(time_update),"timeout")
	var key = Overall.terrain_main_node.get_name_(pos3)
	if key == name:
		Overall.terrain_main_node.damage(pos3,false)
		for data in VEC_ORDER2:
			var pos3_ = pos3+data
			var name_ = Overall.terrain_main_node.get_name_(pos3_)
			var block_ = Block.get(name_)
			if block_:
				if block_.liquid:
					if name_ == block_.branch[2]:
						Block.get(name_).script.check(pos3_,name_,0)

func _update(pos3:Vector3,name:String,dire:int) -> void:
	if !pos3 in list_check:
		list_check[pos3] = true
		_place(pos3,name,dire)
		return
func check(pos3:Vector3,name:String,dire:int) -> void:
	var block = Block.get(name)
	for data in VEC_ORDER:
		yield(Overall.get_tree().create_timer(time_speed),"timeout")
		var pos3_ = pos3 + data
		var name_ = Overall.terrain_main_node.get_name_(pos3_)
		if name_:
			var block_ = Block.get(name_)
			if !block_.entity:
				
				if data.y == -1:
#					Overall.terrain_main_node.damage(pos3,false)
					var branch = block.branch[0]
					if !branch: branch = name
					if !block_.liquid:
						Overall.terrain_main_node.damage(pos3_,false)
						Overall.terrain_main_node.create_fall_drop(pos3_,name_)
						create_branch_down(pos3_,branch)
						
					else:
						if name_ == block.branch[2]:
							block_.script.list_down_liquid[pos3_] = true
						else:
							Overall.terrain_main_node.damage(pos3_,false)
							create_branch_down(pos3_,branch)
						
					return
				else:
					if !block_.liquid:
						Overall.terrain_main_node.create_fall_drop(pos3_,name_)
						create_branch(pos3_,block.branch[1])
		else:
			if data.y == -1:
#				Overall.terrain_main_node.damage(pos3,false)
				var branch = block.branch[0]
				if !branch: branch = name
				create_branch_down(pos3_,branch)
				return
			else:
				create_branch(pos3_,block.branch[1])
				
func create_branch(pos3:Vector3,key:String) -> void:
	if key:
		Overall.terrain_main_node.add_block(pos3,key,0,true)

func create_branch_down(pos3:Vector3,key:String) -> void:
	if key:
		Overall.terrain_main_node.add_block(pos3,key,0,true)
