extends KinematicBody
class_name Player

var move_offset := 1.0



var vec3 := Vector3()
var move_speed := 3
var jump_speed := 10
var fly_speed := 10
var gravity := 0.7
#var drop_speed := Vector3(15,0,0) 

var state := "default"
var is_jump := false
var w := false
var a := false
var s := false
var d := false
var jump := false
var shift := false
var camera_current = "camera_f"
var camera_fov_speed := 1
var mouse_speed := 0.1
var mouse_up_max := 30
var mouse_down_max := 30
var mouse_up_max_first_person := 89
var mouse_down_max_first_person := 89
#
var bar = []
var bar_index := 0
var bag = []
var jump_satiety = 0.05

var is_hurt := false

signal hit
signal entered_player(obj)
signal entered_attract(obj)
signal exited_attract(obj)

var walk_allow := true
var walk_cd := 0.0
var walk_cd_max := 0.64
var control := true

var box := VoxelBoxMover.new()
var aabb := AABB(Vector3(-0.4, -0.2, -0.4), Vector3(0.8, 1.8, 0.8))
var box_camera := VoxelBoxMover.new()
var aabb_camera := AABB(Vector3(-0.1, -0.1, -0.1), Vector3(0.1, 0.1, 0.1))
var mouse := false

var atk := 1.0
var atk_offset := 1.0

var hand_speed_offset := 1.0

var dead := false
var in_liquid := false
var body_in_liquid := false
var head_in_liquid := false
var time := 0.0
var liquid_water_env := preload("res://liquid.tres")
func check_liquid() -> void:
#	var block = Overall.terrain_main_node.get_block(translation+Vector3(0,1,0))
	body_in_liquid = Overall.terrain_node_node.check_in_liquid(translation)
	in_liquid = body_in_liquid
	if body_in_liquid:
		move_speed = 1.5
	else:
		move_speed = 3
	
	if head_in_liquid:
		in_liquid = true
		$camera_node/camera_f.environment = liquid_water_env
		$camera_node/camera_t.environment = liquid_water_env
		$camera_node/camera_self.environment = liquid_water_env
	else:
		$camera_node/camera_f.environment = null
		$camera_node/camera_t.environment = null
		$camera_node/camera_self.environment = null
var in_entity := false
var vec_offset := Vector3(0,0,0)
func check_entity() -> void:
	var obj = Overall.terrain_node_node.check_entity(translation-Vector3(0.2,0.8,0.2),Vector3(0.4,1.6,0.4),CollisionGroup.LAYER.animal)
	if obj:
		var pos2_player = Vector2(translation.x,translation.z)
		var pos2_obj = Vector2(obj.translation.x,obj.translation.z)
		var pos2_offset = (pos2_player - pos2_obj).normalized()
		vec_offset = Vector3(pos2_offset.x,0,pos2_offset.y)*1.5
		obj.vec_offset = -vec_offset
		obj.in_entity = true
		in_entity = true
	else:
		vec_offset = Vector3(0,0,0)
		in_entity = false
func _on_new_life() -> void:
	if dead:Overall.player_node_node.rpc0("new_life")
	dead = false
	control = true
	Overall.state_gui_player_node.new_life()
	Overall.player_node_node.rpc0("new_life")
func _on_dead() -> void:
	if !dead:Overall.player_node_node.rpc0("dead")
	$camera_node/camera_f/hand.shake = false
	dead = true
	control = false
	Overall.state_gui_player_node.dead()
	Overall.player_node_node.rpc0("dead")
func send_hit() -> void:
	emit_signal("hit")
