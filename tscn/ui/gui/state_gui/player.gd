extends Spatial

#pos3,rot3,vec3,hand_name,state,jump_state,body_y,head0_vec3,waist1_vec3
var shadow := [Vector3(),Vector3(),Vector3(),"","default","no_jump",false,false,0,Vector3(),Vector3()]




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

var dead := false
func _ready() ->void:
	Overall.state_gui_player_node = self
	var material = $player/Skeleton/body.material_override.duplicate()
	$player/Skeleton/body.material_override = material
	set_process(false)
	for i in range(5):
		yield(get_tree(),"idle_frame")
	set_process(true)

func _process(delta) ->void:
	if dead:return
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
	update_ani(state,jump_state)
	change_hand(hand_name)
	if is_play_event:
		play_event(Overall.player_node.hand_speed_offset)
	$player/Skeleton.sync_bone(body_y)
	if !is_eating:
		if eating:
			playing("eating",1.0)
		else:
			playing("eating",0.0)

var walk_allow := false
var walk_cd := 0.0
var walk_cd_max := 0.64
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
	for i in range(1,11):
		yield(get_tree(),"idle_frame")
		playing("eating",i/10.0)
	is_eating = false
func update_ani(name_:String,name2_:String) -> void:
	$AnimationTree.update_ani(name_,name2_)

var is_hurt := false
func hurt(args:Array) -> void:
	if is_hurt:return
	var sub_hp = args[0]
	var vec =[0.02,0.04,0.06,0.08,0.09,0.1,0.1,0.09,0.08,0.06,0,04,0,02,0]
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
	$AnimationTree.play("hurt")
	is_hurt = true
	
	for i in range(15):
		translation.y = vec[i]
		yield(get_tree(),"idle_frame")
	is_hurt = false
func dead() -> void:
	dead = true
func new_life() -> void:
	dead = false

	
	
func on_armor(name_:String,index:int) ->void:
	$player/Skeleton.on_armor(name_,index)

func queue_free() -> void:
	.queue_free()
