extends Node2D


func _ready():
	Function.set_mouse(Input.MOUSE_MODE_VISIBLE)
	yield(get_tree().create_timer(7),"timeout")
	$AnimationPlayer.play("start")