func _ready() ->void:
#	$fall.collision_layer = 0
#	$fall.collision_mask = 0
#	$fall.collision_mask = CollisionGroup.LAYER.gravity
	box.set_collision_mask(CollisionGroup.VOXEL_LAYER.player)
	box_camera.set_collision_mask(CollisionGroup.VOXEL_LAYER.liquid)
	bar = Save.save_data.player.bar
	bag = Save.save_data.player.bag
	CollisionGroup.collision(self,"player")
	CollisionGroup.collision($camera_node/camera_f/ray,"player_ray")
	CollisionGroup.collision($camera_node/camera_t/ray,"player_ray")
	CollisionGroup.collision($area_drop,"player_area_drop")
	CollisionGroup.collision($area_attract_drop,"player_area_drop")
	connect("hit",self,"_on_hit")
	$event_cd.wait_time = 0.35
	Overall.op = false
	var material = $player/Skeleton/body.material_override.duplicate()
	$player/Skeleton/body.material_override = material
	
	Overall.player_node = self
	$area_attract_drop.connect("body_entered",self,"_on_entered_attract_drop")
	$area_attract_drop.connect("body_exited",self,"_on_exited_attract_drop")
	$area_drop.connect("body_entered",self,"_on_entered_player_drop")
	$camera_node.connect("place",self,"_on_place")
	set_physics_process(false)
	update_net()
	if !Overall.cg:
		var pos3 = Save.save_data.player.pos3
		var rot = Save.save_data.player.rot
		pos3 = Vector3(pos3[0],pos3[1]+4.0,pos3[2])
		var vt = Overall.terrain_main_node.vt
		while true:
			yield(get_tree(),"idle_frame")
			translation = pos3
			if vt.is_area_editable(AABB(pos3,Vector3(2,2,2))):
				if !Overall.terrain_main_node.is_exist(pos3):
					break
				else:
					pos3.y+=5
			
		rotation_degrees = Vector3(rot[0],rot[1],rot[2])
			
	yield(get_tree(),"idle_frame")
	yield(get_tree(),"idle_frame")
	set_physics_process(true)
	Overall.name_node.set_tex(Net.my_info.name,$player/Skeleton/head/name)
func update_net() -> void:
	if Net.status:
		$player/Skeleton/head/name.show()
	else:
		$player/Skeleton/head/name.hide()

var drop_block_tscn = preload("res://tscn/drop/drop.tscn")
func drop(name_:String,num:int,hp:int) -> void:
	if Overall.cg:return
	var pos3 = get_drop_pos3()
	var tscn = drop_block_tscn.instance()
	var rot3 = Overall.player_node.get_camera().get_global_transform()
	Overall.player_node_node.rpc1("drop",[name_,num,hp,pos3,rot3])
	tscn.drop = 1
	tscn.rot3 = rot3
	tscn.translation = pos3
	tscn.name_ = name_
	tscn.num = num
	tscn.hp = hp
	Overall.terrain_node_node.add_child(tscn)
	
	

func get_drop_pos3():
	return $camera_node/camera_f/drop.global_transform.origin

func get_look_dire() -> int:
#	return Overall.chunks_node_node.get_dire_id()
	var dire = 0
	var rot_y = self.rotation_degrees.y
	var cam_rot_x = $camera_node.rotation_degrees.x
	if abs(cam_rot_x) > 60:
		if cam_rot_x<0:
			dire = 4
		else:
			dire = 5
	else:
		if rot_y > -45 && rot_y < 45:
			dire = 2
		if rot_y < -45 && rot_y > -135:
			dire = 3
		if rot_y > 45 && rot_y < 135:
			dire = 1
		if rot_y < -135 || rot_y > 135:
			dire = 0
	return dire
func _on_hit() -> void:
	if Overall.cg:return
	var ray = get_node("camera_node/"+camera_current+"/ray")
	ray.force_raycast_update()
	var vec3 = null
	if ray.is_colliding():
		vec3 = ray.get_collision_point()-ray.get_collision_normal()/2
	
		var obj = ray.get_collider()
		if Function.is_obj(obj):
			if obj.has_method("_hurt"):
				if obj._hurt(atk*atk_offset):
					return
			if obj.has_method("_mouse_left"):
				if obj._mouse_left(vec3):
					return

func _on_entered_attract_drop(obj) -> void:
	emit_signal("entered_attract",obj)
func _on_exited_attract_drop(obj) -> void:
	emit_signal("exited_attract",obj)
func _on_entered_player_drop(obj) -> void:
	emit_signal("entered_player",obj)
func _on_place(vec3:Vector3) -> void:
	if Overall.cg:return
	if Overall.gui:return
	if Overall.bar_node.can_place(bar_index):
		var dire = get_look_dire()
		var block = Block.get(bar[bar_index].name)
		var par = true
		if block.liquid:par = false
		if Overall.terrain_main_node.place(vec3,bar[bar_index].name,dire,par):
			Overall.bar_node.sub_num(bar_index,1)
var press_w := 0.0
var release_w := 0.0
var run := false
func talk(text:String) -> void:
	if Overall.cg:
		$msg.talk(text)
		return
	
	Overall.player_node_node.rpc1("talk",text)
	$msg.talk(text)
