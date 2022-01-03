extends MeshInstance

func _ready() -> void:
	pass
func start() -> void:
	var viewport = $Viewport
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	material_override.albedo_color = Color(1,1,1) 
	self.material_override.albedo_texture = viewport.get_texture()


