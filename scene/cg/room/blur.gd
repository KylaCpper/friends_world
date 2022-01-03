extends TextureRect
func _ready() -> void:
#	$"../HSlider".connect("value_changed",self,"_show")
	hide()
	self.material.set_shader_param("blur_amount", 0.0)
	_on_screen()
	get_tree().connect("screen_resized",self,"_on_screen")

func _show(num:float) -> void:
	show()
	self.material.set_shader_param("blur_amount", num)
	
func _on_screen() -> void:
	var window_size = get_viewport().size
	Config.window_size_current = window_size
	if !Config.ADAPTATION:
		window_size = Vector2(1024,600)
	var be = window_size/Vector2(1024,600)
	rect_scale = be
