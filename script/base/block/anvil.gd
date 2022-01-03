extends Advanced_Model
class_name Anvil
var particles_tscn := preload("res://tscn/particle/anvil.tscn")

func init_(pos3,key3) -> void:
	update(pos3)
func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	._place(pos3,block_name,dire)
	Terrain.set_box(pos3,self)
	#net
	Overall.rpc_item_script(block_name,"p_c",[pos3])
func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	._damage(pos3,block_name,dire)
	var pos3_arr = Function.vec_arr(pos3)
	if !Net.status:d([pos3_arr])
	Overall.rpc_item_script_master(name_,"d",[pos3_arr])

	
func _event(world_pos3:Vector3,block_name:String,dire:int) -> bool:
	var pos3 = Overall.terrain_main_node.get_block_pos3(world_pos3)
	var pos3_arr = Function.vec_arr(pos3)
	var data = list[pos3_arr]
	Overall.gui_node_node.change_ui("anvil",data)
	Overall.anvil_node.obj_script = self
	Overall.anvil_node.obj_pos3 = pos3
	Overall.anvil_node.update()
	#net
	Overall.rpc_item_script_master(block_name,"s",[pos3])
	return true

func _mouse_left(world_pos3:Vector3,block_name:String,dire:int) -> bool:
	var pos3 = Overall.terrain_main_node.get_block_pos3(world_pos3)
	var pos3_arr = Function.vec_arr(pos3)
	var data = list[pos3_arr]
	if data.key == -1:return false
	var composite = Composite.anvil[data.key]
	var i := 0
	var be := true
	
	for table in composite[2]:
		if data.list[i].name == table[0]:
			if data.list[i].num >= table[1]:
				pass
			else:
				be = false
				break
		else:
			be = false
			break
			
		i +=1
	if be:
		var is_hammer := false
		var hand = Overall.player_node.get_hand()
		if hand.name:
			var item = Item.get(hand.name)
			if item.type == "tool":
				for t in item.tool:
					if t == "hammer":
						is_hammer = true
						break
			if is_hammer:
				var pro = randi()%6+5
				hand.hp -= pro
				pro *= item.lv
				Overall.bar_node.update()
				
				add_par([pos3])
				Overall.rpc_item_script(block_name,"add_par",[pos3])
				Overall.rpc_item_script_master(block_name,"add_pros",[pos3,pro])
				if !Net.status:
					add_pros([pos3,pro])
				
			else:
				be = false
				Overall.msg_node.add_msg(Overall.tr("anvil_err2"))
		else:
			be = false
			#工具不适合
			Overall.msg_node.add_msg(Overall.tr("anvil_err2"))
	else:
		#材料不足
		Overall.msg_node.add_msg(Overall.tr("anvil_err1"))
	return be
func add_par(args:Array) -> void:
	var pos3 = args[0]
	var tscn = particles_tscn.instance()
	tscn.translation = Vector3(0,0.4,0)
	Overall.chunks_node_node.get_block_real(pos3).add_child(tscn)
func add_pros(args:Array) -> void:
	var pos3 = args[0]
	var pro = args[1]
	var pos3_arr = Function.vec_arr(pos3)
	var data = list[pos3_arr]
	data.pros[0] += pro
	data.hp -= pro
	var composite = Composite.anvil[data.key]
	if data.pros[0] >= data.pros[1]:
		data.pros[0] = 0
		var i = 0
		for table in composite[2]:
			if data.list[i].name == table[0]:
					data.list[i].num -= table[1]
					if data.list[i].num <= 0:
						Overall.item_clear(data.list[i])
			i +=1
		for export_ in composite[0]:
			#export_ [name,num,pro,stop]
			var drop := true
			if !(Function.rand()<export_[2]):
				drop = false
			if drop:
				if !data.export_list[0].name:
					data.export_list[0].name = export_[0]
					data.export_list[0].num = export_[1]
					if "hp" in Item.get(export_[0]):
						data.export_list[0].hp = Item.get(export_[0]).hp
					else:
						data.export_list[0].hp = 0
				else:
					if data.export_list[0].name == export_[0]:
						var _max = Item.get(export_[0]).max
						if data.export_list[0].num + export_[1] <= _max:
							data.export_list[0].num += export_[1]
						else:
							var sub = export_[1] - _max - data.export_list[0].num
							data.export_list[0].num = _max
							drop(pos3,export_[0],sub)
					else:
						drop(pos3,export_[0],export_[1])
				if export_[3]:break
		update(pos3)
	if Overall.anvil_node.visible:
		if Overall.anvil_node.obj_pos3 == pos3:
			Overall.anvil_node.update()
	s([pos3])
	if data.hp <= 0:
		yield(Overall.get_tree().create_timer(0.3),"timeout")
		Overall.terrain_main_node.create_fall_drop(pos3,name_)
		Overall.terrain_main_node.damage(pos3)
func update(pos3:Vector3) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	var node = Overall.chunks_node_node.get_block_real(pos3)
	var data = list[pos3_arr]
	node.get_node("0")._show(data.list[0].name)
	node.get_node("1")._show(data.list[1].name)
	node.get_node("2")._show(data.export_list[0].name)

func drop(pos3,name_:String,num:int) -> void:
	Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),1.1,randf()),{"name":name_,"num":num},Vector3(0,1,0))


#net
#有操作 传数据给大家同步
func sync_all(pos3) -> void:
	var box = Terrain.get_save_from_id(pos3,model.id)
	var pos3_arr = Function.vec_arr(pos3)
	Overall.rpc_item_script(name_,"s_c",[pos3_arr,box])

#master
#广播同步数据
func s(args:Array) -> void:
	var pos3 = args[0]
	var box = Terrain.get_save_from_id(pos3,model.id)
	var pos3_arr = Function.vec_arr(pos3)
	Overall.rpc_item_script(name_,"s_c",[pos3_arr,box])
#广播破坏
func d(args:Array) -> void:
	var pos3_arr = args[0]
	var pos3 = Function.arr_vec(pos3_arr)
	if pos3_arr in list:
		for data in list[pos3_arr].list:
			Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),randf(),randf()),data,Vector3(0,1,0))
		for data in list[pos3_arr].export_list:
			Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),randf(),randf()),data,Vector3(0,1,0))
		Terrain.del_box(pos3,self)
	Overall.rpc_item_script(name_,"d_c",[pos3_arr])
#client
func p_c(args:Array) -> void:
	var pos3 = args[0]
	Terrain.set_box(pos3,self)
func s_c(args:Array) -> void:
	var pos3_arr = args[0]
	var data = args[1]
	var pos3 = Vector3(pos3_arr[0],pos3_arr[1],pos3_arr[2])
	var box = Terrain.get_save_from_id(pos3,model.id)
	if !box:
		return
	for key in data:
		if key == "list" || key == "export_list":
			var i = 0
			for data1 in data[key]:
				box[key][i].name = data1.name
				box[key][i].num = data1.num
				box[key][i].hp = data1.hp
				i+=1
		elif key == "pros":
			box[key][0]=data[key][0]
			box[key][1]=data[key][1]
		else:
			box[key] = data[key]
	update(pos3)
	if Overall.anvil_node.visible:
		if Overall.anvil_node.obj_pos3 == pos3:
			Overall.anvil_node.update()
func d_c(args:Array) -> void:
	var pos3_arr = args[0]
	Terrain.del_box_arr(pos3_arr,self)
