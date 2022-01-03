extends KinematicBody
class_name Animation_Base

onready var ani_tree := $AnimationTree
onready var pos2 := Vector2(translation.x,translation.z)
var box := VoxelBoxMover.new()
var aabb := AABB(Vector3(-0.4, -0.2, -0.4), Vector3(0.8, 1.8, 0.8))
var vec := Vector3()
var tool_loss = 5.0
var move_speed := 4.0
var walk_speed := 4.0
var run_speed := 10.0
var idle_speed := 2.0
var liquid_speed := 2.0
var liquid_run_speed := 4.0
var gravity := 0.7
var jump_speed := 10.0
var is_jump := false
var name_ := "wild_pig"
var id := 1
var hp := 10.0
var hp_max := 10.0
var state = "standby"
var idle_time := 0.0
var idle_time_max := 5.0
var eat_time := 0.0
var eat_time_max := 3.0
var eat_end_time := 0.0
var eat_end_time_max := 0.1
var atk_time := 0.0
var atk_time_max := 0.5
var check_rot_time := 0.0
var check_rot_time_max := 0.8

var move_time := 0.0
var move_time_max := 3.0
var find_dis := 5.0
var move_r := 10.0 

var mode := "idle"

var is_wall := false
var wall_time := 0.0
var wall_time_max := 0.1

var rot_time := 0.0
var rot_time_max := 1.5

var hurt_time := 0.2
var is_hurt := false
var _time_ := 0.0
var _time_max_ := 0.1
var free_time := 60.0

var run_dis_max := 30
var hatred_dis_max := 30

var in_entity := false
var vec_offset := Vector3(0,0,0)

#pos3 vec3 bodyy walk run bonex boney
var shadow := [Vector3(0,0,0),Vector3(0,0,0),0,0,0,0,0]

var atk := 1.0


func _ready() ->void:
	box.set_collision_mask(CollisionGroup.VOXEL_LAYER.animal)
	CollisionGroup.collision(self,"animal")


func update() -> void:
	vec_offset = Vector3(0,0,0)
	in_entity = false
	check_liquid()
var in_liquid := false
func check_liquid() -> void:
	if Overall.terrain_main_node.is_liquid(translation+Vector3(0,0.5,0)):
		in_liquid = true
	else:
		in_liquid = false
		liquid_time = 0.0
var _free_time_ := 0.0
func _process(delta:float) -> void:
	if state == "dead":
		vec.x = 0 
		vec.z = 0
		vec.y -= gravity
		if is_on_floor():
			is_jump = false
			vec.y = 0.0
		move(delta)
		_free_time_ += delta
		if _free_time_ > free_time:
#			_free_time_ = 0.0
			queue_free()
		return
		
	_time_ += delta
	if _time_ > _time_max_:
		_time_ = 0.0
		update()
		check_dis()
		Overall.entity_node_node.rset1_udp(name,"state",state)
		
		
	
	if state == "standby":return
	rot_time += delta
	if rot_time > rot_time_max:
		rot_time = 0.0
		if mode == "idle":
			if randi()%100 > 49:
				change_dire(randf()*60)
	
	if mode == "idle":
		idle_mode(delta)
	if mode == "eat":
		eat_mode(delta)
	if mode == "eat_nofood":
		eat_nofood_mode(delta)
	if mode == "attract":
		attract_mode(delta)
	if mode == "notice":
		notice_mode(delta)
	if mode == "atk":
		atk_mode(delta)
	if mode == "run":
		run_mode(delta)
		
	vec.y -= gravity
	if is_on_floor() && !in_liquid:
		is_jump = false
		vec.y = 0.0

	if is_wall:
		wall_time += delta
		if wall_time > wall_time_max:
			wall_time = 0.0
			is_wall = false
	
	shadow[0] = translation
	shadow[1] = vec
	shadow[2] = rotation_degrees.y
	shadow[5] = $body/Skeleton.head_vec3.x
	shadow[6] = $body/Skeleton.head_vec3.y
	Overall.entity_node_node.rset1_udp(name,"shadow",shadow)
	var dis = move(delta)
	if dis < move_speed*0.8:
		if is_wall:return
		is_wall = true
		if mode == "atk":
			var be = 0.3
			if atk_move_speed <= 0.3:
				be = atk_move_speed-0.1
			if dis < move_speed*be:
				jump(delta)
			return
		if dis < move_speed*0.3:
			jump(delta)
		change_dire(10*(move_speed - dis))
		
	

