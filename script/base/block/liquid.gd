extends Object
const VEC_ORDER := [
	[Vector3(1,0,0),Vector3(0,0,-1),
	Vector3(0,0,1),Vector3(-1,0,0)],
	
	[Vector3(-1,0,0),Vector3(0,0,1),
	Vector3(0,0,-1),Vector3(1,0,0)],
	
	[Vector3(0,0,1),Vector3(0,0,-1),
	Vector3(1,0,0),Vector3(-1,0,0)],
	
	[Vector3(0,0,-1),Vector3(1,0,0),
	Vector3(-1,0,0),Vector3(0,0,1)],
]
const VEC_ORDER2 := [
	[
		[Vector3(1,0,0),Vector3(0,0,1)],
		[Vector3(0,0,-1),Vector3(1,0,0)],
		[Vector3(0,0,1),Vector3(-1,0,0)],
		[Vector3(-1,0,0),Vector3(0,0,-1)],
	],
	[
		[Vector3(-1,0,0),Vector3(0,0,-1)],
		[Vector3(1,0,0),Vector3(0,0,1)],
		[Vector3(0,0,-1),Vector3(1,0,0)],
		[Vector3(0,0,1),Vector3(-1,0,0)],
	],
	[
		[Vector3(0,0,1),Vector3(-1,0,0)],
		[Vector3(-1,0,0),Vector3(0,0,-1)],
		[Vector3(1,0,0),Vector3(0,0,1)],
		[Vector3(0,0,-1),Vector3(1,0,0)],
	],
	[
		[Vector3(0,0,-1),Vector3(1,0,0)],
		[Vector3(0,0,1),Vector3(-1,0,0)],
		[Vector3(-1,0,0),Vector3(0,0,-1)],
		[Vector3(1,0,0),Vector3(0,0,1)],
	],
]
var time_update := 2
var time_speed := 0.1
var queue := {}
var queue_ := []
#func _init() -> void:
#
#	while true:
#		yield(Config.get_tree().create_timer(5.0),"timeout")
#		list_check.clear()
func _place(pos3:Vector3,name:String,dire:int) -> void:
	if queue.size()>100:return
	if pos3 in queue:return
	queue[pos3] = true
	yield(Overall.get_tree().create_timer(time_speed),"timeout")
	update(pos3,name,dire)

func update(pos3:Vector3,name:String,dire:int) -> void:
#	if name_&&block.branch[3]==name:
#		var block_ = Block.get(name_)
#		if block_.entity:
#			return
	name = Overall.terrain_main_node.get_name_(pos3)
	if !name:
		queue.erase(pos3)
		return
	var block = Block.get(name)
	if !block.liquid:
		queue.erase(pos3)
		return
	var name_ = Overall.terrain_main_node.get_name_(pos3+Vector3(0,-1,0))
	var self_name = name
	var down := false 
	#优先填下方液体  下方方块
	#有方块
	if name_:
		var block_ = Block.get(name_)
		#液体
		if block_.liquid:
			#不为源头
			if block_.branch[0]:
				#相同种类液体
				if block_.branch[2]==block.branch[2]:
					down(block,block_,pos3)
					down = true
				#不同液体
				else:
					pass
			#下方为源头
			else:
				
					var into := false
					var i := randi()%4
					for offset in VEC_ORDER[i]:
						yield(Overall.get_tree(),"idle_frame")
						for ii in range(4):
							yield(Overall.get_tree(),"idle_frame")
							var arr = [block,pos3+Vector3(0,-1,0),false,i,ii,0]
							around_down(arr,offset,false)
							if arr[2]:
								into = true
								if arr[0]:
									block=arr[0]
								else:
									queue.erase(pos3)
									return
								break
					if into:
#						queue.erase(pos3)
						update(pos3,"",dire)
						return
					
