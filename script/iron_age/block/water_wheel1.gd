extends Advanced_Model
func _ready() -> void:
	block_tscn = preload("res://script/iron_age/tscn/water_wheel.tscn")
	name_ = "water_wheel"
	var block = Block.get(name_)
	model = {
		"id" : Block.get_id_from_name(name_),
		#dire，energy
		"d" : [0,0]
	}

	init()
	PowerList.update_all()
func init_(pos3,key3) -> void:
	PowerList.add_vertex(pos3,2)
	update(pos3)
func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	model.d[0]=dire
	Terrain.set_box(pos3,self)
	._place(pos3,block_name,dire)
	check_around(pos3,dire)
	var arr = Function.vec_arr(pos3)
	PowerList.add_vertex_update(pos3,2)
	#net
	Overall.rpc_item_script(block_name,"p_c",[pos3])
func _update(pos3:Vector3,block_name:String,dire:int) -> void:
	._update(pos3,block_name,dire)
#	check_around(pos3,dire)
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
	PowerList.del_vertex_update(pos3)
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
		node.start(data.d[1])
	else:
		node.stop()

func drop(pos3,name_:String,num:int) -> void:
	Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),1.1,randf()),{"name":name_,"num":num},Vector3(0,1,0))
func get_energy(pos3:Vector3) -> float:
	var pos3_arr = Function.vec_arr(pos3)
	return list[pos3_arr].d[1]

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