func move(delta:float) -> float:
	var vec3_ = box.get_motion(get_translation(), get_global_transform().basis.xform(vec*delta), aabb,Overall.terrain_main_node)
	var vec3_be = vec3_/delta
#	var dis = abs(Vector2(0,0).distance_to(Vector2(vec3_be.x,vec3_be.z)))
	if in_entity && state != "dead":
		vec3_ = box.get_motion(translation, vec_offset*delta, aabb,Overall.terrain_main_node)
		move_and_slide(vec3_/delta,Vector3(0,1,0))
	var dis = move_and_slide(vec3_be,Vector3(0,1,0)).distance_to(Vector3(0,0,0))
	if vec.x != 0.0 || vec.z != 0.0:
		return dis
	else:
		return move_speed


func is_on_floor() -> bool:
	if !Overall.cg:
		var pos3_ = box.get_motion(get_translation(), Vector3(0,-1,0), aabb,Overall.terrain_main_node)
		if abs(pos3_.y) < 0.01:
			return true
	return .is_on_floor()
	
func change_dire(rot:float) -> void:
	wall_time = 0.0
	if randi() % 10 > 4:
		rot = -rot
	rot/=15
	var head_rot = -rot*0.1
	if head_rot > 0:
		head_rot += 0.1
	else:
		head_rot -= 0.1
	$body/Skeleton.rot_head_y(head_rot)
	for i in range(15):
		yield(get_tree(),"idle_frame")
		rotation_degrees.y += rot
func jump(delta:float) -> void:
	if !is_jump:
		vec.y = jump_speed
		is_jump = true
		move(delta)
	
func get_name_(vec:Vector3) -> String:
	return name_


func change_mode(mode_:String) -> void:
	mode = mode_
func check_state() -> void:
	check_dis()
var notice_obj = null 
func check_dis() -> void:
	var player_node = Overall.player_node_node
	var _in200 := false
	
	for player in player_node.get_children():
		var dis = translation.distance_to(player.translation)
		if dis < Config.view_dis:
			_in200 = true
			if state == "standby":state = "default"
			if !in_liquid:
				if mode != "atk" && mode != "run" && mode != "eat" && mode != "eat_nofood":
					if dis < find_dis:
						if randi()%50 == 0:
							if state == "eating":
								ani_tree.update_ani("eat_end")
								Overall.entity_node_node.rpc1(name,"update_ani","eat_end")
							notice_obj = player
							if mode != "notice":
								$body/Skeleton.rot_head_y(0.0)
							change_mode("notice")
							return
					if randi()%200 == 0:
						mode = "eat_nofood"
						if state == "eating":
							ani_tree.update_ani("eat_end")
							Overall.entity_node_node.rpc1(name,"update_ani","eat_end")
						eating = false
						eat_nofood_time = 0.0
						eat_nofood_time_max = randi()%3+2
						return
	if _in200 == false:state = "standby"
var hit_num := 0
func _hurt(atk:float) -> bool:
	if state != "dead":
		Overall.bar_node.sub_hp(tool_loss)
		hurt([atk,Net.id])
		Overall.entity_node_node.rpc1(name,"hurt",[atk,Net.id])
	else:
		_dead_hurt()
	return true
func _dead_hurt() -> void:
		Terrain.create_particles(translation,"flesh",3.0,4,4.0+randf())
		_drop()
		hit_num += 1
		if hit_num == 3:
			queue_free()
func _drop() -> void:
	pass
master func hurt(args:Array) -> void:
	if state == "dead":return
	if is_hurt:return
	if eating:
		ani_tree.update_ani("eat_end")
		Overall.entity_node_node.rpc1(name,"update_ani","eat_end")
		eating = false
	if ani_tree["parameters/atk/active"]:
		ani_tree["parameters/atk/active"] = false
	if mode == "run" || mode == "atk":
		mode = "atk"
	else:
		mode = "run"
	var atk = args[0]
	atk_player_id = args[1]
	if Net.id == atk_player_id:
		atk_player = Overall.player_node
	else:
		var player_node = Overall.player_node_node
		if player_node.has_node(str(atk_player_id)):
			atk_player = player_node.get_node(str(atk_player_id))
	init_run_pos2()
	is_hurt = true
	ani_tree.play("hurt")
	yield_hurt()
	hurt_ani()
	hp -= atk
	if hp <= 0.0:
		dead()
