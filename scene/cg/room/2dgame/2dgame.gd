extends Node2D

signal end
var start := true
func _ready() -> void:
	pass
func start() -> void:
	start = true
	Function.set_mouse(Input.MOUSE_MODE_HIDDEN)
	yield(get_tree().create_timer(2),"timeout")
	$bgm.play()
func end() -> void:
	$bgm.stop()
	Function.set_mouse(Input.MOUSE_MODE_CAPTURED)
	emit_signal("end")
