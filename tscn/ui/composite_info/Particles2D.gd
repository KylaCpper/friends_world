extends Particles2D

func _ready() -> void:
	yield(get_tree().create_timer(0.2),"timeout")
	emitting = true
	yield(get_tree().create_timer(1),"timeout")
	queue_free()