var atk_player_id := 0
var atk_player = null
func hurt_ani() -> void:
	if atk_player:
		var vf = translation - atk_player.translation
		vf = Vector2(vf.x,vf.y).normalized()*3
		for i in range(15):
			yield(get_tree(),"idle_frame")
			move_and_slide(Vector3(vf.x,6,vf.y),Vector3(0,1,0))
func yield_hurt() -> void:
	yield(get_tree().create_timer(hurt_time),"timeout")
	is_hurt = false
func dead() -> void:
	if state == "dead":return
	state = "dead"
	Overall.entity_node_node.rpc0(name,"dead")
	ani_tree.dead()


var liquid_time := 0.0
var liquid_up_max := 7.0
func liquid_move(delta:float) -> void:
	move_speed = liquid_speed
	if liquid_time < liquid_up_max:
		liquid_time += delta
#	if liquid_time > liquid_time_max:
#		liquid_time = 0.0
#		liquid_up = !liquid_up
#	if liquid_up:
#		vec.y = 10
#
#	else:
#		vec.y = -10
	if vec.y < 0:
		vec.y /= 2
	vec.y += 1
	
#	move(delta)


func idle_mode(delta:float) -> void:
	move_speed = idle_speed
	move_time += delta
	var vec2 = Vector2(translation.x,translation.z)
	
	idle_time += delta
	if in_liquid:
		liquid_move(delta)
	if move_time < move_time_max:
		idle_time = 0.0
		state = "walk"
		var vec2_ = (pos2 - vec2).normalized() * move_speed
		vec.z = move_speed
		var walk_pro = move_speed/walk_speed
		ani_tree.walk(walk_pro)
		shadow[3] = walk_pro
		shadow[4] = 0.0
	else:
		
		vec.x = 0
		vec.z = 0
		if state != "idle":
			state = "idle"
			idle_time_max = 5+randf()*5
			ani_tree.walk(0.0)
			shadow[3] = 0.0
			shadow[4] = 0.0
		if idle_time > idle_time_max:
			move_time = 0.0
			$body/Skeleton.rot_head_x(0,true)
			change_dire(randf()*45)

var item_obj = null
func _on_near_item(drop_obj) -> void:
	if !item_obj:item_obj = drop_obj
	if !Function.is_obj(item_obj):
		item_obj = drop_obj
	if item_obj.id != drop_obj.id:
		if abs(translation.distance_to(item_obj.translation)) > abs(translation.distance_to(drop_obj.translation)):
			item_obj = drop_obj
	if item_obj.name_ == "wheat":
		mode = "eat"
		pos2 = Vector2(item_obj.translation.x,item_obj.translation.z)
#	Overall.entity_node_node.rpc1(name,"near_item",[item,vec3])
#	near_item([item,vec3])
#master func near_item(args:Array) -> void:
#	var vec3 = args[0]

var eating := false

func eat_mode(delta:float) -> void:
	var vec2 = Vector2(translation.x,translation.z)
	if !eating:
		eating = true
		yield(get_tree().create_timer(0.3),"timeout")
		ani_tree.update_ani("eat_start")
		Overall.entity_node_node.rpc1(name,"update_ani","eat_start")
	if check_rot_time == 0:
		if !Function.is_obj(item_obj):
			if state != "eat_ending":
				ani_tree.update_ani("eat_end")
				Overall.entity_node_node.rpc1(name,"update_ani","eat_end")
			mode = "idle"
			eat_time = 0.0
			return
	if state == "walk":
		check_rot(delta,randi()%100-50)
		
	
	
	if state == "eat_ending":
		eat_end_time += delta
		if eat_end_time > eat_end_time_max:
			eat_end_time = 0.0
			state = "eat_end"
			move_time = 0.0
			change_dire(30+randf()*40)
			mode = "idle"
			eating = false

		return

	
	if abs(vec2.distance_to(pos2)) > 1.0:
		state = "walk"
		vec.z = move_speed
		ani_tree.walk(1.0)
		shadow[3] = 1.0
		shadow[4] = 0.0
	else:
		vec.x = 0
		vec.z = 0
		state = "eating"
		ani_tree.walk(0.0)
		shadow[3] = 0.0
		shadow[4] = 0.0
		eat_time += delta
		if eat_time > eat_time_max:
			if Function.is_obj(item_obj):
				item_obj.queue_free()
			eat_time = 0.0
			ani_tree.update_ani("eat_end")
			Overall.entity_node_node.rpc1(name,"update_ani","eat_end")
			state = "eat_ending"
			eat_end_time = 0.0
			
