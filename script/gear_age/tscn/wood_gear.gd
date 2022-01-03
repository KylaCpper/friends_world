extends MeshInstance


func _ready() -> void:
#	rotation_degrees.y += 90
	translation.y -= 0.5
#	translation.x -= 0.5
	set_process(false)
	
func start(e:float,a:bool) -> void:
	energy = e
	anti = a
	set_process(true)
func stop() -> void:
	energy = 0.0
	set_process(false)
var energy := 0.0
var anti := false
func _process(delta:float) -> void:
	if anti:
		rotation_degrees.y -= energy*delta*300
	else:
		rotation_degrees.y += energy*delta*300
		
