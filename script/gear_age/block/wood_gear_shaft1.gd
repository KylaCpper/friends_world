extends Advanced_Model
var limit = 1
func _ready() -> void:
	block_tscn = preload("res://script/gear_age/tscn/wood_gear_shaft.tscn")
	name_ = "wood_gear_shaft"
	var block = Block.get(name_)
	
	model = {
		"id" : Block.get_id_from_name(name_),
		#dire，energy anti
		"d" : [0,0,false]
	}
	

	init()
	PowerList.update_all()
func init_(pos3,pos3_arr) -> void:
	update(pos3)
	PowerList.add_vertex(pos3,0,0,list[pos3_arr].d[0])
func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	model.d[0] = dire
	Terrain.set_box(pos3,self)
#	var pos3_arr = Function.vec_arr(pos3)
	PowerList.add_vertex_update(pos3,0,0,dire)
	._place(pos3,block_name,dire)
	
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
	for offset in [Vector3(0,-1,0),Vector3(0,1,0)]:
		var p = pos3+offset
		var arr = Function.vec_arr(p)
		if arr in list:
			if list[arr].d[1] >0:
				list[pos3_arr].d[2] = !list[arr].d[2]
				break
	if dire == 0 || dire == 2:
		var be := false
		for offset in [Vector3(-1,0,0),Vector3(1,0,0)]:
			var p = pos3+offset
			var arr = Function.vec_arr(p)
			if arr in list:
				if list[arr].d[1] >0:
					list[pos3_arr].d[2] = list[arr].d[2]
					be = true
					break
		if !be:
			for offset in [Vector3(0,0,-1),Vector3(0,0,1)]:
				var p = pos3+offset
				var arr = Function.vec_arr(p)
				if arr in list:
					if list[arr].d[1] >0:
						list[pos3_arr].d[2] = !list[arr].d[2]
						break
	else:
		var be := false
		for offset in [Vector3(0,0,-1),Vector3(0,0,1)]:
			var p = pos3+offset
			var arr = Function.vec_arr(p)
			if arr in list:
				if list[arr].d[1] >0:
					list[pos3_arr].d[2] = list[arr].d[2]
					be = true
					break
		if !be:
			for offset in [Vector3(-1,0,0),Vector3(1,0,0)]:
				var p = pos3+offset
				var arr = Function.vec_arr(p)
				if arr in list:
					if list[arr].d[1] >0:
						list[pos3_arr].d[2] = !list[arr].d[2]
						break
	if PowerList.is_connect(pos3):
		if list[pos3_arr].d[1] != 1:
			list[pos3_arr].d[1]=1
			Overall.terrain_main_node.update_around(pos3)
	else:
		if list[pos3_arr].d[1] != 0:
			list[pos3_arr].d[1]=0
			Overall.terrain_main_node.update_around(pos3)

	update(pos3)
func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	PowerList.del_vertex_update(pos3)
	_update(pos3,block_name,dire)
	Overall.terrain_main_node.update_around(pos3)
	._damage(pos3,block_name,dire)
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
