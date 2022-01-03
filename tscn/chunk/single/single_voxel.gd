extends "res://lib/voxel/src/voxel_obj.gd"
#class_name Chunk

# Declarations
var voxels := {}
# Core
#func _load() -> void:
#	._load()
#	if has_meta('voxels'): voxels = get_meta('voxels')

func _save() -> void:
	._save()
	
	set_meta('voxels', voxels)


#func _init() -> void:
#	_load()
func _ready() -> void:
#	set_voxel_set_path(VoxelSetPath, false, false)
#	_load()
	voxels = {}
#	Overall.chunk_node = self
#	for x in range(32):
#		for z in range(32):
#			for y in range(32):
#				voxels[Vector3(x,y,z)]={"color":Color(1,1,1)}
#	update()
#	emit_signal("done")

func set_voxel_from_name(vec3:Vector3,name_,update:=true) -> void:
	var voxel = VoxelSet.Voxels[name_]
	if !voxel:voxel = VoxelSet.Voxels["default"]
	set_voxel(vec3,voxel)
	if update:
		update()
func get_rvoxel(grid : Vector3):
	return voxels.get(grid)

func get_voxels() -> Dictionary:
	return voxels.duplicate(true)


func set_voxel(grid : Vector3, voxel, update := false) -> void:
	if voxel:
		voxels[grid] = voxel
	else:
		voxels.erase(grid)
	.set_voxel(grid, voxel, update)

func set_voxels(_voxels : Dictionary, update := true) -> void:
	erase_voxels(false)
	
	voxels = _voxels.duplicate(true)
	if update: update()


func erase_voxel(grid : Vector3, update := false) -> void:
	voxels.erase(grid)
	.erase_voxel(grid, update)

func erase_voxels(update : bool = true) -> void:
	voxels.clear()
	if update: update()



func update() -> void:
	var _material := get_surface_material(0) if get_surface_material_count() > 0 else null
	var ST := SurfaceTool.new()
	ST.begin(Mesh.PRIMITIVE_TRIANGLES)
	var chunk = $"../".chunk * Vector3(16,16,16)
	if $"../".name_:
		if Item.get($"../".name_).model:return
	var voxel = VoxelSet.Voxels[$"../".name_]
	var dire = $"../".dire
	if $"../".par:
		var offset = get_offset()
		Voxel_.generate_left_with_uv(ST, voxel, Vector3(0,0,0),dire,offset)
		Voxel_.generate_right_with_uv(ST, voxel, Vector3(0,0,0),dire,offset)
		Voxel_.generate_up_with_uv(ST, voxel, Vector3(0,0,0),dire,offset)
		Voxel_.generate_down_with_uv(ST, voxel, Vector3(0,0,0),dire,offset)
		Voxel_.generate_back_with_uv(ST, voxel, Vector3(0,0,0),dire,offset)
		Voxel_.generate_forward_with_uv(ST, voxel, Vector3(0,0,0),dire,offset)
	else:
		Voxel_.generate_left_with_uv(ST, voxel, Vector3(0,0,0),dire)
		Voxel_.generate_right_with_uv(ST, voxel, Vector3(0,0,0),dire)
		Voxel_.generate_up_with_uv(ST, voxel, Vector3(0,0,0),dire)
		Voxel_.generate_down_with_uv(ST, voxel, Vector3(0,0,0),dire)
		Voxel_.generate_back_with_uv(ST, voxel, Vector3(0,0,0),dire)
		Voxel_.generate_forward_with_uv(ST, voxel, Vector3(0,0,0),dire)

	ST.index()
	mesh = ST.commit()
#		mesh.surface_set_name(0, 'voxels')
#		set_surface_material(0, _material)

#	update_static_body()
#	update_static_body()

#	_save()
static func get_offset() -> Vector2:
	var x = Function.rand(5)*0.2
	var y = Function.rand(5)*0.2
	return Vector2(x,y)
func update_static_body() -> void:
	var staticbody
	if has_node('StaticBody'): staticbody = get_node('StaticBody')
	
	if BuildStaticBody && mesh:
		var collisionshape
		if !staticbody:
			staticbody = StaticBody.new()
			staticbody.set_name('StaticBody')
		
		if staticbody.has_node('CollisionShape'):
			collisionshape = staticbody.get_node('CollisionShape')
		else:
			collisionshape = CollisionShape.new()
			collisionshape.set_name('CollisionShape')
			staticbody.add_child(collisionshape)
		
		collisionshape.shape = mesh.create_trimesh_shape()
		
		if !has_node('StaticBody'): add_child(staticbody)
		
		if BuildStaticBody and not staticbody.owner: staticbody.set_owner(get_tree().get_edited_scene_root())
		elif not BuildStaticBody and staticbody.owner: staticbody.set_owner(null)
		if BuildStaticBody and not collisionshape.owner: collisionshape.set_owner(get_tree().get_edited_scene_root())
		elif not BuildStaticBody and staticbody.owner: collisionshape.set_owner(null)
	elif staticbody and !mesh:
		var collisionshape = staticbody.get_node('CollisionShape')
		if collisionshape:
			collisionshape.queue_free()
	
