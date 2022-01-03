extends Animation_Base_Client






func _ready() -> void:
	#0.7 1 1
	aabb = AABB(Vector3(-0.5, 0.0, -1.2), Vector3(1.0, 1.8, 2.4))
	pos2 += Vector2(move_r-randf()*move_r,move_r-randf()*move_r)
#	pos2 += Vector2(10,10)
	move_speed = 3.0
	move_speed_max = 3.0
	name_ = "wild_pig"
	hp = 10.0
	hp_max = 10.0
	$body/Skeleton/model.material_override = $body/Skeleton/model.material_override.duplicate()