#						var name_up = Overall.terrain_main_node.get_name_(pos3+Vector3(0,1,0))
#						if !name_up:return
#						var block_up = Block.get(name_up)
#						if block_up.liquid:update(pos3+Vector3(0,1,0),name_up,dire)
#						yield(Overall.get_tree(),"idle_frame")
#						var pos3_ = pos3 + offset
#						var name_side = Overall.terrain_main_node.get_name_(pos3_)
#						if !name_side:
#							pos3_ += Vector3(0,-1,0)
#							name_side = Overall.terrain_main_node.get_name_(pos3_)
#							var block_side = Block.get(name_side)
#							if name_side:
#								if block_side.liquid:
#									if block_side.branch[0]:
#										if block_side.branch[2]==block.branch[2]:
#											Overall.terrain_main_node.add_block(pos3_,block_side.branch[0],0,true)
#											queue.erase(pos3)
#											if block.branch[1]:
#												Overall.terrain_main_node.add_block(pos3,block.branch[1],0,false)
#												_place(pos3,block.branch[1],dire)
#											return
			

		#非液体
		else:
			#非实体
			if !block_.entity:
				Overall.terrain_main_node.damage(pos3+Vector3(0,-1,0),false)
				Overall.terrain_main_node.create_fall_drop(pos3+Vector3(0,-1,0),name_)
				Overall.terrain_main_node.add_block(pos3+Vector3(0,-1,0),name,0,true)
				down = true
	#无方块
	else:
		Overall.terrain_main_node.add_block(pos3,"",0,false)
		Overall.terrain_main_node.add_block(pos3+Vector3(0,-1,0),name,0,true)
		down = true
	
	var is_change := false
	if down:
		queue.erase(pos3)
		_update(pos3,"",0)
		return
	#周边
	var i := randi()%4
	for offset in VEC_ORDER[i]:
		yield(Overall.get_tree(),"idle_frame")
		name = Overall.terrain_main_node.get_name_(pos3)
		if !name:
			queue.erase(pos3)
			return
		block = Block.get(name)
		if !block.liquid:
			queue.erase(pos3)
			return
		
		var pos3_ = pos3 + offset
		name_ = Overall.terrain_main_node.get_name_(pos3_)
		#有方块
		if name_:
			var block_ = Block.get(name_)
			#液体
			if block_.liquid:
				#周边不为源头
				if block_.branch[0]:
					#相同种类液体
					if block_.branch[2]==block.branch[2]:
						#比周边液体高
						if block.lv < block_.lv:
							if (block.lv+1 == block_.lv):
								for ii in range(4):
									yield(Overall.get_tree(),"idle_frame")
									var arr = [block,pos3,false,i,ii,0]
									around(arr,offset,false)
									
									if arr[2]:
										self_name = block.branch[1]
										is_change = true
										block = arr[0]
										break
									
							else:
								Overall.terrain_main_node.add_block(pos3_,block_.branch[0],0,true)
								Overall.terrain_main_node.add_block(pos3,block.branch[1],0,false)
								block = Block.get(block.branch[1])
								self_name = block.branch[1]
								is_change = true
								update(pos3_,block_.branch[0],dire)
							
					#不同液体
					else:
						pass
				#为源头
				else:
					pass
			#非液体
			else:
				#非实体
				if !block_.entity:
					if block.branch[1]:
						Overall.terrain_main_node.damage(pos3_,false)
						Overall.terrain_main_node.create_fall_drop(pos3_,name_)
						Overall.terrain_main_node.add_block(pos3_,block.branch[3],0,true)
						Overall.terrain_main_node.add_block(pos3,block.branch[1],0,false)
						self_name = block.branch[1]
						block = Block.get(block.branch[1])
					else:
						queue.erase(pos3)
						return
					is_change = true
		#无方块
		else:
			if block.branch[1]:
				Overall.terrain_main_node.add_block(pos3_,block.branch[3],0,true)
				Overall.terrain_main_node.add_block(pos3,block.branch[1],0,false)
				self_name = block.branch[1]
				block = Block.get(block.branch[1])
			else:
				queue.erase(pos3)
				return
			is_change = true
	if is_change:
		update(pos3,self_name,dire)
		_update(pos3+Vector3(-1,0,0),"",0)
		_update(pos3+Vector3(1,0,0),"",0)
		_update(pos3+Vector3(0,0,1),"",0)
		_update(pos3+Vector3(0,0,-1),"",0)
		var name_up = Overall.terrain_main_node.get_name_(pos3+Vector3(0,1,0))
		if !name_up:return
		var block_up = Block.get(name_up)
		if block_up.liquid:update(pos3+Vector3(0,1,0),name_up,dire)
	else:
		queue.erase(pos3)
func _update(pos3:Vector3,name:String,dire:int) -> void:
	if !Overall.terrain_main_node.is_area(AABB(pos3-Vector3(8,8,8),Vector3(17,17,17))):return
	if queue.size()>100:return
	if pos3 in queue:return
	queue[pos3] = true
	yield(Overall.get_tree().create_timer(time_speed),"timeout")
	update(pos3,name,dire)


