extends Event
var stop := false

func _event(pos3:Vector3) -> bool:
	return $"../"._event(pos3)
	
	
func _select() -> void:
	if stop:return
	$"../player/Skeleton/body".material_override.next_pass = Config.grow
func _unselect() -> void:
	$"../player/Skeleton/body".material_override.next_pass = null
