extends "res://lib/voxel/src/voxel_obj.gd"
class_name Chunk


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
	var chunk_pos3 = $"../".chunk_pos3 * 16

	for x in range(1,15):
		for z in range(1,15):
			for y in range(16):
				var voxel_grid = Vector3(x,y,z) + chunk_pos3
				if Terrain.map[voxel_grid]:
#						var voxel = voxels[voxel_grid]
					var voxel = VoxelSet.Voxels[Terrain.map[voxel_grid]]
					
					if !Terrain.map[(voxel_grid + Vector3.LEFT)]:
						Voxel_.generate_left_with_uv(ST, voxel, voxel_grid,false)
#						pass
					if !Terrain.map[(voxel_grid + Vector3.RIGHT)]:
						Voxel_.generate_right_with_uv(ST, voxel, voxel_grid,false)
						pass
					if !Terrain.map[(voxel_grid + Vector3.UP)]: 
						Voxel_.generate_up_with_uv(ST, voxel, voxel_grid,false)
						pass
					if !Terrain.map[(voxel_grid + Vector3.DOWN)]: 
						Voxel_.generate_down_with_uv(ST, voxel, voxel_grid,false)
						pass
					if !Terrain.map[(voxel_grid + Vector3.BACK)]: 
						Voxel_.generate_back_with_uv(ST, voxel, voxel_grid,false)
						pass
					if !Terrain.map[(voxel_grid + Vector3.FORWARD)]: 
						Voxel_.generate_forward_with_uv(ST, voxel, voxel_grid,false)
						pass
	
#left
	for z in range(16):
		for y in range(16):
			var voxel_grid = Vector3(0,y,z) + chunk_pos3
			if Terrain.map.has(voxel_grid):
				if Terrain.map[voxel_grid]:
					var voxel = VoxelSet.Voxels[Terrain.map[voxel_grid]]
					Voxel_.generate_left_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map.has(voxel_grid + Vector3.RIGHT): 
							Voxel_.generate_right_with_uv(ST, voxel, voxel_grid,false)
					else:	
						if !Terrain.map[(voxel_grid + Vector3.RIGHT)]: 
							Voxel_.generate_right_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map[(voxel_grid + Vector3.UP)]: 
						Voxel_.generate_up_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map[(voxel_grid + Vector3.DOWN)]: 
						Voxel_.generate_down_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map.has(voxel_grid + Vector3.BACK): 
							Voxel_.generate_back_with_uv(ST, voxel, voxel_grid,false)
					else:
						if !Terrain.map[(voxel_grid + Vector3.BACK)]: 
							Voxel_.generate_back_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map.has(voxel_grid + Vector3.FORWARD): 
							Voxel_.generate_forward_with_uv(ST, voxel, voxel_grid,false)
					else:
						if !Terrain.map[(voxel_grid + Vector3.FORWARD)]: 
							Voxel_.generate_forward_with_uv(ST, voxel, voxel_grid,false)
#right
	for z in range(16):
		for y in range(16):
			var voxel_grid = Vector3(15,y,z) + chunk_pos3
			if Terrain.map.has(voxel_grid):
				if Terrain.map[voxel_grid]:
					var voxel = VoxelSet.Voxels[Terrain.map[voxel_grid]]
					if !Terrain.map.has(voxel_grid + Vector3.LEFT): 
						Voxel_.generate_left_with_uv(ST, voxel, voxel_grid,false)
					else:
						if !Terrain.map[(voxel_grid + Vector3.LEFT)]:
							Voxel_.generate_left_with_uv(ST, voxel, voxel_grid,false)

					Voxel_.generate_right_with_uv(ST, voxel, voxel_grid,false)

					if !Terrain.map[(voxel_grid + Vector3.UP)]: 
						Voxel_.generate_up_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map[(voxel_grid + Vector3.DOWN)]: 
						Voxel_.generate_down_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map.has(voxel_grid + Vector3.BACK): 
							Voxel_.generate_back_with_uv(ST, voxel, voxel_grid,false)
					else:
						if !Terrain.map[(voxel_grid + Vector3.BACK)]: 
							Voxel_.generate_back_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map.has(voxel_grid + Vector3.FORWARD): 
							Voxel_.generate_forward_with_uv(ST, voxel, voxel_grid,false)
					else:
						if !Terrain.map[(voxel_grid + Vector3.FORWARD)]: 
							Voxel_.generate_forward_with_uv(ST, voxel, voxel_grid,false)
