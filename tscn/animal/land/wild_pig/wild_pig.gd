extends Animation_Base






func _ready() -> void:
	#0.7 1 1
	aabb = AABB(Vector3(-0.5, 0.0, -1.2), Vector3(1.0, 1.8, 2.4))
	pos2 += Vector2(move_r-randf()*move_r,move_r-randf()*move_r)
#	pos2 += Vector2(10,10)
	move_speed = 3.0
	idle_speed = 1.5
	liquid_speed = 1.5
	liquid_run_speed = 3.0
	walk_speed = 3.0
	run_speed = 6.0
	
	atk_dis = 2.0
	atk_move_speed = 0.2
	stop_dis = 1.0
	
	name_ = "wild_pig"
	hp = 10.0
	hp_max = 10.0
	find_dis = 5.0
	$body/Skeleton/model.material_override = $body/Skeleton/model.material_override.duplicate()
	check_state()


func _drop() -> void:
	Overall.terrain_node_node.drop_force(translation+Vector3(0.5-randf(),0.5-randf(),0.5-randf()),{"name":"wild_pig_meat","num":randi()%3+1},Vector3(0,4.5+randf(),0))
