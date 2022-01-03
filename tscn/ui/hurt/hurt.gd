extends Node2D

func _ready() -> void:
	Overall.hurt_node = self
#	dead()
	$text/new_life.connect("pressed",self,"_on_new_life")
	$text/home.connect("pressed",self,"_on_home")
	
#	$text/new_life.connect("entered",self,"_on_entered")
#	$text/home.connect("entered",self,"_on_entered")
	hide()
	$bg.hide()
	$bg2.hide()
	$text.hide()
var dead := false
func _unhandled_input(event:InputEvent) -> void:
	if dead:
		if event.is_action_pressed("esc"):
			Overall.gui_node_node.esc_press()

func hurt(is_armor:=false) ->void:
	show()
	if is_armor:
		$bg.hide()
		$bg2.show()
	else:
		$bg.show()
		$bg2.hide()
	$text.hide()
	if Overall.player_node.camera_current == "camera_t":
		$bg.hide()
		$bg2.hide()
		return
	$AnimationPlayer.stop()
	$AnimationPlayer.play("start")
	
func _on_new_life() -> void:
	dead = false
	Overall.audio_node.play_ui("click")
	Overall.player_node._on_new_life()
	Overall.status_node._on_new_life()
	hide()
	Overall.gui_node_node.check_ui()
func dead() -> void:
	dead = true
	Overall.player_node._on_dead()
	show()
	$bg.show()
	$bg2.hide()
	$text.show()
	$AnimationPlayer.stop()
	$AnimationPlayer.play("show")
	Overall.gui_node_node.check_ui()
func _on_home() -> void:
	Overall.audio_node.play_ui("click")
	var pos3 = Overall.player_node.translation
	var rot = Overall.player_node.rotation_degrees
	Save.save_data.player.pos3 = [pos3.x,pos3.y,pos3.z]
	Save.save_data.player.rotation_degrees =  [rot.x,rot.y,rot.z]
	Save.save_save()
	Overall.init()
	Global.GoTo_Scene("res://scene/start/start.tscn")
	
func _on_entered() -> void:
	Overall.audio_node.play_ui("hover")
	
	
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
#	position.x += diff_size.x
#	position.y = window_size.y-Config.window_size.y
	
	$text.rect_position += diff_size
	$bg.rect_size = window_size
	$bg2.rect_size = window_size
