extends Node

var chunks_tscn := preload("res://scene/main/chunk.tscn")

func _ready() -> void:
	Overall.chunks_node_node = self
func delete_block_real(bpos3:Vector3):
	var cpos3 = get_chunk_pos3(bpos3)
	var x = str(cpos3.x)
	var y = str(cpos3.y)
	var z = str(cpos3.z)
	if has_node(x):
		var x_n = get_node(x)
		if x_n.has_node(y):
			var y_n = x_n.get_node(y)
			if y_n.has_node(z):
				var z_n = y_n.get_node(z)
				if z_n.has_node(str(bpos3)):
					var block_n = z_n.get_node(str(bpos3))
					block_n.name = "free"
					block_n.queue_free()
func get_block_real(bpos3:Vector3):
	var cpos3 = get_chunk_pos3(bpos3)
	var x = str(cpos3.x)
	var y = str(cpos3.y)
	var z = str(cpos3.z)
	if has_node(x):
		var x_n = get_node(x)
		if x_n.has_node(y):
			var y_n = x_n.get_node(y)
			if y_n.has_node(z):
				var z_n = y_n.get_node(z)
				if z_n.has_node(str(bpos3)):
					return z_n.get_node(str(bpos3))


func is_place(bpos3:Vector3) -> bool:
	var cpos3 = get_chunk_pos3(bpos3)
	var x = str(cpos3.x)
	var y = str(cpos3.y)
	var z = str(cpos3.z)
	if has_node(x):
		var x_n = get_node(x)
		if x_n.has_node(y):
			var y_n = x_n.get_node(y)
			if y_n.has_node(z):
				var z_n = y_n.get_node(z)
				if z_n.has_node(str(bpos3)):
					return false

	return true


func place_real(bpos3:Vector3,tscn:MeshInstance,block_name:String,dire:=0) -> void:
	var cpos3 = get_chunk_pos3(bpos3)
	var x = str(cpos3.x)
	var y = str(cpos3.y)
	var z = str(cpos3.z)
	if has_node(x):
		var x_n = get_node(x)
		if x_n.has_node(y):
			var y_n = x_n.get_node(y)
			if y_n.has_node(z):
				var z_n = y_n.get_node(z)
				if z_n.has_node(str(bpos3)):
					pass
#					var block_n = z_n.get_node(str(bpos3))
#					block_n.name = "free"
#					block_n.queue_free()
#					tscn.name = str(bpos3)
#					tscn.translation = bpos3+Vector3(0.5,0.5,0.5)
#					z_n.add_child(tscn)
				else:
					tscn.name = str(bpos3)
					adjustment_dire(tscn,block_name,dire)
					z_n.add_child(tscn)
					
			else:
				var tscn_z := chunks_tscn.instance()
				tscn_z.name = z
				y_n.add_child(tscn_z)
				tscn.name = str(bpos3)
				adjustment_dire(tscn,block_name,dire)
				tscn_z.add_child(tscn)
		else:
			var tscn_y := chunks_tscn.instance()
			tscn_y.name = y
			x_n.add_child(tscn_y)
			var tscn_z := chunks_tscn.instance()
			tscn_z.name = z
			tscn_y.add_child(tscn_z)
			tscn.name = str(bpos3)
			adjustment_dire(tscn,block_name,dire)
			tscn_z.add_child(tscn)
	else:
		var tscn_x := chunks_tscn.instance()
		tscn_x.name = x
		add_child(tscn_x)
		var tscn_y := chunks_tscn.instance()
		tscn_y.name = y
		tscn_x.add_child(tscn_y)
		var tscn_z := chunks_tscn.instance()
		tscn_z.name = z
		tscn_y.add_child(tscn_z)
		tscn.name = str(bpos3)
		adjustment_dire(tscn,block_name,dire)
		tscn_z.add_child(tscn)
		
