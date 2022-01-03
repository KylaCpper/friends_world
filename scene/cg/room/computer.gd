extends Event
var stop := false
func _ready() -> void:
	pass
var text = [
	"cg_room_computer_stop",
	"cg_room_computer1",
	"cg_room_computer2",
	"cg_room_computer3",
	"cg_room_computer4",
	"cg_room_computer5",
	"cg_room_computer6",
]
func _event(pos3:Vector3) -> bool:
	if Overall.cg_scene == 1:
		Overall.player_node.control = false
		Overall.msg_big_node._show(text[0],"player")
		yield(Overall.msg_big_node,"end")
		Overall.player_node.control = true
		return true
	Overall.player_node.change_camera("camera_t")
	$camera.current = false
	$camera.current = true
	Overall.player_node.control = false
	stop = true
	_unselect()
	yield(get_tree().create_timer(0.3),"timeout")
	$AnimationPlayer.play("start")
	yield($AnimationPlayer,"animation_finished")
	Overall.player_node.update_ani("sit","no_jump")
	
	Overall.msg_big_node._show(text[1],"player")
	yield(Overall.msg_big_node,"end")
	$screen.start()
	Overall.player_node.update_ani("keyboard","no_jump")
	$keyboard.play()
	Overall.msg_big_node._show(text[2],"player")
	yield(Overall.msg_big_node,"end")
	$keyboard.stop()
	$camera2.current = false
	$camera2.current = true
	$"../../../bgm".stop()
	$"screen/Viewport/2dgame".start()
	yield($"screen/Viewport/2dgame","end")
	$camera.current = false
	$camera.current = true
	Overall.msg_big_node._show(text[3],"player")
	yield(Overall.msg_big_node,"end")
	Overall.msg_big_node._show(text[4],"player")
	yield(Overall.msg_big_node,"end")
	$"../".material_override.flags_transparent = false
	Overall.audio_node.play("tv_light")
	Overall.msg_big_node._show(text[5],"player")
	yield(Overall.msg_big_node,"end")
	Overall.audio_node.stop("tv_light")
	Overall.audio_node.play("time_machine",4.0)
	$AnimationPlayer.play("rotate")
	yield(get_tree().create_timer(0.1),"timeout")
	$"../../../rotate"._show()
	Overall.msg_big_node._show(text[6],"player")
	
	yield(get_tree().create_timer(3.3),"timeout")
	Overall.audio_node.play("shuttle")
	
	yield($"../../../rotate","end")
	Overall.cg_scene+=1
	Global.GoTo_Scene("res://scene/main/main.tscn")
	return true
func _select() -> void:
	if stop:return
	$"../".material_override.next_pass = Config.grow
	
	
	
	

func _input(event) -> void:
	$"screen/Viewport/2dgame/map"._input(event)
	$"screen/Viewport/2dgame/bar"._input(event)
