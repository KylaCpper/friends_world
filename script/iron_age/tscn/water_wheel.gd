extends MeshInstance


func _ready() -> void:
	rotation_degrees.y += 90
	translation.y += 0.5
	translation.x -= 0.5
	set_process(false)
	
func start(e:float) -> void:
	energy = e
	set_process(true)
func stop() -> void:
	energy = 0.0
	set_process(false)
var energy = 0.0

func _process(delta:float) -> void:
	$fan.rotation_degrees.x += energy*delta*60
		
