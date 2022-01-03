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
func init_(pos3,key3) -> void:
	update(pos3)
func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	model.d[0] = dire
	Terrain.set_box(pos3,self)
#	var pos3_arr = Function.vec_arr(pos3)
	._place(pos3,block_name,dire)
	Overall.rpc_item_script(block_name,"p_c",[pos3,dire])
func _update(pos3:Vector3,block_name:String,dire:int) -> void:
	._update(pos3,block_name,dire)


	
func transmission(pos3:Vector3,energy:float,map:Dictionary,other=[]) -> void:

	var pos3_arr := Function.vec_arr(pos3)
	energy -= 0.1
	if energy < 0.0:energy = 0.0
	yield(Overall.get_tree(),"idle_frame")
	if !pos3_arr in list:return
	list[pos3_arr].d[1]=energy
	var tn := Overall.terrain_main_node
	var id = tn.get_id(pos3)
	if id == 0:return
	var dire = Block.get_dire(id)
	var be := false
	if other.size()>0:
		list[pos3_arr].d[2]=other[0]
				
	if dire == 0 || dire == 2:
		for offset in [Vector3(0,0,-1),Vector3(0,0,1)]:
			var p = offset + pos3
			var block_name = tn.get_name_(p)
			if Block.is_use_power_machine(block_name):
				map[p]=1
				energy = Block.get(block_name).script.transmission(p,energy)
	else:
		for offset in [Vector3(-1,0,0),Vector3(1,0,0)]:
			var p = offset + pos3
			if !p in map:
				var block_name = tn.get_name_(p)
				if Block.is_use_power_machine(block_name):
					map[p]=1
					
					energy = Block.get(block_name).script.transmission(p,energy)
	
	for offset in [Vector3(0,-1,0),Vector3(0,1,0)]:
		var p = offset + pos3
		if !p in map:
			var block_name = tn.get_name_(p)
			if Block.is_gear(block_name):
				map[p]=1
				var dire_ = Block.get_dire(tn.get_id(p))
				if is_transmission(dire,dire_):
					Block.get(block_name).script.transmission(p,energy,map,[!list[pos3_arr].d[2]])
	if dire == 0 || dire == 2:
		for offset in [Vector3(-1,0,0),Vector3(1,0,0)]:
			var p = offset + pos3
			if !p in map:
				var block_name = tn.get_name_(p)
				if Block.is_gear(block_name):
					map[p]=1
					var dire_ = Block.get_dire(tn.get_id(p))
					if is_transmission(dire,dire_):
						Block.get(block_name).script.transmission(p,energy,map,[!list[pos3_arr].d[2]])
		for offset in [Vector3(0,0,-1),Vector3(0,0,1)]:
			var p = offset + pos3
			if !p in map:
				var block_name = tn.get_name_(p)
				if Block.is_gear(block_name):
					map[p]=1
					var dire_ = Block.get_dire(tn.get_id(p))
					if is_transmission(dire,dire_):
						Block.get(block_name).script.transmission(p,energy,map,[list[pos3_arr].d[2]])
	else:
		for offset in [Vector3(0,0,-1),Vector3(0,0,1)]:
			var p = offset + pos3
			if !p in map:
				var block_name = tn.get_name_(p)
				if Block.is_gear(block_name):
					map[p]=1
					var dire_ = Block.get_dire(tn.get_id(p))
					if is_transmission(dire,dire_):
						Block.get(block_name).script.transmission(p,energy,map,[!list[pos3_arr].d[2]])
		for offset in [Vector3(-1,0,0),Vector3(1,0,0)]:
			var p = offset + pos3
			if !p in map:
				var block_name = tn.get_name_(p)
				if Block.is_gear(block_name):
					map[p]=1
					var dire_ = Block.get_dire(tn.get_id(p))
					if is_transmission(dire,dire_):
						Block.get(block_name).script.transmission(p,energy,map,[list[pos3_arr].d[2]])
	update(pos3)

func is_transmission(dire,dire_) -> bool:
	if dire == 0 || dire == 2:
		if dire_ == 1 || dire_ == 3:
			return false
	if dire == 1 || dire == 3:
		if dire_ == 0 || dire_ == 2:
			return false
	return true


func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	._damage(pos3,block_name,dire)
	var tn = Overall.terrain_main_node
	var map = {}
	for offset in Config.VEC_ORDER2:
		var p = offset + pos3
		var bn = tn.get_name_(p)
		if Block.is_gear(bn):
			map[p]=1
			Block.get(bn).script.transmission(p,0.0,map)
		elif Block.is_use_power_machine(bn):
			map[p]=1
			Block.get(bn).script.transmission(p,0.0)
	if pos3_arr in list:
		Terrain.del_box(pos3,self)
	#net
	Overall.rpc_item_script(name_,"d_c",[pos3_arr])

	
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
#func d(args:Array) -> void:
#	var pos3_arr = args[0]
#	var pos3 = Function.arr_vec(pos3_arr)
#	if pos3_arr in list:
#		Terrain.del_box(pos3,self)
#	Overall.rpc_item_script(name_,"d_c",[pos3_arr])
#client
#被通知放置
func p_c(args:Array) -> void:
	var pos3 = args[0]
	model.d[0] = args[1]
	Terrain.set_box(pos3,self)
	
#被通知破坏
func d_c(args:Array) -> void:
	var pos3_arr = args[0]
	Terrain.del_box_arr(pos3_arr,self)
	var pos3 = Function.arr_vec(pos3_arr)
	var tn = Overall.terrain_main_node
	var map = {}
	for offset in Config.VEC_ORDER2:
		var p = offset + pos3
		var bn = tn.get_name_(p)
		if Block.is_gear(bn):
			map[p]=1
			Block.get(bn).script.transmission(p,0.0,map)
		elif Block.is_use_power_machine(bn):
			map[p]=1
			Block.get(bn).script.transmission(p,0.0)
