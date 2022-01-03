extends KinematicBody

var move_offset := 1.0


var pos3 := Vector3()
var rot3 := Vector3()
var vec3 := Vector3()
var hand_name := ""
var state = "default"
var jump_state = "no_jump"
var eating := false
var is_play_event := false
var body_y := 0
var head0_vec3 := Vector3()
var waist1_vec3 := Vector3()
var run := false
var hurt := false
var box := VoxelBoxMover.new()
var aabb := AABB(Vector3(-0.4, -0.2, -0.4), Vector3(0.8, 1.8, 0.8))

var crack := [Vector3(),0.0,Vector3()]

#pos3,rot3,vec3,hand_name,state,jump_state,body_y,head0_vec3,waist1_vec3
var shadow := [Vector3(),Vector3(),Vector3(),"","default","no_jump",false,false,0,Vector3(),Vector3()]
var dead := false
func _ready() ->void:
	add_to_group(str(name))
#	$fall.collision_layer = 0
#	$fall.collision_mask = CollisionGroup.LAYER.gravity
	box.set_collision_mask(CollisionGroup.VOXEL_LAYER.player)
	CollisionGroup.collision(self,"player")
#	CollisionGroup.collision($camera_node/camera_f/ray,"player_ray")
#	CollisionGroup.collision($camera_node/camera_t/ray,"player_ray")
#	CollisionGroup.collision($area,"player_area")
#	CollisionGroup.collision($area_attract,"player_area_attract")
#	Overall.op = false
	var material = $player/Skeleton/body.material_override.duplicate()
	$player/Skeleton/body.material_override = material
#	$area_attract.connect("entered_player",self,"_on_entered_attract")
#	$area_attract.connect("exited_player",self,"_on_exited_attract")
#	$area.connect("entered_player",self,"_on_entered_player")
	set_physics_process(false)
	for i in range(5):
		yield(get_tree(),"idle_frame")
	set_physics_process(true)
#	print(Net.player_info[int(name)].name)
	Overall.name_node.set_tex(Net.player_info[int(name)].name,$player/Skeleton/head/name)
	

var sync_time := 0.0
var sync_time_max := 0.1
func _physics_process(delta) ->void:
	if dead:return
	if Net.is_master():
		var pname = Net.player_info[int(name)].name
		Save.save_data.players[pname].pos3 = shadow[0]
		Save.save_data.players[pname].rot3 = shadow[1]
		
	pos3 = shadow[0]
	rot3 = shadow[1]
	vec3 = shadow[2]
	hand_name = shadow[3]
	state =shadow[4]
	jump_state = shadow[5]
	eating = shadow[6]
	is_play_event = shadow[7]
	body_y = shadow[8]
	head0_vec3 = shadow[9]
	waist1_vec3 = shadow[10]
	Overall.terrain_node_node.sync_crack(name,crack)
	sync_time += delta
	if sync_time > sync_time_max:
		sync_time = 0.0
		translation = pos3
	rotation_degrees = rot3
	update_ani(state,jump_state)
	change_hand(hand_name)
	if is_play_event:
		play_event(1.0)
	$player/Skeleton.sync_bone(body_y,head0_vec3,waist1_vec3)
	
	var vec3_ = box.get_motion(get_translation(), get_global_transform().basis.xform(vec3*delta), aabb,Overall.terrain_main_node)
	var vec3_be = vec3_/delta
	if hurt:
		vec3_be.x/=2
		vec3_be.z/=2
	move_and_slide(vec3_be*move_offset,Vector3(0,1,0))
	if !is_eating:
		if eating:
			playing("eating",1.0)
		else:
			playing("eating",0.0)
	if is_on_floor():
		if vec3.y < -15:
			fall_audio()
		if vec3.x != 0 || vec3.z != 0:
			if !walk_allow:
				walk_cd+=delta
				if walk_cd > walk_cd_max:
					walk_cd = 0.0
					walk_allow = true
		walk_audio()
var walk_allow := false
var walk_cd := 0.0
var walk_cd_max := 0.64
func talk(text:String) -> void:
	$msg.talk(text)
	Overall.cmd_node.add_text(text)
var hand_name_his = ""
func change_hand(name_:String) -> void:
	if hand_name_his == name_:return
	hand_name_his = name_
	$player/Skeleton.change_hand(name_)

