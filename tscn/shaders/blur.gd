extends TextureRect

func _ready() -> void:
	pass
func set_val(val:float) -> void:
	material.set_shader_param("blur_amount", val)
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	rect_size = window_size + Vector2(5,5)
	$bg.rect_size = window_size + Vector2(5,5)
	
