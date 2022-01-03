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
const VEC_ORDER3 = [
	Vector3(1,-1,0),Vector3(-1,-1,0),
	Vector3(0,-1,1),Vector3(0,-1,-1),
]
const VEC_ORDER4 = [
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
var list_down_liquid := {}
var list_source := {}
var list_check := {}
func _init() -> void:
	while true:
		yield(Config.get_tree().create_timer(5.0),"timeout")
		list_check.clear()
func _place(pos3:Vector3,name:String,dire:int) -> void:
	list_check[pos3] = true
	if pos3 in list_source:
		list_source.erase(pos3)
	check(pos3,name,dire)
	yield(Overall.get_tree().create_timer(time_update),"timeout")
	update(pos3,name,dire)

func _update(pos3:Vector3,name:String,dire:int) -> void:
	if pos3 in list_source:
		list_source.erase(pos3)
		yield(Overall.get_tree().create_timer(time_update),"timeout")
		update(pos3,name,dire)
	else:
		if !pos3 in list_check:
			list_check[pos3] = true
#			_place(pos3,name,dire)
#			return
			var same_down := false
			var name_ = Overall.terrain_main_node.get_name_(pos3+Vector3(0,-1,0))
			if name_:
				var block_ = Block.get(name_)
				if block_.liquid:
					if name_ == name:
						same_down = true
						for vec in VEC_ORDER3:
							name_ = Overall.terrain_main_node.get_name_(pos3+Vector3(0,-1,0))
							if name_:
								var block_around = Block.get(name_)
								if block_around.liquid:
									if name_ != name:
										same_down = false
										break
								else:
									same_down = false
									break
							else:
								same_down = false
								break

							
			if !same_down:
				_place(pos3,name,dire)
#			else:
#				yield(Overall.get_tree().create_timer(time_update),"timeout")
#				update(pos3,name,dire)
			
func update(pos3:Vector3,name:String,dire:int) -> void:
	var key = Overall.terrain_main_node.get_name_(pos3)
	if key == name:
		var hide := false
		for data in VEC_ORDER2:
			var pos3_ = pos3+data
			var name_ = Overall.terrain_main_node.get_name_(pos3_)
			var block_ = Block.get(name_)
			if block_:
				#周围有非实体方块
				if !block_.entity && !block_.liquid:
					hide = true
					
				#周围有液体支流
				if block_.liquid && name_ != block_.branch[2]:
					hide = true
					
			else:
				#周围有空气
				hide = true
				
		if hide:
			if pos3 in list_down_liquid:
				list_down_liquid.erase(pos3)
				yield(Overall.get_tree().create_timer(time_update),"timeout")
				update(pos3,name,dire)
			else:
				Overall.terrain_main_node.damage(pos3,false)
				
		else:
			list_source[pos3] = true
			
func check(pos3:Vector3,name:String,dire:int) -> void:
	var block = Block.get(name)
	for data in VEC_ORDER:
		yield(Overall.get_tree().create_timer(time_speed),"timeout")
		var pos3_ = pos3 + data
		var name_ = Overall.terrain_main_node.get_name_(pos3_)
		if name_:
			var same_down := false
			var block_ = Block.get(name_)
			if data.y == -1:
				if block_.liquid:
					if name_ == name:
						same_down = true
						list_down_liquid[pos3_] = true

						yield(Overall.get_tree().create_timer(time_speed),"timeout")
						if same_down(pos3,name):
							return
						
					else:
						Overall.terrain_main_node.damage(pos3,false)
						Overall.terrain_main_node.add_block(pos3_,name,0,true)
						return
				
				
			if !block_.entity:
				if data.y == -1:
					if !same_down:
						Overall.terrain_main_node.damage(pos3,false)
						if block_.liquid:
							Overall.terrain_main_node.damage(pos3_,false)
							create_branch_down(pos3_,name)
						else:
							Overall.terrain_main_node.damage(pos3_,false)
							Overall.terrain_main_node.create_fall_drop(pos3_,name_)
							create_branch_down(pos3_,name)
							
						return
				else:
					if !block_.liquid:
						Overall.terrain_main_node.create_fall_drop(pos3_,name_)
						create_branch_side(pos3_,block.branch[1])
		else:
			if data.y == -1:
				Overall.terrain_main_node.damage(pos3,false)
				Overall.terrain_main_node.add_block(pos3_,name,0,true)
				return
			else:
				create_branch_side(pos3_,block.branch[1])
func same_down(pos3:Vector3,name:String) -> bool:
	var index = Function.rand(4)
	var be = !(randi()%30<1)
	for i in range(4):
		var pos3_ = pos3+VEC_ORDER4[randi()%4][i]
		var name_ = Overall.terrain_main_node.get_name_(pos3_)
		if name_:
			var block_ = Block.get(name_)
			if name_ != name:
				if !block_.entity:
					if !block_.liquid:
						Overall.terrain_main_node.damage(pos3,false)
						if be:
							Overall.terrain_main_node.create_fall_drop(pos3_,name_)
							Overall.terrain_main_node.add_block(pos3_,name,0,true)
						return true
					else:
						if block_.branch[2] != name_:
							Overall.terrain_main_node.damage(pos3,false)
							if be:
								Overall.terrain_main_node.create_fall_drop(pos3_,name_)
								Overall.terrain_main_node.add_block(pos3_,name,0,true)
							return true
		else:
			Overall.terrain_main_node.damage(pos3,false)
			if be:
				Overall.terrain_main_node.add_block(pos3_,name,0,true)
			return true

#			move_list[pos3] = true
	return false
	
func _check(pos3:Vector3,name:String,dire:int) -> void:
	var block = Block.get(name)
	for data in VEC_ORDER:
		yield(Overall.get_tree().create_timer(time_speed),"timeout")
		var pos3_ = pos3 + data
		var name_ = Overall.terrain_main_node.get_name_(pos3_)
		if name_:
			var same_down := false
			var block_ = Block.get(name_)
			if data.y == -1:
				if block_.liquid:
					if name_ == name:
						same_down = true
						list_down_liquid[pos3_] = true
						yield(Overall.get_tree().create_timer(time_speed),"timeout")
						if _same_down(pos3,name):
							return
						
					else:
						Overall.terrain_main_node.damage(pos3,false)
						Overall.terrain_main_node.add_block(pos3_,name,0,true)
						return
				
				
			if !block_.entity:
				if data.y == -1:
					if !same_down:
						Overall.terrain_main_node.damage(pos3,false)
						if block_.liquid:
							Overall.terrain_main_node.damage(pos3_,false)
							create_branch_down(pos3_,name)
						else:
							Overall.terrain_main_node.damage(pos3_,false)
							Overall.terrain_main_node.create_fall_drop(pos3_,name_)
							create_branch_down(pos3_,name)
							
						return
				else:
					if !block_.liquid:
						Overall.terrain_main_node.create_fall_drop(pos3_,name_)
						create_branch_side(pos3_,block.branch[1])
		else:
			if data.y == -1:
				Overall.terrain_main_node.damage(pos3,false)
				Overall.terrain_main_node.add_block(pos3_,name,0,true)
				return
			else:
				create_branch_side(pos3_,block.branch[1])
func _same_down(pos3:Vector3,name:String) -> bool:
	var index = Function.rand(4)
	var be = !(randi()%30<1)
	for i in range(4):
		var pos3_ = pos3+VEC_ORDER4[randi()%4][i]
		var name_ = Overall.terrain_main_node.get_name_(pos3_)
		if name_:
			var block_ = Block.get(name_)
			if name_ != name:
				if !block_.entity:
					if !block_.liquid:
						Overall.terrain_main_node.damage(pos3,false)
						if be:
							Overall.terrain_main_node.create_fall_drop(pos3_,name_)
							Overall.terrain_main_node.add_block(pos3_,name,0,true)
						return true
					else:
						if block_.branch[2] != name_:
							Overall.terrain_main_node.damage(pos3,false)
							if be:
								Overall.terrain_main_node.create_fall_drop(pos3_,name_)
								Overall.terrain_main_node.add_block(pos3_,name,0,true)
							return true
		else:
			Overall.terrain_main_node.damage(pos3,false)
			if be:
				Overall.terrain_main_node.add_block(pos3_,name,0,true)
			return true

#			move_list[pos3] = true
	return false
func create_branch_side(pos3:Vector3,key:String,update:=true) -> void:
	if key:
		Overall.terrain_main_node.add_block(pos3,key,0,update)

func create_branch_down(pos3:Vector3,key:String,update:=true) -> void:
	if key:
		Overall.terrain_main_node.add_block(pos3,key,0,update)



