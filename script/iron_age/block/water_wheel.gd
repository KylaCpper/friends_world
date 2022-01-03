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
	
	Overall.connect("_process",self,"_process")
	init()

func init_(pos3,key3) -> void:
	var dire = list[key3].d[0]
	var script = Block.get("water_wheel_help").script
	if dire == 0 || dire == 2:
		
		for offset in [
			Vector3(1,0,0),Vector3(-1,0,0),
			Vector3(1,1,0),Vector3(0,1,0),Vector3(-1,1,0),
			Vector3(1,2,0),Vector3(0,2,0),Vector3(-1,2,0),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.place(p,"water_wheel_help",dire,false)
			script.list[p_arr] = pos3
	else:
		for offset in [
			Vector3(0,0,1),Vector3(0,0,-1),
			Vector3(0,1,1),Vector3(0,1,0),Vector3(0,1,-1),
			Vector3(0,2,1),Vector3(0,2,0),Vector3(0,2,-1),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.place(p,"water_wheel_help",dire,false)
			script.list[p_arr] = pos3
	update(pos3)
func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	model.d[0]=dire
	Terrain.set_box(pos3,self)
	._place(pos3,block_name,dire)
	check_around(pos3,dire)
	var script = Block.get("water_wheel_help").script
	if dire == 0 || dire == 2:
		
		for offset in [
			Vector3(1,0,0),Vector3(-1,0,0),
			Vector3(1,1,0),Vector3(0,1,0),Vector3(-1,1,0),
			Vector3(1,2,0),Vector3(0,2,0),Vector3(-1,2,0),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.place(p,"water_wheel_help",dire,false)
			script.list[p_arr] = pos3
	else:
		for offset in [
			Vector3(0,0,1),Vector3(0,0,-1),
			Vector3(0,1,1),Vector3(0,1,0),Vector3(0,1,-1),
			Vector3(0,2,1),Vector3(0,2,0),Vector3(0,2,-1),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.place(p,"water_wheel_help",dire,false)
			script.list[p_arr] = pos3

	#net
	Overall.rpc_item_script(block_name,"p_c",[pos3,dire])
func _update(pos3:Vector3,block_name:String,dire:int) -> void:
	._update(pos3,block_name,dire)
	check_around(pos3,dire)
func check_around(pos3,dire) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	if !pos3_arr in list:return
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
	_off(pos3,dire)

	if pos3_arr in list:
		Terrain.del_box(pos3,self)
	#net
	Overall.rpc_item_script(name_,"d_c",[pos3_arr])
func _off(pos3,dire) -> void:
	var script = Block.get("water_wheel_help").script
	if dire == 0 || dire == 2:
		for offset in [
			Vector3(1,2,0),Vector3(0,2,0),Vector3(-1,2,0),
			Vector3(1,1,0),Vector3(0,1,0),Vector3(-1,1,0),
			Vector3(1,0,0),Vector3(-1,0,0),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
#			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.set_voxel(p,0)
			script.list.erase(p_arr)
	else:
		for offset in [
			Vector3(0,2,1),Vector3(0,2,0),Vector3(0,2,-1),
			Vector3(0,1,1),Vector3(0,1,0),Vector3(0,1,-1),
			Vector3(0,0,1),Vector3(0,0,-1),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.set_voxel(p,0)
			script.list.erase(p_arr)
var time := 0.0
func _process(delta:float) -> void:
	time += delta
	if time > 0.1:
		time = 0.0
		for pos3_arr in list:
			var map = {}
			transmission(Function.arr_vec(pos3_arr),list[pos3_arr].d[1],map)
	
func transmission(pos3:Vector3,energy:float,map:Dictionary) -> void:
	var tn := Overall.terrain_main_node
#	if Net.id != 1:print(pos3,11111)
	for offset in Config.VEC_ORDER2:
		var p = offset + pos3
		if !p in map:
			var block_name = tn.get_name_(p)
			if Block.is_gear(block_name):
#				if Net.id != 1:print(pos3,222)
				map[p]=1
				Block.get(block_name).script.transmission(p,energy,map)
				
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
	model.d[0] = args[1]
	Terrain.set_box(pos3,self)
	var dire = list[Function.vec_arr(pos3)].d[0]
	var script = Block.get("water_wheel_help").script
	if dire == 0 || dire == 2:
		
		for offset in [
			Vector3(1,0,0),Vector3(-1,0,0),
			Vector3(1,1,0),Vector3(0,1,0),Vector3(-1,1,0),
			Vector3(1,2,0),Vector3(0,2,0),Vector3(-1,2,0),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.place(p,"water_wheel_help",dire,false)
			script.list[p_arr] = pos3
	else:
		for offset in [
			Vector3(0,0,1),Vector3(0,0,-1),
			Vector3(0,1,1),Vector3(0,1,0),Vector3(0,1,-1),
			Vector3(0,2,1),Vector3(0,2,0),Vector3(0,2,-1),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.place(p,"water_wheel_help",dire,false)
			script.list[p_arr] = pos3
	check_around(pos3,dire)
	update(pos3)
#被通知破坏
func d_c(args:Array) -> void:
	var pos3_arr = args[0]
	var script = Block.get("water_wheel_help").script
	if !pos3_arr in list:
		return
	var dire = list[pos3_arr].d[0]
	var pos3 = Function.arr_vec(pos3_arr)
	if dire == 0 || dire == 2:
		for offset in [
			Vector3(1,2,0),Vector3(0,2,0),Vector3(-1,2,0),
			Vector3(1,1,0),Vector3(0,1,0),Vector3(-1,1,0),
			Vector3(1,0,0),Vector3(-1,0,0),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
#			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.set_voxel(p,0)
			script.list.erase(p_arr)
	else:
		for offset in [
			Vector3(0,2,1),Vector3(0,2,0),Vector3(0,2,-1),
			Vector3(0,1,1),Vector3(0,1,0),Vector3(0,1,-1),
			Vector3(0,0,1),Vector3(0,0,-1),
			]:
			var p = pos3 + offset
			var p_arr = Function.vec_arr(p)
			Overall.terrain_main_node.set_voxel(p,0)
			script.list.erase(p_arr)

	
	Terrain.del_box_arr(pos3_arr,self)
