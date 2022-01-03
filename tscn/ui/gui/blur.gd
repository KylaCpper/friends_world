extends Node2D


func set_val(val:float) -> void:
	$blur.material.set_shader_param("blur_amount", val)
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$blur._on_screen(window_size,diff_size)

	