func around(arr:Array,offset:Vector3,brance:=false) -> void:
	var block = arr[0]
	var pos3 = arr[1]
	var stop = arr[2]
	if stop:return
	arr[5] += 1
	if arr[5] > 100:
		return
	var pos3_ = pos3 + offset
	var name_ = Overall.terrain_main_node.get_name_(pos3_)
	#有方块
	if name_:
		var block_ = Block.get(name_)
		#液体
		if block_.liquid:
			#周边不为源头
			if block_.branch[0]:
				#相同种类液体
				if block_.branch[2]==block.branch[2]:
					#比周边液体高
					if block.lv < block_.lv:
						
						if block.lv+1 == block_.lv:
							if !brance:
								around(arr,offset+VEC_ORDER2[arr[3]][arr[4]][1],true)
								offset += VEC_ORDER2[arr[3]][arr[4]][0]
								around(arr,offset)
							else:
								offset += VEC_ORDER2[arr[3]][arr[4]][1]
								around(arr,offset,true)
							return
						Overall.terrain_main_node.add_block(pos3_,block_.branch[0],0,true)
						Overall.terrain_main_node.add_block(pos3,block.branch[1],0,false)
						block = Block.get(block.branch[1])
						arr[0] = block
						arr[2] = true
						
#						update(pos3_,block_.branch[0],0)
				#不同液体
				else:
					pass
			#为源头
			else:
				pass
		#非液体
		else:
			#非实体
			if !block_.entity:
				if block.branch[1]:
					Overall.terrain_main_node.damage(pos3_,false)
					Overall.terrain_main_node.create_fall_drop(pos3_,name_)
					Overall.terrain_main_node.add_block(pos3_,block.branch[3],0,true)
					Overall.terrain_main_node.add_block(pos3,block.branch[1],0,false)
					block = Block.get(block.branch[1])
					arr[0] = block
					arr[2] = true
				else:
					
					return

	#无方块
	else:
		#不是末分支流体
		if block.branch[1]:
			Overall.terrain_main_node.add_block(pos3_,block.branch[3],0,true)
			Overall.terrain_main_node.add_block(pos3,block.branch[1],0,false)
			block = Block.get(block.branch[1])
			arr[0] = block
			arr[2] = true
		else:
			
			return
			
func around_down(arr:Array,offset:Vector3,brance:=false) -> void:
	var block = arr[0]
	var pos3 = arr[1]#0,-1,0
	var stop = arr[2]
	if stop:return
	arr[5] += 1
	if arr[5] > 100:
		return
	var pos3_ = pos3 + offset
	var name_ = Overall.terrain_main_node.get_name_(pos3_)
	#有方块
	if name_:
		var block_ = Block.get(name_)
		#液体
		if block_.liquid:
			#周边不为源头
			if block_.branch[0]:
				#相同种类液体
				if block_.branch[2]==block.branch[2]:

					Overall.terrain_main_node.add_block(pos3_,block_.branch[0],0,true)
					Overall.terrain_main_node.add_block(pos3+Vector3(0,1,0),block.branch[1],0,false)
					if block.branch[1]:
						block = Block.get(block.branch[1])
					else:
						block = ""
					arr[0] = block
					arr[2] = true
				#不同液体
				else:
					pass
			#为源头
			else:
				if !brance:
					around_down(arr,offset+VEC_ORDER2[arr[3]][arr[4]][1],true)
					offset += VEC_ORDER2[arr[3]][arr[4]][0]
					around_down(arr,offset)
				else:
					offset += VEC_ORDER2[arr[3]][arr[4]][1]
					around_down(arr,offset,true)
				return 
		#非液体
		else:
			#非实体
			if !block_.entity:
				if block.branch[1]:
					Overall.terrain_main_node.damage(pos3_,false)
					Overall.terrain_main_node.create_fall_drop(pos3_,name_)
					Overall.terrain_main_node.add_block(pos3_,block.branch[3],0,true)
					Overall.terrain_main_node.add_block(pos3+Vector3(0,1,0),block.branch[1],0,false)
					block = Block.get(block.branch[1])
					arr[0] = block
					arr[2] = true
				else:
					
					return

	#无方块
	else:
		#不是末分支流体
		if block.branch[1]:
			Overall.terrain_main_node.add_block(pos3_,block.branch[3],0,true)
			Overall.terrain_main_node.add_block(pos3+Vector3(0,1,0),block.branch[1],0,false)
			block = Block.get(block.branch[1])
			arr[0] = block
			arr[2] = true
		else:
			
			return
			
func down(block,block_,pos3) -> void:
	var b_n_ = block_.branch[0]
	block_ = Block.get(b_n_)
	#有余
	if block.branch[1]:
		var b_n = block.branch[1]
		block = Block.get(block.branch[1])
		#下方不满
		if block_.branch[0]:
			down(block,block_,pos3)
		#下方满
		else:
			Overall.terrain_main_node.add_block(pos3+Vector3(0,-1,0),block.branch[2],0,true)
			Overall.terrain_main_node.add_block(pos3,b_n,0,false)
			
	#空
	else:
		Overall.terrain_main_node.add_block(pos3+Vector3(0,-1,0),b_n_,0,true)
		Overall.terrain_main_node.add_block(pos3,"",0,false)