#forward

	for x in range(16):
		for y in range(16):
			var voxel_grid = Vector3(x,y,0) + chunk_pos3
			if Terrain.map.has(voxel_grid):
				if Terrain.map[voxel_grid]:
					var voxel = VoxelSet.Voxels[Terrain.map[voxel_grid]]
					if !Terrain.map.has(voxel_grid + Vector3.LEFT): 
						Voxel_.generate_left_with_uv(ST, voxel, voxel_grid,false)
					else:
						if !Terrain.map[(voxel_grid + Vector3.LEFT)]:
							Voxel_.generate_left_with_uv(ST, voxel, voxel_grid,false)

					if !Terrain.map.has(voxel_grid + Vector3.RIGHT): 
							Voxel_.generate_right_with_uv(ST, voxel, voxel_grid,false)
					else:	
						if !Terrain.map[(voxel_grid + Vector3.RIGHT)]: 
							Voxel_.generate_right_with_uv(ST, voxel, voxel_grid,false)

					if !Terrain.map[(voxel_grid + Vector3.UP)]: 
						Voxel_.generate_up_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map[(voxel_grid + Vector3.DOWN)]: 
						Voxel_.generate_down_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map.has(voxel_grid + Vector3.BACK): 
							Voxel_.generate_back_with_uv(ST, voxel, voxel_grid,false)
					else:
						if !Terrain.map[(voxel_grid + Vector3.BACK)]: 
							Voxel_.generate_back_with_uv(ST, voxel, voxel_grid,false)

					Voxel_.generate_forward_with_uv(ST, voxel, voxel_grid,false)
#back

	for x in range(16):
		for y in range(16):
			var voxel_grid = Vector3(x,y,15) + chunk_pos3
			if Terrain.map.has(voxel_grid):
				if Terrain.map[voxel_grid]:
					var voxel = VoxelSet.Voxels[Terrain.map[voxel_grid]]
					if !Terrain.map.has(voxel_grid + Vector3.LEFT): 
						Voxel_.generate_left_with_uv(ST, voxel, voxel_grid,false)
					else:
						if !Terrain.map[(voxel_grid + Vector3.LEFT)]:
							Voxel_.generate_left_with_uv(ST, voxel, voxel_grid,false)

					if !Terrain.map.has(voxel_grid + Vector3.RIGHT): 
							Voxel_.generate_right_with_uv(ST, voxel, voxel_grid,false)
					else:	
						if !Terrain.map[(voxel_grid + Vector3.RIGHT)]: 
							Voxel_.generate_right_with_uv(ST, voxel, voxel_grid,false)	
					if !Terrain.map[(voxel_grid + Vector3.UP)]: 
						Voxel_.generate_up_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map[(voxel_grid + Vector3.DOWN)]: 
						Voxel_.generate_down_with_uv(ST, voxel, voxel_grid,false)
					Voxel_.generate_back_with_uv(ST, voxel, voxel_grid,false)
					if !Terrain.map.has(voxel_grid + Vector3.FORWARD): 
							Voxel_.generate_forward_with_uv(ST, voxel, voxel_grid,false)
					else:
						if !Terrain.map[(voxel_grid + Vector3.FORWARD)]: 
							Voxel_.generate_forward_with_uv(ST, voxel, voxel_grid,false)
				
	
	ST.index()
	mesh = ST.commit()
#		mesh.surface_set_name(0, 'voxels')
#		set_surface_material(0, _material)
#	call_deferred("update_static_body")


	if mesh:
		var staticbody = get_node('StaticBody')
		var collisionshape
		if staticbody.has_node('CollisionShape'):
			collisionshape = staticbody.get_node('CollisionShape')
		else:
			collisionshape = CollisionShape.new()
			collisionshape.set_name('CollisionShape')
			staticbody.add_child(collisionshape)
#			var col_shape = ConcavePolygonShape.new()
#			col_shape.set_faces(mesh.get_faces())
#			collisionshape.set_shape(col_shape)
#			create_concave_polygon_shape(mesh)
		collisionshape.shape = mesh.create_trimesh_shape()
#			collisionshape.shape = mesh.create_convex_shape()
#			if !has_node('StaticBody'): add_child(staticbody)
#			collisionshape.set_owner(self)
	#		if BuildStaticBody and not staticbody.owner: staticbody.set_owner(get_tree().get_edited_scene_root())
	#		elif not BuildStaticBody and staticbody.owner: staticbody.set_owner(null)
	#		if BuildStaticBody and not collisionshape.owner: collisionshape.set_owner(get_tree().get_edited_scene_root())
	#		elif not BuildStaticBody and staticbody.owner: collisionshape.set_owner(null)
#		else:
#			var collisionshape = staticbody.get_node('CollisionShape')
#			if collisionshape:
#				collisionshape.queue_free()

#	_save()


















func update_static_body() -> void:
	var staticbody = get_node('StaticBody')
	if mesh:
		var collisionshape
		if staticbody.has_node('CollisionShape'):
			collisionshape = staticbody.get_node('CollisionShape')
		else:
			collisionshape = CollisionShape.new()
			collisionshape.set_name('CollisionShape')
			staticbody.add_child(collisionshape)
		collisionshape.shape = mesh.create_trimesh_shape()
		
#		if !has_node('StaticBody'): add_child(staticbody)
		collisionshape.set_owner(self)
#		if BuildStaticBody and not staticbody.owner: staticbody.set_owner(get_tree().get_edited_scene_root())
#		elif not BuildStaticBody and staticbody.owner: staticbody.set_owner(null)
#		if BuildStaticBody and not collisionshape.owner: collisionshape.set_owner(get_tree().get_edited_scene_root())
#		elif not BuildStaticBody and staticbody.owner: collisionshape.set_owner(null)
	else:
		var collisionshape = staticbody.get_node('CollisionShape')
		if collisionshape:
			collisionshape.queue_free()
	
