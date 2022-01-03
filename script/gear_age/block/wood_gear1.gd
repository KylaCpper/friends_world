extends Advanced_Model
var limit = 1
func _ready() -> void:
	block_tscn = preload("res://script/gear_age/tscn/wood_gear.tscn")
	name_ = "wood_gear"
	var block = Block.get(name_)
	
	model = {
		"id" : Block.get_id_from_name(name_),
		#dire，energy anti
		"d" : [0,0,false]
	}
	

	init()
#func init_c(pos3,key3) -> void:
#	update(pos3)
func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	Terrain.set_box(pos3,self)
	._place(pos3,block_name,dire)
#	var pos3_arr = Function.vec_arr(pos3)
#	var list_data = list[pos3_arr].d
#	for offset in Config.VEC_ORDER4:
#		var p = pos3+offset
#		if Overall.terrain_main_node.get_name_(p) == "wood_gear":
#			var pos3_arr_be = Function.vec_arr(p)
#			var list_data_be = list[pos3_arr_be].d
#			if list_data_be[1]>0.0:
#				list_data[2]=!list_data_be[2]
#				list_data[1] = list_data_be[1]
#				break
#	var pos3_arr = Function.vec_arr(pos3)
#	var list_data = list[pos3_arr].d
#	var list_arr = []
#	for offset in Config.VEC_ORDER4:
#		var p = pos3+offset
#		var name_be = Overall.terrain_main_node.get_name_(p)
#
#		if Block.is_generate_power_machine(name_be):
#			var item = Item.get(name_be)
#			item.script._update(p,name_be,Block.get_dire(Overall.terrain_main_node.get_id(p)))
			
	#net
	Overall.rpc_item_script(block_name,"p_c",[pos3])
func _update(pos3:Vector3,block_name:String,dire:int) -> void:
	._update(pos3,block_name,dire)
	
	var pos3_arr = Function.vec_arr(pos3)
	var list_data = list[pos3_arr].d
	var list_arr = []
	var energy = 0.0
	var c_energy = list_data[1]
	for offset in Config.VEC_ORDER4:
		var p = pos3+offset
		var name_be = Overall.terrain_main_node.get_name_(p)
		if Block.is_generate_power_machine(name_be):
			var item = Item.get(name_be)
			var e = item.script.get_energy(p)
			if e > limit:e = limit
			list_data[1] = e
			energy = e
		if Block.is_gear(name_be):
#			#有能量源头
#			if energy == limit:
#				_update(p,block_name,dire)
			#无能量源头
#			else:
				var pos3_arr_be = Function.vec_arr(p)
				var list_data_be = list[pos3_arr_be].d
				list_arr.append([p,list_data_be])
				#其他有能量
				if list_data_be[1] >0.1:
					if list_data_be[1] > energy:
						energy = list_data_be[1] - 0.1
						list_data[2] = !list_data_be[2]
						list_data[1] = energy
						
					#其他比我高
#					if list_data_be[1] > list_data[1]:
#						#比我高一等级以上
#						if list_data_be[1] > list_data[1] + 0.1:
#							list_data[1] = list_data_be[1]-0.1
#							_update(p,block_name,dire)
#					#比我低
#					else:
#						#比我低一等级以上
#						if list_data_be[1] < list_data[1] + 0.1:
#							list_data[1] = list_data_be[1]-0.1
#							_update(p,block_name,dire)
							
						#更新自己齿轮状态为比我高
				#其他无能量
#				else:
#					#我有能量且大于等级1
#					if list_data[1] > 0.1:
#						_update(p,block_name,dire)
	list_data[1] = energy
	if energy != c_energy:
		yield(Overall.get_tree(),"idle_frame")

		for d in list_arr:
			_update(d[0],block_name,dire)
#			list_arr.append(list_data_be)
#	if list_arr.size == 0:
#		pass
#	else:
#
#		for other in list_arr:
		update(pos3)
