extends Spatial

const GRAVITY = Vector3(0, -9.8, 0)
const LIFETIME = 3.0

var _scale = Vector3(0.05,0.05,0.05) 

onready var _terrain : VoxelTerrain = Overall.terrain_main_node
onready var _terrain_tool := _terrain.get_voxel_tool()

var name_ := ""
var _velocity := Vector3()
var _rotation_axis := Vector3()
var _angular_velocity := 4.0 * TAU * rand_range(-1.0, 1.0)
var _remaining_time := rand_range(0.5, 1.5) * LIFETIME


func _ready():
	Overall.par_num += 1
	$single.scale = _scale
	var block = Block.get(name_)
	$single/single.hide()
	$single/model.hide()
	
	if block:
		if !block.model:
			$single/single._show(name_)
		else:
			$single/model.mesh = block.model
			$single/model.show()
			$single/model.material_override = load("res://tscn/world/terrain"+str(block.material)+".tres")
	else:
		queue_free()
#	var texture = Overall.photograph_node.get_texture("grass_block")
#	$model.material_override.albedo_texture = texture
	rotation = Vector3(rand_range(-PI, PI), rand_range(-PI, PI), rand_range(-PI, PI))
	scale = Vector3(rand_range(0.7, 1.2), rand_range(0.7, 1.2), rand_range(0.7, 1.2))
	_rotation_axis = \
		Vector3(rand_range(-PI, PI), rand_range(-PI, PI), rand_range(-PI, PI)).normalized()

func _scale(val:float):
	_scale *= val

func set_velocity(vec: Vector3):
	_velocity = vec


func _process(delta: float):
	_remaining_time -= delta
	if _remaining_time <= 0:
		queue_free()
		return

	_velocity += GRAVITY * delta

	var trans := transform
	
	trans.basis = trans.basis.rotated(_rotation_axis, _angular_velocity * delta)
	
	var motion := _velocity * delta
	var hit := _terrain_tool.raycast(trans.origin, motion.normalized(), motion.length() * 1.01,CollisionGroup.IGNORE_LIQUID)
	if hit != null:
		# BOUNCE
		var normal = hit.previous_position - hit.position
		_velocity = _velocity.bounce(normal)
		# Damp on impact
		_velocity *= 0.2
		_angular_velocity *= 0.2
	
	trans.origin += _velocity * delta
#	var move_vec =  _velocity * delta
#	move_and_slide(move_vec/delta,Vector3(0,1,0))
	transform = trans

func queue_free() -> void:
	.queue_free()
	Overall.par_num -= 1