var is_play_event := false
func _physics_process(delta:float) ->void:
	if run:
		if $camera_node/camera_f.fov < 75:
			$camera_node/camera_f.fov += 1
	else:
		if $camera_node/camera_f.fov > 70:
			$camera_node/camera_f.fov -= 1
	if !Overall.cg:
		head_in_liquid = false
		var block = Overall.terrain_main_node.get_block(translation+Vector3(0,1,0))
		if block:
			if block.liquid:
				head_in_liquid = Overall.terrain_node_node.check_in_liquid(translation+Vector3(0,1.05+block.lv*1/7,0))
		time += delta
		if time >0.1:
			time = 0.0
			check_liquid()
			check_entity()
		var sk = $player/Skeleton
		is_play_event = $AnimationTree["parameters/event/active"]

		Overall.state_gui_player_node.shadow = [translation,rotation_degrees,vec3,hand_name,state,jump_state,$camera_node.eating,is_play_event,sk.rotation_degrees.y,sk.head0_vec3,sk.waist1_vec3]
		Overall.player_node_node.rset1_udp("shadow",[translation,rotation_degrees,vec3,hand_name,state,jump_state,$camera_node.eating,is_play_event,sk.rotation_degrees.y,sk.head0_vec3,sk.waist1_vec3])
	press_w += delta
	release_w += delta
	if !control:
		vec3.x = 0
		vec3.z = 0
		if Overall.cg:return
		if Overall.op:
			vec3.y=0
		else:
			if is_on_floor():
				vec3.y=0
			else:
				vec3.y-=gravity
		if !Overall.cg:
			var vec3_ = box.get_motion(get_translation(), get_global_transform().basis.xform(vec3*delta), aabb,Overall.terrain_main_node)
			vec3_ = vec3_/delta
			move_and_slide(Vector3(vec3_.x*move_offset,vec3_.y,vec3_.z*move_offset),Vector3(0,1,0))
		else:
			var vec3_  = get_global_transform().basis.xform(vec3)
			move_and_slide(Vector3(vec3_.x*move_offset,vec3_.y,vec3_.z*move_offset),Vector3(0,1,0))
		return
	if !walk_allow:
		walk_cd+=delta
		if walk_cd > walk_cd_max:
			walk_cd = 0.0
			walk_allow = true
			
#	if !Overall.gui:
	w = Input.is_action_pressed("w")
	s = Input.is_action_pressed("s")
	a = Input.is_action_pressed("a")
	d = Input.is_action_pressed("d")
	jump = Input.is_action_pressed("jump")
	shift = Input.is_action_pressed("shift")
	vec3.z=0
	vec3.x=0
	if Overall.op:
		vec3.y=0
	else:
		vec3.y-=gravity
	update_body_head_rot()
	update_state(delta)
	update_ani(state,jump_state)
	update_mouse()
	var vec3_ = get_global_transform().basis.xform(vec3*delta)
	if !Overall.cg:
		vec3_ = box.get_motion(get_translation(), get_global_transform().basis.xform(vec3*delta), aabb,Overall.terrain_main_node)
	var vec3_be = vec3_/delta
	if is_hurt:
		vec3_be.x/=2
		vec3_be.z/=2
	if Overall.op:
		move_and_slide(vec3_be*10,Vector3(0,1,0))
	else:
		move_and_slide(Vector3(vec3_be.x*move_offset,vec3_be.y,vec3_be.z*move_offset),Vector3(0,1,0))
		if in_entity:
			vec3_ = box.get_motion(get_translation(), vec_offset*delta, aabb,Overall.terrain_main_node)
			move_and_slide(vec3_/delta,Vector3(0,1,0))
	
	if state == "walk" || state == "walk_back":
		Overall.status_node.satiety_time+=delta
		Overall.status_node.thirst_time+=delta
	if state == "run":
		Overall.status_node.satiety_time+=delta*2.5
		Overall.status_node.thirst_time+=delta*2.5

func update_body_head_rot() ->void:
	if a:
		$player/Skeleton.turn_around("left")
	if d:
		$player/Skeleton.turn_around("right")
	if (!a)&&(!d):
		if (w||d):
			$player/Skeleton.turn_around("forward")
		else:
			$player/Skeleton.turn_around("default")

var moveing := false
var jump_state = "no_jump"
func update_state(delta:float) ->void:
	var floor_ = check_floor()
	jump_state = "no_jump"
	$camera_node/camera_f/hand.shake = false
