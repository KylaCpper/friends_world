extends KinematicBody
var __drop__ := true
var name_ := "dirt"
var num := 1
var hp := 0
var force_vec3 := Vector3(0,0,0)
var enter := false
var move_pos3 := Vector3(0,0,0)
var pick_move = 15
var drop_speed = 20
var g = 0.2
var jump_distance := 5.0
var free := false
var drop := false
var drop_time := 0.8
onready var id = get_instance_id()
var box := VoxelBoxMover.new()
var aabb = AABB(Vector3(-0.3, -0.3, -0.3), Vector3(0.6, 0.6, 0.6))
var obj = null
var rot3 :Transform
var drop_type := 1

var free_time := 0.0
var free_time_max := 60.0
var check_time := 0.0
var check_time_max := 0.1
var msg_around_time := 0.0
var msg_around_time_max := 1.0
func get_name_(vec:Vector3) -> String:
	return name_
func _ready() -> void:
	box.set_collision_mask(CollisionGroup.VOXEL_LAYER.drop)
	CollisionGroup.collision(self,"drop")
	
	var item = Item.get(name_)
	if !item:return
	if hp == 0:
		if "hp" in item:
			hp = item.hp
	if item.type == "block":
		if !item.model:
			$node/model.hide()
			$node/sprite.hide()
			$node/model.queue_free()
			$node/sprite.queue_free()
			$node/single.show()
			$node/single._show(name_)
		else:
			$node/model.show()
			$node/sprite.hide()
			$node/single.hide()
			$node/sprite.queue_free()
			$node/single.queue_free()
			$node/model.mesh = item.model
			$node/model.material_override = load("res://tscn/world/terrain"+str(item.material)+".tres")
	else:
		$CollisionShape.shape = $CollisionShape.shape.duplicate()
		aabb = AABB(Vector3(-0.3, -0.01, -0.3), Vector3(0.6, 0.02, 0.6))
		$CollisionShape.shape.extents.y = 0.2
		$node/model.hide()
		$node/single.hide()
		$node/model.queue_free()
		$node/single.queue_free()
		$node/sprite.show()
		$node/sprite.create(item.img)
	drop()

func drop() -> void:
	if drop:
		if drop_type == 1:
			var forward = rot3.basis.xform(Vector3(0,0,-1))
			var be = 0.0
			if forward.y > 0.0:
				be = 1.0 - abs(forward.y)/10
			else:
				be = 1.0+abs(forward.y)
			forward.x /= be
			forward.z /= be
			force_vec3 = forward*drop_speed
		if drop_type == 2:
			force_vec3 *= drop_speed/6
		yield(get_tree().create_timer(drop_time),"timeout")
		drop = false
		move_pos3 = force_vec3
#		Overall.player_node.connect("entered_player",self,"_on_entered_player")
#	else:
#		Overall.player_node.connect("entered_player",self,"_on_entered_player")

func _on_free_timeout() -> void:
	if free:return
	queue_free()
func _on_msg_around_timeout() -> void:
	if Net.is_master():
		var anis = Overall.terrain_node_node.get_around(translation,Vector3(5,1,5),CollisionGroup.LAYER.animal)
		for node in anis:
			node.collider._on_near_item(self)
func _on_entered_player(obj) -> void:
	if free:return
	if Net.is_master():
		obj.pick_up(name_,num,hp)
	queue_free()
		
func queue_free() -> void:
	if free:return
	if Net.is_master():
		Overall.terrain_node_node.rpc0(name,"queue_free")
	free = true
	.queue_free()
func get_global_block_pos3(pos3:Vector3) -> Vector3:
	return translation


func _process(delta:float) -> void:
	free_time += delta
	check_time += delta
	msg_around_time += delta
	if free_time > free_time_max:
		_on_free_timeout()
		return
	if check_time > check_time_max:
		check_time = 0.0
		_on_check_timeout()
	if msg_around_time > msg_around_time_max:
		msg_around_time = 0.0
		_on_msg_around_timeout()
#	rotation = Vector3(rand_range(-PI, PI), rand_range(-PI, PI), rand_range(-PI, PI))
	var be = delta*3

	if drop:
		force_vec3.x /= 1+be
		force_vec3.z /= 1+be
		if force_vec3.y > 0.1:
			force_vec3.y /= 1+be*2
		force_vec3.y -= g
		var force_vec3_ = box.get_motion(get_translation(),force_vec3*delta, aabb,Overall.terrain_main_node)
		move_and_slide(force_vec3_/delta,Vector3(0,0,0),false,3,0.785398,false)
		if is_on_floor():force_vec3.y = 0
		$node.rotate_x(delta*abs(force_vec3.y))
		$node.rotate_z(delta*abs(force_vec3.y))
		return

	if enter:
		var obj_tran = obj.translation
		obj_tran.y += 1
		move_pos3 = translation.direction_to(obj_tran)*(pick_move/translation.distance_to(obj_tran))
	else:

		move_pos3.x /= 1+delta
		move_pos3.z /= 1+delta
		if move_pos3.y > 0.1:
			move_pos3.y /= 1+be*2
		move_pos3.y -= g
		
	var move_pos3_ = box.get_motion(get_translation(), move_pos3*delta, aabb,Overall.terrain_main_node)
	
	move_and_slide(move_pos3_/delta,Vector3(0,0,0),false,3,0.785398,false)
	var is_floor = is_on_floor()
	if  is_floor && !enter:
		move_pos3.x/= 1+be
		move_pos3.z/= 1+be
		move_pos3.y = 0
	if !is_floor:
		$node.rotate_x(delta*abs(move_pos3.y))
		$node.rotate_z(delta*abs(move_pos3.y))
#			move_pos3.y = jump_distance

	
	if enter:
		var obj_ = Overall.terrain_node_node.check_player(translation,Vector3(0.2,0.2,0.2))
		if obj_:
			_on_entered_player(obj_)
	
func is_on_floor() -> bool:
	var pos3_ = box.get_motion(get_translation(), Vector3(0,-1,0), aabb,Overall.terrain_main_node)
	if abs(pos3_.y) < 0.01:
		return true
	return .is_on_wall()

var pos3 = translation
func _on_check_timeout() -> void:
	pos3 = translation
	var obj = Overall.terrain_node_node.check_player(translation,Vector3(2,1.5,2))
	if obj:
		enter = true
		self.obj = obj
	else:
		enter = false
		self.obj = null

	
	if Overall.terrain_node_node.check_collider(translation,Vector3(0.5,0.5,0.5),CollisionGroup.DROP):
		for vec in Config.VEC_ORDER:
			if !Overall.terrain_node_node.check_collider(translation+vec,Vector3(0.5,0.5,0.5),CollisionGroup.DROP):
				move_pos3 += vec*2
				if vec.y > 0:
					move_pos3.y += vec.y*2
				return
