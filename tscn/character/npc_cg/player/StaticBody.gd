extends Event


func _event(pos3:Vector3) -> bool:
	return $"../"._event(pos3)
	
	
func _select() -> void:
	$"../player/Skeleton/body".get_surface_material(0).next_pass = Config.grow
func _unselect() -> void:
	$"../player/Skeleton/body".get_surface_material(0).next_pass = null
