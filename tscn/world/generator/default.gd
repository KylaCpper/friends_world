extends VoxelGeneratorScript

var heightmap := preload("res://tscn/world/generator/default.tres")

var water_y := 0


var air := 0
var grass_dirt :int 
var dirt :int
var stone :int
var copper_ore :int
var coal_ore :int
var water :int
var sand :int
var grass :int
var flax :int
var gravel :int
var clay :int

const _CHANNEL = VoxelBuffer.CHANNEL_TYPE

const _moore_dirs = [
	Vector3(0, 0, 0),
	Vector3(-1, 0, -1),
	Vector3(0, 0, -1),
	Vector3(1, 0, -1),
	Vector3(-1, 0, 0),
	Vector3(1, 0, 0),
	Vector3(-1, 0, 1),
	Vector3(0, 0, 1),
	Vector3(1, 0, 1)
]


var trees := []

var heightmap_min_y := int(heightmap.min_value)
var heightmap_max_y := int(heightmap.max_value)
var heightmap_range := 0
var noise := Terrain.noise
var trees_min_y := 0
var trees_max_y := 0
func _init():
	grass_dirt = Block.get("grass_dirt").id
	dirt = Block.get("dirt").id
	stone = Block.get("stone").id
	copper_ore = Block.get("copper_ore").id
	coal_ore = Block.get("coal_ore").id
	water = Block.get("water").id
	sand = Block.get("sand").id
	grass = Block.get("grass").id
	flax = Block.get("flax_ripe").id
	gravel = Block.get("gravel").id
	clay = Block.get("clay").id
	trees_min_y = heightmap_min_y
	trees_max_y = heightmap_max_y + 15
	heightmap.bake()


func _get_used_channels_mask() -> int:
	return 1 << _CHANNEL


func generate(buffer: VoxelBuffer, cpos3: Vector3):
	buffer.set_channel_depth(_CHANNEL, VoxelBuffer.DEPTH_16_BIT)
	# Assuming input is cubic in our use case (it doesn't have to be!)
	var oy := int(cpos3.y)
	# TODO This hardcodes a cubic block size of 16, find a non-ugly way...
	# Dividing is a false friend because of negative values
	var chunk_pos := Vector3(
		int(cpos3.x) >> 4,
		int(cpos3.y) >> 4,
		int(cpos3.z) >> 4)
	#/16
	heightmap_range = heightmap_max_y - heightmap_min_y
	# Ground

	if cpos3.y > heightmap_max_y:
		buffer.fill(air, _CHANNEL)
	elif cpos3.y + 16 < heightmap_min_y:
		buffer.fill(stone, _CHANNEL)
		
		var rng := RandomNumberGenerator.new()
		rng.seed = _get_chunk_seed_2d(chunk_pos)
		var r = rng.randf()
		if r < 0.1:
			for i in rng.randi()%20:
				buffer.set_voxel(copper_ore,rng.randi()%16,rng.randi()%16,rng.randi()%16)
		elif r < 0.2:
			for i in rng.randi()%20:
				buffer.set_voxel(coal_ore,rng.randi()%16,rng.randi()%16,rng.randi()%16)
				#	var t = 32.0+64*_heightmap_noise.get_noise_2d(x, z)
				#	print(t)
				#	return int(t)
#					return int(heightmap.interpolate_baked(t))
#			var vec = Vector3(rng.randi_range(0,15), rng.randi_range(0,15), rng.randi_range(0,15))
#			var aabb := AABB(vec, vec+Generator.copper_ore_moudels[0].size + Vector3(1, 1, 1))
#			if aabb.intersects(AABB(Vector3(0,0,0),Vector3(15,15,15))):
#				buffer.fill_area(copper_ore,aabb.position, aabb.size+Vector3(1,1,1), _CHANNEL)
##				buffer.set_voxel(grass_dirt, x, relative_height - 1, z, _CHANNEL)

	else:
		var rng := RandomNumberGenerator.new()
		rng.seed = _get_chunk_seed_2d(chunk_pos)
		var r_big = rng.randf()
		var gx : int
		var gz := int(cpos3.z)

		for z in 16:
			gx = int(cpos3.x)

			for x in 16:
				var height := _get_height_at(gx, gz)
				var relative_height := height - oy
				
				# Dirt and grass
				#地下
				if relative_height > 16:
					buffer.fill_area(dirt,
						Vector3(x, 0, z), Vector3(x + 1, 16, z + 1), _CHANNEL)
					buffer.fill_area(stone,
						Vector3(x, 0, z), Vector3(x + 1, 10, z + 1), _CHANNEL)
					
					if r_big < 0.1:
						for i in rng.randi()%20:
							buffer.set_voxel(coal_ore,x,rng.randi()%8,z)
					elif r_big < 0.15:
						for i in rng.randi()%20:
							buffer.set_voxel(copper_ore,x,rng.randi()%8,z)
				#上方空气
				elif relative_height > 0:
					buffer.fill_area(dirt,
						Vector3(x, 0, z), Vector3(x + 1, relative_height, z + 1), _CHANNEL)
					#海平面上
					if height > 0:
						buffer.set_voxel(grass_dirt, x, relative_height - 1, z, _CHANNEL)
						if relative_height < 16 and rng.randf() < 0.2:
							var foliage = grass
							if rng.randf() < 0.1:
								foliage = flax
							buffer.set_voxel(foliage, x, relative_height, z, _CHANNEL)
					#海平面
					if height == 0:
						var r = rng.randf()
						if r < 0.1:
							buffer.set_voxel(gravel, x, relative_height-1, z, _CHANNEL)
						else:
							buffer.set_voxel(sand, x, relative_height-1, z, _CHANNEL)
					#海平面下
					if height < 0:
						var r = rng.randf()
						if r < 0.1:
							buffer.set_voxel(gravel, x, relative_height-1, z, _CHANNEL)
						elif r < 0.2:
							buffer.set_voxel(dirt, x, relative_height-1, z, _CHANNEL)
						elif r < 0.3:
							buffer.set_voxel(clay, x, relative_height-1, z, _CHANNEL)
						else:
							buffer.set_voxel(sand, x, relative_height-1, z, _CHANNEL)
					#海平面下
