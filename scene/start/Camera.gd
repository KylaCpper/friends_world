extends Camera

func _ready() -> void:
	pass
func _process(delta:float) -> void:
	translation.z += 0.1
	var pos3 = translation
	pos3.y = 0
	$"../VoxelViewer".translation = pos3