func play(name_:String,active:bool) -> void:
	$AnimationTree.play(name_,active)
func playing(name_:String,val:float) -> void:
	$AnimationTree.playing(name_,val)
func play_event(speed:float) -> void:
	$AnimationTree.play_event(speed)
func play_atk(speed:float) -> void:
	$AnimationTree.play_atk(speed)
var is_eating := false
func playing_eat() -> void:
	is_eating = true
	eat_audio()
	for i in range(1,11):
		yield(get_tree(),"idle_frame")
		playing("eating",i/10.0)
	is_eating = false
func update_ani(name_:String,name2_:String) -> void:
	$AnimationTree.update_ani(name_,name2_)
func fall_hurt(force:float) -> void:
	force = abs(force)
	if force >5:
		var sub_hp = 0.1+(force-5)*0.2
		hurt([sub_hp,Vector3()])
var is_hurt := false
func hurt(args:Array) -> void:
	if is_hurt:return
	var sub_hp = args[0]
	var vec = args[1]
	hurt_audio()
	if vec == Vector3(0,0,0):
		vec.x = randi()%11*0.2
		vec.z = randi()%11*0.2
		vec.y = randi()%11*0.2+5
		if Function.rand(2):
			vec.x = -vec.x
		if Function.rand(2):
			 vec.z = -vec.z
	else:
		vec.x *= 0.9+randi()%11*0.02
		vec.z *= 0.9+randi()%11*0.02
		vec.y *= 0.9+randi()%11*0.02
	var tween = $Tween
	var material = $player/Skeleton/body.get_surface_material(0)
	sub_hp = abs(sub_hp)
	var be = 0.5-sub_hp*0.2
	if be <0.0:be = 0.0
	var time = 0.5+sub_hp*0.2
	tween.interpolate_property(material, "albedo_color",
			Color(1,be,be,1), Color(1,1,1,1), time,
			Tween.TRANS_SINE , Tween.EASE_OUT)
	tween.start()
	$AnimationTree.play("hurt")
	var vec3_ = box.get_motion(get_translation(), get_global_transform().basis.xform(vec*0.016), aabb,Overall.terrain_main_node)
	var vec3_be = vec3_/0.016
	is_hurt = true
	for i in range(15):
		yield(get_tree(),"idle_frame")
		move_and_slide(vec3_be,Vector3(0,1,0))
	is_hurt = false
func dead() -> void:
	pass
func new_life() -> void:
	pass


func pick_up(name_:String,num:int,hp:int) -> void:
	Overall.player_node_node.rpc1_player_self(int(name),"pick_up_c",[name_,num,hp])

var drop_block_tscn = preload("res://tscn/drop/drop.tscn")

func drop(args:Array) -> void:
	var name_ = args[0]
	var num = args[1]
	var hp = args[2]
	var pos3 = args[3]
	var rot3 = args[4]
	var tscn = drop_block_tscn.instance()
	tscn.drop = 1
	tscn.rot3 = rot3
	tscn.translation = pos3
	tscn.name_ = name_
	tscn.num = num
	tscn.hp = hp
	Overall.terrain_node_node.add_child(tscn)








func is_on_floor() -> bool:
	var pos3_ = box.get_motion(get_translation(), Vector3(0,-1,0), aabb,Overall.terrain_main_node)
	if abs(pos3_.y) < 0.01:
		return true
	return .is_on_floor()
	
	
	
	
	
	
	
	
	
var debris_tscn := preload("res://tscn/particle/block/debris.tscn")
func create_particles_small(pos3_collison:Vector3,block_name:String) -> void:
	for i in range(3):
		var debris = debris_tscn.instance()
		var hand = Overall.player_node.get_hand()
		debris.name_ = block_name
		debris._scale(0.5)
		debris.translation = pos3_collison+Vector3(randf()-0.5,0.51,randf()-0.5)
		var dire_offset = Vector3((randf()-0.5)*4,1.0,(randf()-0.5)*4)
		debris.set_velocity(dire_offset)
		Overall.terrain_node_node.add_child(debris)
		
		
		
		
func queue_free() -> void:
	.queue_free()
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
	$audio_player.hurt_block(name_)
func wave_audio() -> void:
	$audio_player.wave()
func eat_audio() -> void:
	$audio_player.eat()

func on_armor(args:Array) -> void:
	$player/Skeleton.on_armor(args[0],args[1])
