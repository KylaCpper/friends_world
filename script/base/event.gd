extends StaticBody
#历史遗留
class_name Event

func _ready() -> void:
	pass

func _event(pos3:Vector3) -> bool:
	return true

func _select() -> void:
	$"../".material_override.next_pass = Config.grow
func _unselect() -> void:
	$"../".material_override.next_pass = null
