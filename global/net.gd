extends Node
var peer :NetworkedMultiplayerENet
var status := false
var connecting := false
var server_err := false
var port := 0
var ip := "127.0.0.1"
var id := 1
var my_info={"name":"master","delty":0}
var player_info={
	
}
var status_ := false
func is_master() -> bool:
	if status: 
		if id != 1:
			return false
	return true
func init() -> void:
	status_ = false
	register_player = false
	set_process(false)
func _ready() ->void:
#	return
	peer = NetworkedMultiplayerENet.new()
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	set_process(false)
#关闭连接
func close_connect() ->void:
	get_world = false
	get_save = false
	connecting = false
	register_player = false
	peer.close_connection()
	for id in player_info.keys():
		player_info.erase(id)
	status = false
#创建服务器 端口 人数
func create_server(port:int,num:int) ->void:
	self.port=port
	var ips := IP.get_local_addresses()
#	if Overall.phone:
#	print(str(IP.get_local_addresses()))
#	Overall.gui_node_node.asd("Label3",str(IP.get_local_addresses()))
	peer.create_server(int(port), int(num))
	get_tree().set_network_peer(peer)
	while (1):
		if get_tree().is_network_server():
			status = true
			set_process(true)
			print("create server: ",str(ips),":",port)
			if Overall.cmd_node:
				for ip in ips:
					Overall.cmd_node.add_text("ip: "+ip)
				Overall.cmd_node.add_text("port: "+str(port))
				
			player_info[1] = my_info
#			Function.msg_group("cmd","add_text","ip: "+ip+" port: "+str(port))
			return
	Overall.player_node.update_net()
#连接服务器 ip 端口
func connect_server(ip:String,port:int) ->void:
	connecting = true
	self.port=port
	self.ip=ip
	peer.create_client(ip,port)
	get_tree().set_network_peer(null)
	get_tree().set_network_peer(peer)
#客户端进来
func _player_connected(id:int) ->void:
	print("client in",id)
#客户端断开
func _player_disconnected(id:int) ->void:
	print("client disconnect",id)
	disconnect_player(id)
#连接服务器成功
func _connected_ok() ->void:
	connecting = false
	print("connect success")
	status = true
	id=get_tree().get_network_unique_id()
	
	
	rpc_id(1,"give_data",id,my_info)
#
func _server_disconnected() ->void:
	print("server disconnect")
	close_connect()
	server_err = true
	Global.GoTo_Scene("res://scene/start/main.tscn")
	Overall.init()
#
func _connected_fail() ->void:
	Function.msg_group("loading","_on_fail_show","connect_fail_ui")
	print("connect err")
	close_connect()
#	Function.msg_group("msg","_on_show","disconnect server")
	status = false
	pass 

func check_player() -> void:
	rpc_id(1,"register_player", id, my_info)

master func register_player(id:int, info:Dictionary) ->void:
	
	player_info[id] = info
	player_info[self.id] = my_info
	rpc("register_player_client",player_info)
	Function.msg_group("player_node","check_player")
	Function.msg_group("terrain_node","check_crack")
#	if status:
#		# 发送数据给新玩家
#		if id!=1:
#			rpc_id(id, "register_player", 1, my_info)
#	# 发送数据给全体玩家
#		for peer_id in player_info:
#			for peer_id_ in player_info: 
#				if peer_id!=1:
#					rpc_id(peer_id, "register_player", peer_id_, player_info[peer_id_])
var register_player := false
puppet func register_player_client(player_info:Dictionary) -> void:
	register_player = true
	self.player_info = player_info
	Function.msg_group("player_node","check_player")
	Function.msg_group("terrain_node","check_crack")
	


remote func disconnect_player(id:int) ->void:
	if !id in player_info:return
	player_info.erase(id)
	Function.msg_group(str(id),"queue_free")
	if get_tree().is_network_server():
		#发送掉线的客户端id所有客户端
		for peer_id in player_info:
			rpc_id(id, "disconnect_player", peer_id)
#server
master func give_data(id:int,data:Dictionary) -> void:
	for key in player_info:
		if data.name == player_info[key].name:
			rpc_id(id,"connect_err_name")
#			peer.disconnect_peer(id,true)
			return
	print(player_info,"--",data)
	rpc_id(id, "get_world", Save.world,Overall.entity_node_node.get_entitys_list())
	Save.new_player(data.name)
	var save_data = Save.save_data.duplicate(true)
	save_data.players["master"] = save_data.player
	save_data.player = save_data.players[data.name]
	rpc_id(id, "get_save", save_data)
	
	
puppet func connect_err_name() -> void:
	close_connect()
	Function.msg_group("loading","connect_err_name")
	
var get_world := false
var get_save := false
puppet func get_world(data:Dictionary,entity_node_data:Array) -> void:
	get_world = true
#	Save.check_world(data)
	var world = data
	Entity.entity_node_data = entity_node_data
#	world["map"] = {}
#	for key in data["map"]:
#		var key_ = str2var(key)
#		world["map"][key_] = {}
#		for key1 in data["map"][key]:
#			world["map"][key_][str2var(key1)] = data["map"][key][key1]
#	world["box"] = {}
#	for key in data["box"]:
#		world["box"][str2var(key)] = data["box"][key]
#	world["other"] = data["other"]
	Save.world = world
	Terrain.map_queue = Save.world.map
	check_done()

puppet func get_save(data:Dictionary) -> void:
	get_save = true
#	Save.check_data(data)
	Save.save_data = data
	Save.save_data.players[Net.my_info.name] = Save.save_data.player
	Terrain.seed_num = data.seed_num
	Terrain.init()
	check_done()
func check_done() -> void:
	status_ = true
	if get_world && get_save:
#		Function.msg_group("loading")
		Global.GoTo_Scene("res://scene/main/main.tscn")
		
var time := 0.0
func _process(delta:float) -> void:
	time += delta
	if time >= 2.0:
		time = 0.0
		get_delty()
		rpc("get_delty_client",player_info)
var c_time := 0 
func get_delty() -> void:
	c_time = OS.get_ticks_msec()
	rpc("_pack")

puppet func get_delty_client(data:Dictionary) -> void:
	for id in player_info:
		if id in data:
			if id == 1:
				player_info[id]["delty"]=data[Net.id]["delty"]
			else:
				player_info[id]["delty"]=data[id]["delty"]
master func get_pack(id:int) -> void:
	var delty = OS.get_ticks_msec() - c_time
	if id in player_info:
		player_info[id]["delty"] = delty
		
puppet func _pack() -> void:
	rpc_id(1,"get_pack",id)
