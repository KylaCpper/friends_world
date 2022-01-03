extends Node

var talk := false

func _ready() -> void:
	$AnimationPlayer.play("sit_boss")



var text = [
	["boss","cg_boss1","talk"],
	["boss","cg_boss2","talk"],
	["player","cg_boss3"],
	["boss","cg_boss4","talk"],
	["player","cg_boss5"],
	["player","cg_boss6"],
	["boss","cg_boss7","talk"],
	["player","cg_boss8"],
	["boss","cg_boss9","talk_big"],
	["boss","cg_boss10","talk_big"],
	["player","cg_boss11"],
	["boss","cg_boss12","talk"],
]
var text__ = [
	"cg_boss_1",
]
func _event(pos3:Vector3) -> bool:
	
	self.rotation_degrees.y = Overall.player_node.rotation_degrees.y-180
	$StaticBody.stop = true
	$StaticBody._unselect()
	Overall.player_node.control = false
	$AnimationPlayer.play("default")
	if !talk:
		talk = true
		for data in text:
			if data[0] == "boss":
				if data.size() == 3:
					$AnimationPlayer.play(data[2])
				$msg._show(data[1])
				Overall.msg_big_node._show(data[1],"boss")
				yield(Overall.msg_big_node,"end")
			if data[0] == "player":
				if data[1] == "。。。。":
					Overall.msg_big_node._show(data[1],"player",1.0,false)
				else:
					Overall.msg_big_node._show(data[1],"player")
				yield(Overall.msg_big_node,"end")
	else:
		$msg._show(text__[0])
		$AnimationPlayer.play("talk")
		Overall.msg_big_node._show(text__[0],"boss")
		yield(Overall.msg_big_node,"end")
		
	$"../door_out/door_out".done = true
	$StaticBody.stop = false
	self.rotation_degrees.y = -90
	$AnimationPlayer.play("sit_boss")
	Overall.player_node.control = true
	return true
	
