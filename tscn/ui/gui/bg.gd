extends Panel

signal end

func _ready() -> void:

	pass
func _show() -> void:
	$AnimationPlayer.play("start")
	yield($AnimationPlayer,"animation_finished")
	emit_signal("end")

func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	rect_size = window_size + Vector2(5,5)
