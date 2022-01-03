extends KinematicBody
var vec3 := Vector3(0,0,0)
var name_ := ""
var __fall__ := true
var free := false
var dire := 0
var block := {}
var box := VoxelBoxMover.new()
var aabb = AABB(Vector3(0, 0, 0), Vector3(1, 1, 1))
var client := false
func _ready() -> void:
#	move_lock_x = true
#	move_lock_z = true
	if !Net.is_master():client = true
	CollisionGroup.collision(self,"gravity")
	box.set_collision_mask(CollisionGroup.VOXEL_LAYER.gravity)
	block = Block.get(name_)
	if block.model:
		$model.mesh = block.model
		$model.material_override = load("res://tscn/world/terrain"+str(block.material)+".tres")
		$model.show()
		$single.hide()
		$single.queue_free()
	else:
		$single._show(name_,dire)
		$model.hide()
		$model.queue_free()
var time := 0.0
var hurt_time := 0.3
var damage_num := 0
func _process(delta:float) -> void:
	if free: return
	time += delta
	if time > 30:
		free = true
		queue_free()
		return
	var mass = block.mass
	vec3.y -= delta*Config.gravity*(1.0+mass/2)
	if -vec3.y > mass*Config.gravity:
		vec3.y = - mass*Config.gravity
	var vec3_ = box.get_motion(get_translation(),vec3*delta, aabb,Overall.terrain_main_node)
	move_and_slide(vec3_/delta,Vector3(0,-1,0))
	if is_on_floor():
#		var player_obj = Overall.terrain_node_node.collide_player(translation+Vector3(0.5,0.5,0.5)+Vector3(0.0,-0.7,0.0),Vector3(0.5,0.1,0.5))
		var player_obj = Overall.terrain_node_node.collide_player(translation-Vector3(0.0,1.0,0.0),Vector3(1.0,0.1,1.0))
		if player_obj:
			hurt_time += delta
			if hurt_time > 0.3:
				hurt_time = 0.0
				player_obj.fall_hurt(vec3.y)
			vec3.y = 0.0
#			time += 0.1
		else:
			if client:
				free = true
				queue_free()
				Overall.audio_node.fall(name_,translation)
				return
			var obj := move_and_collide(Vector3(0,-0.1,0))
			if obj:
				if obj.collider:
					if obj.collider.has_method("add_force"):
						obj.collider.add_force(vec3.y*block.mass)
						return
			var translation_be = translation+Vector3(0,0.5,0)
			var block_name = Overall.terrain_main_node.get_name_(translation_be)
			var block = Block.get(block_name)
			if block:
				if block.liquid:
					translation.y -= 0.1
					vec3.y /= 3
				else:
					free = true
					queue_free()
					Overall.audio_node.fall(name_,translation)
					Overall.terrain_main_node.set_voxel(translation_be,self.block.id+dire)
					Overall.terrain_main_node.create_fall_drop(translation_be,block_name)

			else:
				damage_num = damage_num + 1
				var force = Overall.terrain_main_node.place_fall(translation_be,name_,dire,-vec3.y)
				if force <= 0.0 || damage_num == 2+ceil(self.block.intensity/2):
					free = true
					queue_free()
					Overall.audio_node.fall(name_,translation)
				vec3.y = -force 
				
	

#		move_and_collide(vec3_)
		
func add_force(force:float):
	vec3.y += force
	
	
func is_on_floor() -> bool:
	var pos3_ = box.get_motion(get_translation(), Vector3(0,-1,0), aabb,Overall.terrain_main_node)
	if abs(pos3_.y) < 0.01:
		return true
	return .is_on_floor()
