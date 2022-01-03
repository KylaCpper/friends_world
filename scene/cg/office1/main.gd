extends Node

var text = [
	"cg_office1",
	"cg_office2",
	"cg_office3",
	"cg_office4",
]

func _ready() ->void:
	Overall.bg_node._show()
	var env = preload("res://scene/cg/main.tres")
	$WorldEnvironment.environment = null
	yield(get_tree(),"idle_frame")
	$WorldEnvironment.environment = env
	
	$player_node/player.control=false
	$player_node/player.hide()
	$camera.current = false
	$camera.current = true
	$player_node/player_npc.play("keyboard")
	$keyboard.play()
	yield(Overall.bg_node,"end")
	
	Overall.msg_big_node._show(text[0],"player",1.0)
	yield(Overall.msg_big_node,"end")
	
	Overall.msg_big_node._show(text[1],"player",1.0)
	yield(Overall.msg_big_node,"end")
	$camera2.current = false
	$camera2.current = true
	$terrain_node/computer_tv.play()
	Overall.msg_big_node._show(text[2],"player",2.0)
	yield(Overall.msg_big_node,"end")
#	yield(get_tree().create_timer(4),"timeout")
	$camera.current = false
	$camera.current = true
	$keyboard.stop()
	$player_node/player_npc.play("dejected_down")
	$player_node/player_npc.ani_name = ""
	$AnimationPlayer.play("sigh")
	$sigh.play()
	Overall.msg_big_node._show(text[3],"player",2.0)
	yield(Overall.msg_big_node,"end")
	
#	yield(get_tree().create_timer(3.5),"timeout")
	$player_node/player_npc._free()
	$player_node/player.show()
	$player_node/player.control=true
	$player_node/player.update_camera()
	
