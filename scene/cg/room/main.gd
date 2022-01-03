extends Node

var text = [
	"cg_room1_1",
	"cg_room1_2",
	"cg_room1_3",
]
var text1 = [
	"cg_room2_1",
	"cg_room2_2",
	"cg_room2_3",
#	"如果我能穿越到古代，重新开始我的人生该多好啊，每天自由自在的生活"
]
func _ready() ->void:
	Overall.bg_node._show()
	
	$player_node/player.change_camera("camera_f")
	$player_node/player.control=false
	$player_node/player.hide()
	
	$camera.current = false
	$camera.current = true
	if Overall.cg_scene == 1:
		var env = preload("res://scene/cg/room/day.tres")
		$WorldEnvironment.environment = null
		yield(get_tree(),"idle_frame")
		$WorldEnvironment.environment = env
		yield(Overall.bg_node,"end")
#		yield(get_tree().create_timer(5),"timeout")
		$AnimationPlayer.play("start")
		yield($AnimationPlayer,"animation_finished")
		
		for data in text:
			Overall.msg_big_node._show(data,"player",1.0)
			yield(Overall.msg_big_node,"end")
			
		$AnimationPlayer.play("get_up")
		yield($AnimationPlayer,"animation_finished")
	else:
		
		
		$AnimationPlayer.play("start1")
		var env = preload("res://scene/cg/room/night.tres")
		$WorldEnvironment.environment = null
		yield(get_tree(),"idle_frame")
		$WorldEnvironment.environment = env
#		yield($AnimationPlayer,"animation_finished")
		$player_node/player.show()
		$player_node/player.control=false
		$player_node/player.update_camera()
		yield(Overall.bg_node,"end")
		
		
		for data in text1:
			Overall.msg_big_node._show(data,"player",1.0)
			yield(Overall.msg_big_node,"end")
		
	$player_node/player.show()
	$player_node/player.control=true
	$player_node/player.update_camera()
	