#	if floor_:
#		if is_jump:
#			state = "default"
#			update_ani("default")
	var walk_ = check_move()
	if walk_ == "default":
		state = "default"
	elif walk_ == "walk":
		$camera_node/camera_f/hand.shake = true
		$camera_node/camera_f/hand.offset_pro = move_offset
		$camera_node/camera_f/hand.damage_pro = move_offset
		
		walk_audio()
		state = "walk"
	elif walk_ == "walk_back":
		$camera_node/camera_f/hand.shake = true
		$camera_node/camera_f/hand.offset_pro = 0.5*move_offset
		$camera_node/camera_f/hand.damage_pro = 1.0*move_offset
		walk_cd -= delta/2
		walk_audio()
		state = "walk_back"
	elif walk_ == "run":
		$camera_node/camera_f/hand.shake = true
		$camera_node/camera_f/hand.offset_pro = 2.0*move_offset
		$camera_node/camera_f/hand.damage_pro = 0.5*move_offset
		walk_cd += delta
		walk_audio()
		state = "run"
	if is_jump:
		$camera_node/camera_f/hand.shake = false
	if body_in_liquid:
		$camera_node/camera_f/hand.offset_pro = 0.5
		$camera_node/camera_f/hand.damage_pro = 0.5
	if !in_liquid:
		var jump_ = check_jump()
		if is_jump:
			if moveing:
				jump_state = "jump_walk"
			else:
				jump_state = "jump"
	else:
		if jump:
			vec3.y += 2
		vec3.y *= 0.7
	if Overall.op:
		if jump:
			vec3.y = fly_speed
		if shift:
			vec3.y = -fly_speed
	

var ani_tree_state := ""
func update_ani(name_:String,name2_:String) -> void:
	$AnimationTree.update_ani(name_,name2_)
func play_ani(name_:String,active:=true) -> void:
	Overall.player_node_node.rpc2("play",name_,active)
	$AnimationTree.play(name_,active)
func playing(name_:String,val:=0.0) ->void:
	$AnimationTree.playing(name_,val)
func walk_audio() -> void:
	if vec3.y != 0:return
	if walk_allow:
		walk_allow=false
		if $down.is_colliding():
			var obj = $down.get_collider()
			if obj.has_method("_walk"):
				$audio_player.walk(obj._walk($down.get_collision_point()-$down.get_collision_normal()))
		else:
			if Overall.cg:return
			var audio_name = Overall.terrain_main_node._walk(translation-Vector3(0,1.5,0))
			if audio_name:
				$audio_player.walk(audio_name)
func fall_audio() -> void:
	$audio_player.fall()
func hurt_audio() -> void:
	$audio_player.hurt()
func hurt_block_audio(name_:String) -> void:
	if !Overall.cg:
		Overall.player_node_node.rpc1_udp("hurt_block_audio",name_)
	$audio_player.hurt_block(name_)
func get_length() -> float:
	var length = $camera_node.length_f
	if $camera_node.camera_current == "camera_t":length = $camera_node.length_t
	return length
func eat_audio() -> void:
	$audio_player.eat()
func check_floor() -> bool:
	var be = false
	if is_on_floor():
		if vec3.y < -15:
			fall_audio()
		if vec3.y < -20:
#			print(abs(vec3.y+20))
			hurt(1.0+abs(vec3.y+20)*0.2,Vector3(0,0,0),"foot",true)
		vec3.y=0
		be = true
		is_jump=false
	return be 
func fall_hurt(force:float) -> void:
	force = abs(force)
	if force >3.5:
		var sub_hp = 0.1+(force-3.5)*0.2
		hurt(sub_hp,Vector3(0,0,0),"head")
var body_arr = ["head","body","arm_left","arm_right","leg_left","leg_right"]
func hurt(sub_hp:float,vec:=Vector3(0,0,0),body:="",is_self:=false) -> void:
	if is_hurt:return
	hurt_audio()
	if vec == Vector3(0,0,0):
		vec.x = randi()%11*0.2
		vec.z = randi()%11*0.2
		vec.y = randi()%11*0.2+5
		if Function.rand(2):
			vec.x = -vec.x
		if Function.rand(2):
			 vec.z = -vec.z

	
	var tween = $Tween
	var material = $player/Skeleton/body.material_override
	sub_hp = abs(sub_hp)
	var be = 0.5-sub_hp*0.2
	if be <0.0:be = 0.0
	var time = 0.5+sub_hp*0.2
	tween.interpolate_property(material, "albedo_color",
			Color(1,be,be,1), Color(1,1,1,1), time,
			Tween.TRANS_SINE , Tween.EASE_OUT)
	tween.start()
	var vec3_ = box.get_motion(get_translation(), (vec*0.016), aabb,Overall.terrain_main_node)
	var vec3_be = vec3_/0.016
