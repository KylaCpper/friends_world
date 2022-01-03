extends Node
 
var ws = null
var text = [
	"cg_main1",
	"cg_main2",
	"cg_main3",
	"cg_main4",
	"cg_main5",
]
var liquid_enviroment := preload("res://liquid.tres")
func _init() -> void:
	Overall.cg = false
func _ready():
	for key in Config.__script__:
		if Config.__script__[key].has_method("_ready"):
			Config.__script__[key]._ready()
#	print(Net.player_info,"---",Net.id)
	if Net.status:
		Net.check_player()

	
	Overall.bg_node._show()
	var cg = false
	if Net.is_master():
		if !Save.save_data.save:
#			cg = true
			Save.save_data.save = true
			Save.save_save()

	var env = preload("res://default_environment1.tres")
	$WorldEnvironment.environment = null
	set_process(false)
	yield(get_tree(),"idle_frame")
	$WorldEnvironment.environment = env
	set_process(true)
#	$WorldEnvironment.environment.fog_depth_begin=180
#	$WorldEnvironment.environment.fog_depth_end = 200
	yield(Overall.bg_node,"end")
	
	if cg:
		Overall.player_node.control=false
		Overall.msg_big_node._show(text[0],"player")
		yield(Overall.msg_big_node,"end")
		Overall.msg_big_node._show(text[1],"player")
		yield(Overall.msg_big_node,"end")
		Overall.msg_big_node._show(text[2],"player")
		yield(Overall.msg_big_node,"end")
		Overall.msg_big_node._show(text[3],"player")
		yield(Overall.msg_big_node,"end")
		Overall.msg_big_node._show(text[4],"player")
		yield(Overall.msg_big_node,"end")
		Overall.player_node.control=true
		
	
	
	return
	ws = WebSocketClient.new()
	ws.connect("connection_established", self, "_connection_established")
	ws.connect("connection_closed", self, "_connection_closed")
	ws.connect("connection_error", self, "_connection_error")
	
	var url = "ws://localhost:5000"
	print("Connecting to " + url)
	ws.connect_to_url(url)
	
func _connection_established(protocol):
	print("Connection established with protocol: ", protocol)
	
func _connection_closed():
	print("Connection closed")

func _connection_error():
	print("Connection error")
func queue_free() -> void:
	set_process(false)
	if Net.is_master():
		var pos3 = $player_node/player.translation
		var rot = $player_node/player.rotation_degrees
		Save.save_data.player.pos3 = [pos3.x,pos3.y,pos3.z]
		Save.save_data.player.rotation_degrees =  [rot.x,rot.y,rot.z]
		Save.save_save()
		Overall.terrain_main_node.save_modified_blocks()
	.queue_free()
#func _process(delta):
#	if ws.get_connection_status() == ws.CONNECTION_CONNECTING || ws.get_connection_status() == ws.CONNECTION_CONNECTED:
#		ws.poll()
##	if ws.get_peer(1).is_connected_to_host():
##		ws.get_peer(1).put_var("HI")
#		if ws.get_peer(1).get_available_packet_count() > 0 :
#
#			var test = ws.get_peer(1).get_var()
#			print(test,ws.get_peer(1).get_available_packet_count())
var view_dis := 0.0
func _process(delta:float) -> void:
	if view_dis > 160 : 
		set_process(false)
		view_dis = 160
#	liquid_enviroment.fog_depth_begin = 0+view_dis
#	liquid_enviroment.fog_depth_end = 40+view_dis
	$WorldEnvironment.environment.fog_depth_begin = 0+view_dis
	$WorldEnvironment.environment.fog_depth_end = 40+view_dis
	
	view_dis += 0.2
			
			
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		if Net.is_master():
			var pos3 = $player_node/player.translation
			var rot = $player_node/player.rotation_degrees
			Save.save_data.player.pos3 = [pos3.x,pos3.y,pos3.z]
			Save.save_data.player.rotation_degrees =  [rot.x,rot.y,rot.z]
			Save.save_save()
			Overall.terrain_main_node.save_modified_blocks()
