extends Advanced_Model
func _ready() -> void:
	block_tscn = preload("res://script/iron_age/tscn/wood_blower.tscn")
	name_ = "wood_blower"
	var block = Block.get(name_)
	model = {
		"id" : Block.get_id_from_name(name_),
		#dire，energy
		"d" : [0,0]
	}

	init()
func init_(pos3,key3) -> void:
	update(pos3)
func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	model.d[0] = dire
	var i := 0
	for offset in Config.VEC_ORDER4:
		var p = offset+pos3
		if Overall.terrain_main_node.get_name_(p) == "brick_blast_furnace_brick":
			if i ==0:dire=2
			if i ==1:dire=3
			if i ==2:dire=0
			if i ==3:dire=1
			Overall.terrain_main_node.set_voxel_client(pos3,Block.get_id_from_name("wood_blower")+dire) 
			break
		i +=1
	._place(pos3,block_name,dire)
#	Overall.terrain_main_node.place(pos3,"wood_w")
	Terrain.set_box(pos3,self)
	#net
	Overall.rpc_item_script(block_name,"p_c",[pos3,dire])
func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	._damage(pos3,block_name,dire)
	var pos3_arr = Function.vec_arr(pos3)
	if !Net.status:d([pos3_arr])
	#net
	Overall.rpc_item_script_master(name_,"d",[pos3_arr])
func _update(pos3:Vector3,block_name:String,dire:int) -> void:
	._update(pos3,block_name,dire)
	
func transmission(pos3,energy) -> float:
	var pos3_arr = Function.vec_arr(pos3)
	var d = list[pos3_arr].d
	var u = false
	if energy == 0.0:
		d[1] = 0.0
		u = true
	else:
		if d[1] == 0.0:
			u = true
		if d[1] < 1.0:
			if d[1] + energy <= 1.0:
				d[1] += energy
			else:
				energy -= 1.0 - d[1]
				d[1] = 1.0
	var node = Overall.chunks_node_node.get_block_real(pos3)
	node.start(d[1])
	if u:
		Overall.terrain_main_node.update_around(pos3)
	return energy
func is_start(pos3:Vector3) -> bool:
	var pos3_arr = Function.vec_arr(pos3)
	if list[pos3_arr].d[1] > 0:
		return true
	else:
		return false
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
	var dire = args[1]
	Overall.terrain_main_node.set_voxel_client(pos3,Block.get_id_from_name("wood_blower")+dire)
#被通知破坏
func d_c(args:Array) -> void:
	var pos3_arr = args[0]
	Terrain.del_box_arr(pos3_arr,self)