func adjustment_dire(tscn:MeshInstance,block_name:String,dire:int) ->void:
	dire = Block.check_dire(block_name,dire)
	if dire == 1:
		tscn.rotation_degrees = Vector3(0,-90,0)
	if dire == 2:
		tscn.rotation_degrees = Vector3(0,-180,0)
	if dire == 3:
		tscn.rotation_degrees = Vector3(0,-270,0)
	if dire == 4:
		tscn.rotation_degrees = Vector3(90,0,0)
	if dire == 5:
		tscn.rotation_degrees = Vector3(-90,0,0)
func get_chunk_pos3(block_pos3:Vector3) -> Vector3:
	var chunk_pos3 = block_pos3/16
	chunk_pos3 = Vector3(int(floor(chunk_pos3.x)),int(floor(chunk_pos3.y)),int(floor(chunk_pos3.z)))
	return chunk_pos3

func place(block_pos3:Vector3,name_:String,dire:=0) -> bool:
	return $main.place(block_pos3,name_,dire)




##########################################
func rset1(key:String,data,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"rs",[key,data])
			else:
				rs([id,key,data])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"rs",[key,data])
func rset1_udp(key:String,data,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"rs",[key,data])
			else:
				rs([key,data])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"rs",[key,data])
remote func rs(args) -> void:
	var key = args[0]
	var data = args[1]
	$voxel_terrain[key] = data
#

##########################################
func rpc0(func_name:String,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r0",[func_name])
			else:
				r0([func_name])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r0",[func_name])
func rpc0_udp(func_name:String,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r0",[func_name])
			else:
				r0([func_name])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r0",[func_name])

remote func r0(args:Array) -> void:
	var func_name = args[0]
	$voxel_terrain.call(func_name)
#
func rpc1(func_name:String,args0,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r1",[func_name,args0])
			else:
				r1([func_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r1",[func_name,args0])
func rpc1_udp(func_name:String,args0,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r1",[func_name,args0])
			else:
				r1([func_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r1",[func_name,args0])
remote func r1(args:Array) -> void:
	var func_name = args[0]
	var args0 = args[1]
	$voxel_terrain.call(func_name,args0)
#
func rpc2(func_name:String,args0,args1,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r2",[func_name,args0,args1])
			else:
				r2([func_name,args0,args1])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r2",[func_name,args0,args1])
func rpc2_udp(func_name:String,args0,args1,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r2",[func_name,args0,args1])
			else:
				r2([func_name,args0,args1])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r2",[func_name,args0,args1])
remote func r2(args:Array) -> void:
	var func_name = args[0]
	var args0 = args[1]
	var args1 = args[2]
	$voxel_terrain.call(func_name,args0,args1)
##########################################




func get_dire_id(name_:String,x_:float,y_:float) -> int:
	var mode = Block[name_].dire
	if y_>120 && y_<150:
		if y_>135:
			y_ = 151
		else:
			y_ = 119
	if y_>30 && y_<60:
		if y_>45:
			y_ = 61
		else:
			y_ = 29
	if y_<-120 && y_>-150:
		if y_<-135:
			y_ = -151
		else:
			y_ = -119
	if y_>-30 && y_<-60:
		if y_<-45:
			y_ = -61
		else:
			y_ = -29
	if x_>120 && x_<150:
		if x_>135:
			x_ = 151
		else:
			x_ = 119
	if x_>30 && x_<60:
		if x_>45:
			x_ = 61
		else:
			x_ = 29
	if x_<-120 && x_>-150:
		if x_<-135:
			x_ = -151
		else:
			x_ = -119
	if x_<-30 && x_>-60:
		if x_<-45:
			x_ = -61
		else:
			x_ = -29
	if mode == 2:
		$pos3d.rotation_degrees.y = y_+90
		$pos3d.rotation_degrees.z = x_
	if mode == 1:
		$pos3d.rotation_degrees.y = y_+90
		$pos3d.rotation_degrees.z = 0
	if mode == 0:
		$pos3d.rotation_degrees.y = 0
		$pos3d.rotation_degrees.z = 0
	var tra = $pos3d.transform.orthonormalized()
	var orientation = tra.basis.get_orthogonal_index()

	return orientation