func check_gear(this,other) -> void:
	#其他齿轮 能量 大于0
	if other[1]>0:
		# 自己和其他大于0
		if this[1] >0 :
			#齿轮能量一样
			if this[1] == other[1]:
				this[2]=!other[2]
			#齿轮能量不一样
			else:
				this[2]=!other[2]
				this[1] = other[1]
		#自己无能量 其他有能量
		else:
			this[2]=!other[2]
			this[1] = other[1]
	#其他齿轮 无能量
	else:
		#自己有能量 其他无
		if this[1] > 0:
			pass
		#都无能量
		else:
			pass
func check_around(pos3,dire) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	list[pos3_arr].d[1] = 0.0
	if dire == 0:
		var p = pos3+Vector3(-1,-1,1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.33
		p = pos3+Vector3(0,-1,1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.33
		p = pos3+Vector3(1,-1,1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.34
	if dire == 1:
		var p = pos3+Vector3(-1,-1,-1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.33
		p = pos3+Vector3(-1,-1,0)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.33
		p = pos3+Vector3(-1,-1,1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.34
	if dire == 2:
		var p = pos3+Vector3(1,-1,-1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.33
		p = pos3+Vector3(0,-1,-1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.33
		p = pos3+Vector3(-1,-1,-1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.34
	if dire == 3:
		var p = pos3+Vector3(1,-1,-1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.33
		p = pos3+Vector3(1,-1,0)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.33
		p = pos3+Vector3(1,-1,1)
		if Overall.terrain_main_node.get_name_(p) == "water":
			list[pos3_arr].d[1] += 0.34
#	if list[pos3_arr].d[1] >= 1.0:
	update(pos3)
func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	._damage(pos3,block_name,dire)
	var pos3_arr = Function.vec_arr(pos3)
	if !Net.status:d([pos3_arr])
	#net
	Overall.rpc_item_script_master(name_,"d",[pos3_arr])

	
#func _event(world_pos3:Vector3,block_name:String,dire:int) -> bool:
#	var pos3 = Overall.terrain_main_node.get_block_pos3(world_pos3)
#	var pos3_arr = Function.vec_arr(pos3)
#	var node = Overall.chunks_node_node.get_block_real(pos3)
#	var data = list[pos3_arr]
#	data.d[1] = 1.0
#	node.start(data.d[1])
#
#	#net
#	Overall.rpc_item_script_master(block_name,"s",[pos3])
#	return true

func update(pos3:Vector3) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	var node = Overall.chunks_node_node.get_block_real(pos3)
	var data = list[pos3_arr]
	if data.d[1]:
		node.start(data.d[1],data.d[2])
	else:
		node.stop()

func drop(pos3,name_:String,num:int) -> void:
	Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),1.1,randf()),{"name":name_,"num":num},Vector3(0,1,0))


#net
#有操作 传数据给大家同步
func sync_all(pos3) -> void:
	var box = Terrain.get_save_from_id(pos3,model.id)
	var pos3_arr = Function.vec_arr(pos3)
	Overall.rpc_item_script(name_,"s_d",[pos3_arr,box])
#被通知同步数据
func s_d(args:Array) -> void:
	var pos3_arr = args[0]
	var data = args[1]
	var pos3 = Vector3(pos3_arr[0],pos3_arr[1],pos3_arr[2])
	var box = Terrain.get_save_from_id(pos3,model.id)
	if !box:
		return
	for key in data:
		if key == "d":
			box[key][0]=data[key][0]
			box[key][1]=data[key][1]
		else:
			box[key] = data[key]
	update(pos3)
#master
#广播同步数据
func s(args:Array) -> void:
	var pos3 = args[0]
	var box = Terrain.get_save_from_id(pos3,model.id)
	var pos3_arr = Function.vec_arr(pos3)
	Overall.rpc_item_script(name_,"s_d",[pos3_arr,box])
#广播破坏
func d(args:Array) -> void:
	var pos3_arr = args[0]
	var pos3 = Function.arr_vec(pos3_arr)
	if pos3_arr in list:
		Terrain.del_box(pos3,self)
	Overall.rpc_item_script(name_,"d_c",[pos3_arr])
#client
#被通知放置
func p_c(args:Array) -> void:
	var pos3 = args[0]
	Terrain.set_box(pos3,self)
#被通知破坏
func d_c(args:Array) -> void:
	var pos3_arr = args[0]
	Terrain.del_box_arr(pos3_arr,self)
