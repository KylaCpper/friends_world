extends KinematicBody
class_name Animation_Base_Client

onready var ani_tree := $AnimationTree
onready var pos2 := Vector2(translation.x,translation.z)
var box := VoxelBoxMover.new()
var aabb := AABB(Vector3(-0.4, -0.2, -0.4), Vector3(0.8, 1.8, 0.8))
var vec := Vector3()
var move_speed := 4.0
var move_speed_max := 4.0
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
var eat_end_time_max := 1.0
var move_time := 0.0
var move_time_max := 3.0

var move_r := 10.0 

var mode := "idle"

var is_wall := false
var wall_time := 0.0
var wall_time_max := 0.5

var rot_time := 0.0
var rot_time_max := 1.5

var hurt_time := 0.2
var is_hurt := false
var _time_ := 0.0
var _time_max_ := 0.1

var free_time := 5.0
#pos3 vec3 bodyy walk run bonex boney
var shadow := [Vector3(0,0,0),Vector3(0,0,0),0,0,0,0,0]
func _ready() ->void:
	box.set_collision_mask(CollisionGroup.VOXEL_LAYER.animal)
	CollisionGroup.collision(self,"animal")

func _process(delta:float) -> void:
	if state == "dead":
		vec.x = 0 
		vec.z = 0
		vec.y -= gravity
		if is_on_floor():
			vec.y = 0.0
		move(delta)
		return
	_time_ += delta
	if _time_ > _time_max_:
		_time_ = 0.0
		translation = shadow[0]

	if state == "standby":return
	$body/Skeleton.rot_head_x(shadow[5],true)
	$body/Skeleton.rot_head_y(shadow[6],true)
	ani_tree["parameters/walk/blend_amount"] = shadow[3]
	ani_tree["parameters/run/blend_amount"] = shadow[4]
	rotation_degrees.y = shadow[2]
	vec = shadow[1]
	if is_on_floor():
		vec.y = 0.0
	move(delta)
func play(name_:String) -> void:
	ani_tree.play(name_)
func update_ani(state:String) -> void:
	ani_tree.update_ani(state)

func move(delta:float) -> float:
	var vec3_ = box.get_motion(get_translation(), get_global_transform().basis.xform(vec*delta), aabb,Overall.terrain_main_node)
	var vec3_be = vec3_/delta
#	var dis = abs(Vector2(0,0).distance_to(Vector2(vec3_be.x,vec3_be.z)))
	
	var dis = move_and_slide(vec3_be,Vector3(0,1,0)).distance_to(Vector3(0,0,0))
	if vec.x != 0.0 || vec.z != 0.0:
		return dis
	else:
		return move_speed*1.0


func is_on_floor() -> bool:
	if !Overall.cg:
		var pos3_ = box.get_motion(get_translation(), Vector3(0,-1,0), aabb,Overall.terrain_main_node)
		if abs(pos3_.y) < 0.01:
			return true
	return .is_on_floor()
	
func jump(delta:float) -> void:
	vec.y = jump_speed
	move(delta)
	
func get_name_(vec:Vector3) -> String:
	return name_
	

func _hurt(atk:float) -> bool:
	hurt([atk,Net.id])
	Overall.entity_node_node.rpc1(name,"hurt",[atk,Net.id])
	return true
master func hurt(args:Array) -> void:
	if state == "dead":return
	if is_hurt:return
	var atk = args[0]
	atk_player_id = args[1]
	if Net.id == atk_player_id:
		atk_player = Overall.player_node
	else:
		var player_node = Overall.player_node_node
		if player_node.has_node(str(atk_player_id)):
			atk_player = player_node.get_node(str(atk_player_id))
			
	is_hurt = true
	ani_tree.play("hurt")
	yield_hurt()
	hurt_ani()
var atk_player_id := 0
var atk_player = null
func hurt_ani() -> void:
	if atk_player: 
		var vf = translation - atk_player.translation
		vf = Vector2(vf.x,vf.y).normalized()*2
		for i in range(10):
			yield(get_tree(),"idle_frame")
			move_and_slide(Vector3(vf.x,4,vf.y),Vector3(0,1,0))
func yield_hurt() -> void:
	yield(get_tree().create_timer(hurt_time),"timeout")
	is_hurt = false
func dead() -> void:
	state = "dead"
	ani_tree.dead()
	yield(get_tree().create_timer(free_time),"timeout")
	queue_free()







