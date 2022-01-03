extends Event
var open := false

func _ready() -> void:
	$"../Tween".connect("tween_all_completed",self,"_on_finished")

func _event(pos3:Vector3) -> bool:
	open = !open
	var tween := $"../Tween"
	if open:
		tween.interpolate_property($"../../", "rotation_degrees",
			$"../../".rotation_degrees, Vector3(0,-90,0), 2,
			Tween.TRANS_QUINT, Tween.EASE_OUT )
		tween.start()
	else:
		tween.interpolate_property($"../../", "rotation_degrees",
			$"../../".rotation_degrees, Vector3(0,0,0), 2,
			Tween.TRANS_QUINT, Tween.EASE_OUT )
		tween.start()
	
	return true
func _on_finished() -> void:
	$"../Tween".remove_all()

