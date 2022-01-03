extends Particles


func _ready():
	one_shot = true
var time := 0.0
func _process(delta:float) -> void:
	time+=delta
	if time >= 0.6:
		queue_free()