#					if height < 0:
#						buffer.set_voxel(water, x, relative_height-1, z, _CHANNEL)
#				if height == 1:
#					if oy == 0:
##						if rng.randi_range(0,9)>4:
#						buffer.set_voxel(sand, x, 0, z, _CHANNEL)
#					if oy == -16:
#						buffer.set_voxel(sand, x, relative_height-1, z, _CHANNEL)
				# 海平面下
				if height < 0 and oy < 0:
					var start_relative_height := 0
					if relative_height > 0:
						start_relative_height = relative_height
					buffer.fill_area(water,
						Vector3(x, start_relative_height, z), 
						Vector3(x + 1, 16, z + 1), _CHANNEL)
					#海最上层
					if oy + 16 == 0:
						pass
#						buffer.set_voxel(WATER_TOP, x, 16 - 1, z, _CHANNEL)
						
				gx += 1

			gz += 1

	# Trees

	if cpos3.y <= trees_max_y and cpos3.y + 16 >= trees_min_y:
		var voxel_tool := buffer.get_voxel_tool()
		var structure_instances := []
			
#		_get_tree_instances_in_chunk(cpos3, structure_instances)
	
		# Relative to current block
		var block_aabb := AABB(Vector3(), Vector3(17,17,17))
		
		_get_tree_instances_in_chunk(cpos3, structure_instances)

		for structure_instance in structure_instances:
			var pos : Vector3 = structure_instance[0]
			var structure = structure_instance[1]
			var lower_corner_pos = pos - structure.offset
			var aabb := AABB(lower_corner_pos, structure.voxels.get_size() + Vector3(1, 1, 1))

			if aabb.intersects(block_aabb):
				voxel_tool.paste(lower_corner_pos, 
					structure.voxels, 0, air)

	buffer.optimize()


func _get_tree_instances_in_chunk(
	cpos3: Vector3, tree_instances: Array):
	for offset in _moore_dirs:
		var chunk_pos3 := Vector3(
			int(cpos3.x) >> 4,
			int(cpos3.y) >> 4,
			int(cpos3.z) >> 4)
		chunk_pos3 = (chunk_pos3 + offset).round()
		var rng := RandomNumberGenerator.new()
		rng.seed = _get_chunk_seed_2d(chunk_pos3)
		for i in 4:
			var pos := Vector3(rng.randi() % 16, 0, rng.randi() % 16)
			pos += chunk_pos3 * 16
			pos.y = _get_height_at(pos.x, pos.z)
			
			if pos.y > 0:
				pos -= cpos3
				var si := rng.randi() % 10
				var structure = Generator.tree_models[si]
				tree_instances.append([pos.round(), structure])


#static func get_chunk_seed(cpos: Vector3) -> int:
#	return cpos.x ^ (13 * int(cpos.y)) ^ (31 * int(cpos.z))


static func _get_chunk_seed_2d(cpos: Vector3) -> int:
	return int(cpos.x) ^ (31 * int(cpos.z))


func _get_height_at(x: int, z: int) -> int:
#	return int(_heightmap_noise.get_noise_2d(x,z))
#	-32 96 128
	var t = 0.5+0.5*noise.get_noise_2d(x,z)
#	var t = 32.0+64*_heightmap_noise.get_noise_2d(x, z)
#	print(t)
#	return int(t)
	return int(heightmap.interpolate_baked(t))
