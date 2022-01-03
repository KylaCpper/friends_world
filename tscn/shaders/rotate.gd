extends TextureRect

var rotation = 0.0
var light = 1.0
signal end
func _ready() -> void:
	hide()
	self.material.set_shader_param("rotation", rotation)
	self.material.set_shader_param("brightness", light)
	set_process(false)
	get_tree().connect("screen_resized",self,"_on_screen")
	_on_screen()
func _on_screen() -> void:
	var window_size = get_viewport().size
	rect_size = window_size + Vector2(5,5)

func _show() -> void:
	show()
	rotation = 0.0
	set_process(true)
	

func _process(delta) -> void:
	rotation += delta
	var offset = rotation-3.0
	if offset < 0:
		offset = 0.0
	light = 1.0 * offset * offset +1.0
	self.material.set_shader_param("rotation", rotation*20)
	self.material.set_shader_param("brightness", light)
	if rotation > 5.5:
		set_process(false)
	
		emit_signal("end")

func _hide() -> void:
	rotation = 0.0
	light = 1.0
	self.material.set_shader_param("rotation", rotation)
	self.material.set_shader_param("brightness", light)
	hide()