#	hurt_time()
	is_hurt = true
	$AnimationTree.play("hurt")
	Overall.state_gui_player_node.hurt([sub_hp,vec])
	Overall.player_node_node.rpc1("hurt",[sub_hp,vec])
	if !body:
		body = body_arr[randi()%6]
		sub_hp(sub_hp,body,is_self)
	else:
		if body == "foot":
			sub_hp/=2.0
			Overall.status_node.sub_hp(sub_hp,"foot_left",true)
			Overall.status_node.sub_hp(sub_hp,"foot_right",true)
		else:
			Overall.status_node.sub_hp(sub_hp,body,false)
	for i in range(15):
		yield(get_tree(),"idle_frame")
		move_and_slide(vec3_be,Vector3(0,1,0))
	is_hurt = false
func hurt_hp(sub_hp:float,vec:=Vector3(0,0,0)) -> void:
	if is_hurt:return
	hurt_audio()
	if vec == Vector3(0,0,0):
		vec.x = randi()%11*0.2
		vec.z = randi()%11*0.2
		vec.y = randi()%11*0.2+5
		if Function.rand(2):
			vec.x = -vec.x
		if Function.rand(2):
			 vec.z = -vec.z
	var tween = $Tween
	var material = $player/Skeleton/body.material_override
	sub_hp = abs(sub_hp)
	var be = 0.5-sub_hp*0.2
	if be <0.0:be = 0.0
	var time = 0.5+sub_hp*0.2
	tween.interpolate_property(material, "albedo_color",
			Color(1,be,be,1), Color(1,1,1,1), time,
			Tween.TRANS_SINE , Tween.EASE_OUT)
	tween.start()
	var vec3_ = box.get_motion(get_translation(), (vec*0.016), aabb,Overall.terrain_main_node)
	var vec3_be = vec3_/0.016
#	hurt_time()
	is_hurt = true
	$AnimationTree.play("hurt")
	Overall.state_gui_player_node.hurt([sub_hp,vec])
	Overall.player_node_node.rpc1("hurt",[sub_hp,vec])
	Overall.status_node.sub_health(sub_hp)
	for i in range(15):
		yield(get_tree(),"idle_frame")
		move_and_slide(vec3_be,Vector3(0,1,0))
	is_hurt = false
func sub_hp(sub_hp:float,body:="",is_self:=false) -> void:
	if !body:
		body = body_arr[randi()%6]
	if sub_hp > 1.0:
		sub_hp /= 2.0
		Overall.status_node.sub_hp(sub_hp,body,is_self)
		sub_hp(sub_hp)
	else:
		Overall.status_node.sub_hp(sub_hp,body,is_self)
func hurt_time():
	is_hurt = true
	yield(get_tree().create_timer(0.3),"timeout")
	is_hurt = false
func check_move() -> String:
#	var phone := Overall.phone
#	if phone:
#		vec3.z = Overall.arrow_pos_left.y
#		vec3.x = Overall.arrow_pos_left.x
	var be = "default"
	if w:
		be = "walk"
		vec3.z = move_speed
	if s:
		be = "walk_back"
		vec3.z = -move_speed
		vec3.z /= 2
	if a:
		be = "walk"
		vec3.x = move_speed
	if d:
		be = "walk"
		vec3.x = -move_speed
	if run:
		be = "run"
		vec3.z = move_speed
		vec3.z *=2
	if be == "default":
		moveing = false
	else:
		moveing = true

	return be
func check_jump() -> bool:
	var be = false
	if jump&&!is_jump:
#	if jump:
		be = true
		is_jump=true
		vec3.y=jump_speed
		Overall.status_node.satiety_time+=jump_satiety
		Overall.status_node.thirst_time+=jump_satiety
		
	return be
	
func pick_up(name_:String,num:int,hp:int) -> void:
	if !Net.is_master():return
	var item = {"name":name_,"num":num,"hp":hp}
	Overall.bar_node.add_item(item)
	if num != item.num:
		num -= item.num
		Overall.msg_pickup_node.add_msg(name_,num)
		
		
