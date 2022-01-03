extends Spatial
var strength = 1
var dire_id = 1
var name_ = "default"
func _ready() ->void:
	$time.start()
	$time.connect("timeout",self,"_on_timeout")
	$particles.one_shot=true
	$particles.draw_pass_1.surface_set_material(0,Block.get(name_).particle)
func _on_timeout():
	queue_free()
