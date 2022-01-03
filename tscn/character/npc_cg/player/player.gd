extends Node

var ani_name := ""

func _ready() -> void:
	$AnimationPlayer.connect("animation_finished",self,"_on_finished")


func play(name_:String) ->void:
	ani_name = name_
	$AnimationPlayer.play(name_)
	
func _on_finished(name_:String) ->void:
	if ani_name:
		$AnimationPlayer.play(ani_name)

func _free() -> void:
	queue_free()
