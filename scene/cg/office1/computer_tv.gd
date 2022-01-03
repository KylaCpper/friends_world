extends MeshInstance

func _ready() -> void:
	var viewport = $Viewport
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

#	var material = $msg1.material_override.duplicate()
	self.material_override.albedo_texture = viewport.get_texture()
#	$msg1.material_override = material
#	$msg2.material_override = material

func play() -> void:
	$Tween.interpolate_property($Viewport/Label,"percent_visible",0,1,3)
	$Tween.start()