func pick_up_c(args:Array) -> void:
	var num = args[1]
	var item = {"name":args[0],"num":args[1],"hp":args[2]}
	Overall.bar_node.add_item(item)
	if num != item.num:
		num -= item.num
		Overall.msg_pickup_node.add_msg(args[0],num)
		
		
func update_mouse() -> void:
	pass
	
var w_ := false
func _unhandled_input(event) -> void:
	if event.is_action_pressed("w"):
		if !w_:
			if press_w < Config.PRESS_TIME:
				if release_w < Config.RELEASE_TIME:
					run = true
		press_w = 0.0
		w_ = true
	if event.is_action_released("w"):
		run = false
		w_ = false
#		press_w = 0.0
		release_w = 0.0
	if event.is_action_pressed("e"):
		if !Overall.cg:
			Overall.gui_node_node.change_ui("bag","default")

	if !control:return
	if event.is_action_pressed("q"):
		if bar[bar_index].num:
			drop(bar[bar_index].name,1,bar[bar_index].hp)
			bar[bar_index].num -= 1
			Overall.bar_node.update()
	if event.is_action_pressed("mouse_down"):
		if bar_index == 8:bar_index = -1
		bar_index+=1
		Overall.bar_node.select(bar_index)
	if event.is_action_pressed("mouse_up"):
		if bar_index == 0:bar_index = 9
		bar_index-=1
		Overall.bar_node.select(bar_index)
	for i in range(1,10):
		if event.is_action_pressed(str(i)):
			bar_index = i-1
			Overall.bar_node.select(bar_index)
			break
	if event is InputEventMouseMotion && !Overall.gui:
		pass
#	if event.is_action_pressed("mouse_left"):
#		Overall.chunks_node_node.place(Vector3(300,0,300),"stone")
#		Overall.chunks_node_node.check()
#		_input=1
#		if Net.status:
#			get_node("../").shadow(Net.id,{"chest":chest,"rot":rotation_degrees,"neck":neck.rotation_degrees,"camera":camera_rot,"camera_h":camera_h_rot})
func check_buff() -> void:
	var buff_list = Overall.buff_node.buff_list
	var BUFF_LIST = Config.BUFF_LIST
	move_offset = 1.0
	hand_speed_offset = 1.0
	atk_offset = 1.0
	var offset = Overall.status_node.offset
	offset.absorb = 1.0
	offset.deplete_time = 1.0
	for buff in buff_list:
		if buff_list[buff]:
			if BUFF_LIST[buff].move:
				move_offset *= BUFF_LIST[buff].move
			if BUFF_LIST[buff].absorb:
				offset.absorb *= BUFF_LIST[buff].absorb
			if BUFF_LIST[buff].deplete_time:
				offset.deplete_time *= BUFF_LIST[buff].deplete_time
			if BUFF_LIST[buff].atk:
				atk_offset *= BUFF_LIST[buff].atk
			if BUFF_LIST[buff].hand_speed:
				hand_speed_offset *= BUFF_LIST[buff].hand_speed


func get_hand() -> Dictionary:
	return bar[bar_index]
func get_camera() -> Object:
	return $camera_node.get_node($camera_node.camera_current)
func get_drop() -> Object:
	return $camera_node/camera_f/drop
var hand_name := ""
func change_hand(name_:="") -> void:
	hand_name = name_
	atk = Tool.get_atk(name_)
	$player/Skeleton.change_hand(name_)
	$camera_node.set_block_speed(name_)
	$camera_node/camera_f/hand.change_hand(name_)
func change_camera(mode:String) -> void:
	$camera_node.change_camera(mode)
func update_camera() -> void:
	$camera_node.update_camera()
	
func get_look_pos(length:=0.0):
	var origin = Overall.player_node.get_camera().get_global_transform().origin
	var forward = Overall.player_node.get_camera().get_global_transform().basis.xform(Vector3(0,0,-1))
	var pos3 = Overall.terrain_main_node.check(CollisionGroup.ALL)
	return pos3
func is_on_floor() -> bool:
	if !Overall.cg:
		var pos3_ = box.get_motion(get_translation(), Vector3(0,-1,0), aabb,Overall.terrain_main_node)
		if abs(pos3_.y) < 0.01:
			return true
	return .is_on_floor()


func on_armor(name_:String,index:int) -> void:
	$player/Skeleton.on_armor(name_,index)
	Overall.state_gui_player_node.on_armor(name_,index)
	Overall.player_node_node.rpc1("on_armor",[name_,index])
