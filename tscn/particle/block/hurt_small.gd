extends Spatial
var strength = 1
var dire_id = 1 
var name_ = "default"
func _ready() ->void:
	if !name_:
		name_ = "default"
	$time.start()
	$time.connect("timeout",self,"_on_timeout")
	$particles.one_shot=true

	if dire_id == 1:
		rotation_degrees = Vector3(0,0,-90)
	if dire_id == 2:
		rotation_degrees = Vector3(-90,0,0)
	if dire_id == 3:
		rotation_degrees = Vector3(0,0,90)
	if dire_id == 4:
		rotation_degrees = Vector3(90,0,0)
	if dire_id == 5:
		rotation_degrees = Vector3()
	if dire_id == 6:
		rotation_degrees = Vector3(0,0,180)
		
	$particles.draw_pass_1.surface_set_material(0,Block.get(name_).particle)
func _on_timeout():
	queue_free()