var eat_nofood_time := 0.0
var eat_nofood_time_max := 2.0
func eat_nofood_mode(delta:float) -> void:
	move_speed = idle_speed
	var walk_pro = move_speed/walk_speed
	var vec2 = Vector2(translation.x,translation.z)
	eat_nofood_time += delta
	if !eating:
		eating = true
		yield(get_tree().create_timer(0.3),"timeout")
		ani_tree.update_ani("eat_start")
		Overall.entity_node_node.rpc1(name,"update_ani","eat_start")
	if state == "walk":
		check_rot_time += delta
		if check_rot_time > check_rot_time_max:
			check_rot_time = 0
			change_dire(randf()*45)
		
	if state == "eat_ending":
		eat_end_time += delta
		if eat_end_time > eat_end_time_max:
			eat_end_time = 0.0
			state = "eat_end"
			move_time = 0.0
			change_dire(30+randf()*40)
			mode = "idle"
			eating = false
		return

	
	if eat_nofood_time < eat_nofood_time_max:
		state = "walk"
		vec.z = move_speed
		ani_tree.walk(walk_pro)
		shadow[3] = walk_pro
		shadow[4] = 0.0
	else:
		vec.x = 0
		vec.z = 0
		state = "eating"
		ani_tree.walk(0.0)
		shadow[3] = 0.0
		shadow[4] = 0.0
		eat_time += delta
		if eat_time > eat_time_max:
			eat_time = 0.0
			ani_tree.update_ani("eat_end")
			Overall.entity_node_node.rpc1(name,"update_ani","eat_end")
			state = "eat_ending"
			eat_end_time = 0.0
			
func attract_mode(delta:float) -> void:
	if in_liquid:
		liquid_move(delta)
	var vec2 = Vector2(translation.x,translation.z)
	if !is_wall:
		look_at(Vector3(pos2.x,0,pos2.y),Vector3(0,1,0))
		rotation_degrees.y += 180
		rotation_degrees.x = 0
		rotation_degrees.z = 0
	
	if abs(vec2.distance_to(pos2)) > 1.0:
		state = "walk"
		vec.z = move_speed
		ani_tree.walk(1.0)
		shadow[3] = 1.0
		shadow[4] = 0.0
	else:
		vec.x = 0
		vec.z = 0
		ani_tree.walk(0.0)
		shadow[3] = 0.0
		shadow[4] = 0.0
		state = "default"
var notice_time := 0.0
var notice_time_max := 0.3
func notice_mode(delta:float) -> void:
	notice_time += delta
	if in_liquid:
		liquid_move(delta)
	if notice_time > notice_time_max:
		notice_time = 0.0
		vec.z = 0
		var vec2 := Vector2(notice_obj.translation.x,notice_obj.translation.z)
		var dd = notice_obj.translation.distance_to(translation)
		var dy = translation.y - notice_obj.translation.y
		var pro = dy/dd
		$body/Skeleton.rot_head_x(pro,true)
		ani_tree.walk(0.0)
		shadow[3] = 0.0
		shadow[4] = 0.0
		var old = rotation_degrees.y
		look_at(Vector3(vec2.x,0,vec2.y),Vector3(0,1,0))
		rotation_degrees.y += 180
		rotation_degrees.x = 0
		rotation_degrees.z = 0
		var new = rotation_degrees.y
		if new > 180:
			new = -180+ new - 180
		rotation_degrees.y = old
		var sub = (new-old)/8
		for i in range(8):
			yield(get_tree(),"idle_frame")
			rotation_degrees.y = old + sub*i
	if randi()%30 == 0:
		change_mode("idle")
		$body/Skeleton.rot_head_x(0.0)
