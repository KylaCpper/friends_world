extends Node2D

func _ready() -> void:
	$blur.show()
	$bg.show()
	$cancel.connect("pressed",self,"_on_cancel")
	$create_server.connect("pressed",self,"_on_create_server")
	$set.connect("pressed",self,"_on_set")
	$home.connect("pressed",self,"_on_home")
	
	$cancel.connect("mouse_entered",self,"_on_enter")
	$create_server.connect("mouse_entered",self,"_on_enter")
	$set.connect("mouse_entered",self,"_on_enter")
	$home.connect("mouse_entered",self,"_on_enter")
	
	$jump.connect("pressed",self,"_on_jump")
	$jump.connect("mouse_entered",self,"_on_enter")
func show() -> void:
	if Overall.cg:
		$jump.show()
	else:
		$jump.hide()
	.show()
	

func _on_cancel() -> void:
	Overall.audio_node.play_ui("click")
	Overall.gui_node_node.esc_press()
func _on_create_server() -> void:
	Overall.audio_node.play_ui("click")
	if !Net.status && !Net.connecting:
		Net.create_server(45536,4)
		Overall.gui_node_node.esc_press()
	else:
		Overall.center_node.add_msg_pop(tr("err_net1_ui"))
func _on_set() -> void:
	Overall.audio_node.play_ui("click")
	$set_page.show()
func _on_home() -> void:
	if Net.status:
		Net.close_connect()
	Overall.audio_node.play_ui("click")
	var pos3 = Overall.player_node.translation
	var rot = Overall.player_node.rotation_degrees
	Save.save_data.player.pos3 = [pos3.x,pos3.y,pos3.z]
	Save.save_data.player.rotation_degrees =  [rot.x,rot.y,rot.z]
	Save.save_save()
	Overall.init()
	$"../".free_world()
	Global.GoTo_Scene("res://scene/start/start.tscn")

func _on_jump() -> void:
	Overall.cg_scene += 1
	$"../".free_world()
	Global.GoTo_Scene("res://scene/main/main.tscn")
func _on_enter() -> void:
	Overall.audio_node.play_ui("hover")
	
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$blur._on_screen(window_size,diff_size)
	$bg.rect_size = window_size + Vector2(5,5)
	
	$cancel.rect_position.x = 150*window_size.x/Config.window_size.x
	$create_server.rect_position.x = $cancel.rect_position.x
	$set.rect_position.x = $cancel.rect_position.x
	$home.rect_position.x = $cancel.rect_position.x
	$jump.rect_position.x = window_size.x - $jump.rect_size.x - 100
	
	var be = 80
	$cancel.rect_position.y = window_size.y -150 - be*3
	$create_server.rect_position.y = window_size.y -150 - be*2
	$set.rect_position.y = window_size.y - 150 - be
	$home.rect_position.y = window_size.y -150
	$jump.rect_position.y = window_size.y -100
	
	$set_page._on_screen(window_size,diff_size)
