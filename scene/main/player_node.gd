extends Node

func _ready() -> void:
	add_to_group("player_node")
	Overall.player_node_node = self
var player_cliend_tscn := preload("res://tscn/character/player_client/player_client.tscn")

func check_player() -> void:
	for id in Net.player_info:
		if id != Net.id:
			if !has_node(str(id)):
				var tscn = player_cliend_tscn.instance()
				tscn.name = str(id)
				var data 
				if Net.player_info[id].name in Save.save_data.players:
					data = Save.save_data.players[Net.player_info[id].name]
				else:
					data = Save.save_data.player
				tscn.translation = Vector3(data.pos3[0],data.pos3[1],data.pos3[2])
				tscn.rotation_degrees = Vector3(data.rot[0],data.rot[1],data.rot[2])
				add_child(tscn)










##########################################
func rset1(key:String,data,sync_:=false) -> void:
	var pid = Net.id
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"rs",[pid,key,data])
			else:
				rs([id,key,data])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"rs",[pid,key,data])
func rset1_udp(key:String,data,sync_:=false) -> void:
	var pid = Net.id
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"rs",[pid,key,data])
			else:
				rs([pid,key,data])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"rs",[pid,key,data])
remote func rs(args) -> void:
	var id = args[0]
	var key = args[1]
	var data = args[2]
	if has_node(str(id)):
		var player = get_node(str(id))
		player[key] = data
#

##########################################
func rpc0(func_name:String,sync_:=false) -> void:
	var pid = Net.id
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r0",[pid,func_name])
			else:
				r0([pid,func_name])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r0",[pid,func_name])
func rpc0_udp(func_name:String,sync_:=false) -> void:
	var pid = Net.id
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r0",[pid,func_name])
			else:
				r0([pid,func_name])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r0",[pid,func_name])
remote func r0(args:Array) -> void:
	var id = args[0]
	var func_name = args[1]
	if has_node(str(id)):
		var player = get_node(str(id))
		player.call(func_name)
#
func rpc1(func_name:String,args0,sync_:=false) -> void:
	var pid = Net.id
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r1",[pid,func_name,args0])
			else:
				r1([id,func_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r1",[pid,func_name,args0])
func rpc1_udp(func_name:String,args0,sync_:=false) -> void:
	var pid = Net.id
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r1",[pid,func_name,args0])
			else:
				r1([id,func_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r1",[pid,func_name,args0])
remote func r1(args:Array) -> void:
	var id = args[0]
	var func_name = args[1]
	var args0 = args[2]
	if has_node(str(id)):
		var player = get_node(str(id))
		player.call(func_name,args0)
#		player.func_name(args0)
#
func rpc2(func_name:String,args0,args1,sync_:=false) -> void:
	var pid = Net.id
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r2",[pid,func_name,args0,args1])
			else:
				r2([id,func_name,args0,args1])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r2",[pid,func_name,args0,args1])
func rpc2_udp(func_name:String,args0,args1,sync_:=false) -> void:
	var pid = Net.id
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r2",[pid,func_name,args0,args1])
			else:
				r2([id,func_name,args0,args1])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r2",[pid,func_name,args0,args1])
remote func r2(args:Array) -> void:
	var id = args[0]
	var func_name = args[1]
	var args0 = args[2]
	var args1 = args[3]
	if has_node(str(id)):
		var player = get_node(str(id))
#		player.func_name(args0,args1)
		player.call(func_name,args0,args1)
##########################################
#
func rpc1_id(id:int,func_name:String,args0,sync_:=false) -> void:
	if id in Net.player_info:
		rpc_id(id,"r1i",[Net.id,func_name,args0])
func rpc1_udp_id(id:int,func_name:String,args0) -> void:
	if id in Net.player_info:
		rpc_unreliable_id(id,"r1i",[Net.id,func_name,args0])
remote func r1i(args:Array) -> void:
	var id = args[0]
	var func_name = args[1]
	var args0 = args[2]
	if has_node(str(id)):
		var player = get_node(str(id))
		player.call(func_name,args0)

#
func rpc1_id_self(id:int,func_name:String,args0) -> void:
	if id in Net.player_info:
		rpc_id(id,"r1is",[func_name,args0])
func rpc1_udp_id_self(id:int,func_name:String,args0) -> void:
	if id in Net.player_info:
		rpc_unreliable_id(id,"r1is",[func_name,args0])
remote func r1is(args:Array) -> void:
	var func_name = args[0]
	var args0 = args[1]
	self.call(func_name,args0)
#
func rpc1_player_self(id:int,func_name:String,args0) -> void:
	if id in Net.player_info:
		rpc_id(id,"r1ps",[func_name,args0])
func rpc1_udp_player_self(id:int,func_name:String,args0) -> void:
	if id in Net.player_info:
		rpc_unreliable_id(id,"r1ps",[func_name,args0])
remote func r1ps(args:Array) -> void:
	var func_name = args[0]
	var args0 = args[1]
	Overall.player_node.call(func_name,args0)