var atk_dis := 3.0
var atk_move_speed := 0.5
var stop_dis := 1.5
func atk_mode(delta:float) -> void:
	if is_hurt:return
	if !Function.is_obj(atk_player):
		mode = "idle"
		return
	if atk_player.dead:
		mode = "idle"
		return
	if in_liquid:
		liquid_move(delta)
	move_speed = run_speed
	pos2 = Vector2(atk_player.translation.x,atk_player.translation.z)
	var vec2 = Vector2(translation.x,translation.z)
	$body/Skeleton.rot_head_y(0.0,true)
	check_rot_time += delta
	check_rot(delta,0)

	var dis = abs(translation.distance_to(atk_player.translation))
	if dis > hatred_dis_max:
		mode = "idle"
		return
	if atk_time != 0.0:
		dis -= 1.0
	if dis > atk_dis:
		state = "atk"
		vec.z = move_speed
		ani_tree.run(1.0)
		shadow[3] = 0.0
		shadow[4] = 1.0
		atk_time = 0.0
	else:
		atk_time += delta
		if atk_time > atk_time_max:
			atk_time = 0.0
			var vec_be = (pos2 - vec2).normalized()*4
			atk_player.hurt(atk,Vector3(vec_be.x,6,vec_be.y))
			Overall.player_node_node.rpc2("hurt",atk,Vector3(vec_be.x,6,vec_be.y))
		if !ani_tree["parameters/atk/active"]:
			atk_time = 0.0
			ani_tree["parameters/atk/active"] = true
		
		vec.x = 0
		move_speed = walk_speed
		if dis > stop_dis:
			vec.z = move_speed*atk_move_speed
			ani_tree.walk(atk_move_speed)
			shadow[3] = 1.0
			shadow[4] = 0.0
		else:
			ani_tree.walk(0.0)
			vec.z = 0.0
			shadow[3] = 0.0
			shadow[4] = 0.0

func run_mode(delta:float) -> void:
	move_speed = run_speed
	var vec2 = Vector2(translation.x,translation.z)
	check_rot(delta,randi()%100-50)
	if in_liquid:
		liquid_move(delta)
		move_speed = liquid_run_speed
	if abs(vec2.distance_to(pos2)) > 3.0:
		state = "run"
		vec.z = move_speed
		ani_tree.run(1.0)
		shadow[3] = 0.0
		shadow[4] = 1.0
	else:
#		print(Vector2(atk_player.translation.x,atk_player.translation.z).distance_to(vec2))
		if Vector2(atk_player.translation.x,atk_player.translation.z).distance_to(vec2) < run_dis_max:
			init_run_pos2()
		else:
			mode = "idle"
			
func init_run_pos2() -> void:
	check_rot_time = check_rot_time_max
	pos2 = Vector2(translation.x,translation.z) - (Vector2(atk_player.translation.x,atk_player.translation.z) - Vector2(translation.x,translation.z)).normalized() * (randi()%10+10)
func check_rot(delta:float,rot:int) -> void:
	check_rot_time += delta
	if check_rot_time > check_rot_time_max:
		if !is_wall:
			check_rot_time = 0
			var old = rotation_degrees.y
			look_at(Vector3(pos2.x,0,pos2.y),Vector3(0,1,0))
			rotation_degrees.y += 180 + rot
#			rotation_degrees.y += 180
			var new = rotation_degrees.y
			if new > 180:
				new = -180+ new - 180
			rotation_degrees.y = old
			var sub = (new-old)/15
			rotation_degrees.x = 0
			rotation_degrees.z = 0
			for i in range(15):
				yield(get_tree(),"idle_frame")
				rotation_degrees.y = old + sub*i
func queue_free() -> void:
	.queue_free()
	Overall.entity_node_node.delete_entity(int(name))

func _mouse_left(pos3:Vector3) -> bool:
	if state == "dead":
		return true
	return false


