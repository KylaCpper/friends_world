extends MeshInstance


func _ready() -> void:
	set_process(false)
func start(e:float) -> void:
	energy = e
	set_process(true)
func stop() -> void:
	energy = 0.0
	set_process(false)
var energy = 0.0

func _process(delta:float) -> void:
	$fan.rotation_degrees.z += energy*delta*300
		
