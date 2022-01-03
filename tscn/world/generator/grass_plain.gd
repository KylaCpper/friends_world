extends GeneratorBase


# x - +
# z -
#   +
# -1 在地下
# -2 在中间
var height := preload("res://tscn/world/generator/default.tres")

var water_y := 0



var grass_dirt :int 
var dirt :int
var stone :int
var water :int
var sand :int
var grass :int
var flax :int
var gravel :int
func _init():
	grass_dirt = Block.get("grass_dirt").id
	dirt = Block.get("dirt").id
	stone = Block.get("stone").id
	water = Block.get("water").id
	sand = Block.get("sand").id
	grass = Block.get("grass").id
	flax = Block.get("flax_ripe").id
	gravel = Block.get("gravel").id
	a = VoxelBuffer.new()
	a.create(5,5,5)
	a.set_voxel(grass_dirt,0,0,0,channel)
	a.set_voxel(grass_dirt,1,1,1,channel)
	a.set_voxel(grass_dirt,2,2,2,channel)
	a.set_voxel(grass_dirt,3,3,3,channel)
	a.set_voxel(grass_dirt,4,4,4,channel)
	
var a :VoxelBuffer
func generate(buffer:VoxelBuffer, cpos3:Vector3):
	
	
	var rand = RandomNumberGenerator.new()
	rand.seed = int(noise.get_noise_2d(cpos3.x,cpos3.z)*99999)
	var dirt_h = rand.randi()%4
	var sand_h = rand.randi()%4
	var rand_1 = rand.randi()%4096
	var tops_pos := {}
	if cpos3.y > -32:
		for lx in range(16):
			for lz in range(16):
				var rand_256 = rand.randi()%4096
				tops_pos[[lx,lz]] = -1
				var offset = Vector3(lx,16,lz)
				var bpos3 = cpos3 + offset
#				var y = get_height(noise.get_noise_2d(bpos3.x,bpos3.z))
				var y = int(noise.get_noise_2d(bpos3.x,bpos3.z)*20)
				for ly in range(16):
					ly = 15 - ly
					bpos3.y -= 1
					var yy = bpos3.y - y
					if yy <= 0:
						#地下
						if yy == 0:
							#表面
									
							if ly+1 <16:
								tops_pos[[lx,lz]] = ly+1
							buffer.set_voxel(grass_dirt,lx,ly,lz,channel)
							if bpos3.y <= water_y:
								#海平面下
								#sand and gravel
								tops_pos[[lx,lz]] = -1
								var id = sand
								if bpos3.y < water_y:
									if rand_256%5 < 1:id = gravel
								else:
									if rand_256%10 < 1:id = gravel
								var sand_y_min = ly - sand_h
								if sand_y_min<0:sand_y_min = 0
								var sand_y_max = ly+1
								buffer.fill_area(id,Vector3(lx,sand_y_min,lz),Vector3(lx+1,sand_y_max,lz+1),channel)
								if sand_y_min != 0:
									buffer.fill_area(id,Vector3(lx,0,lz),Vector3(lx+1,sand_y_min+1,lz+1),channel)
							else:
								#海平面上
								var dirt_y_min = ly - dirt_h
								if dirt_y_min<0:dirt_y_min = 0
								var dirt_y_max = ly
								buffer.fill_area(dirt,Vector3(lx,dirt_y_min,lz),Vector3(lx+1,dirt_y_max,lz+1),channel)
								if dirt_y_min>0:
									buffer.fill_area(stone,Vector3(lx,0,lz),Vector3(lx+1,dirt_y_min,lz+1),channel)
							
							if tops_pos[[lx,lz]] >= 0:
								#草地上
								if ly+1 < 16:
									#草地上一个空格
									#grass
									if rand_256%16 < 1:
										buffer.set_voxel(grass,lx,ly+1,lz,channel)
									#flax
									if rand_256%512 < 1:
										buffer.set_voxel(flax,lx,ly+1,lz,channel)

							break
						else:
							#表面下
							buffer.fill_area(stone,Vector3(lx,0,lz),Vector3(lx+1,16,lz+1),channel)
							break
					else:
						#地上
						if bpos3.y <= water_y:
							#海平面下
							#water
							tops_pos[[lx,lz]] = -1
							if yy <= ly:
								buffer.fill_area(water,Vector3(lx,ly-yy,lz),Vector3(lx+1,ly+1,lz+1),channel)
							else:
								break
								
								
								
		#可能在地上
		#tree
		var block_aabb := AABB(Vector3(),Vector3(16,16,16))
		var tree_index = rand_1%10
		for i in range(rand.randi()%7):
			var offset = Vector3(rand.randi()%16,0,rand.randi()%16)-Generator.tree_models[tree_index].center
			if offset.x >= 0 && offset.z >= 0:
				offset.y = tops_pos[[int(offset.x),int(offset.z)]]
				if offset.y >=0:
					var aabb := AABB(offset,Generator.tree_models[tree_index].size)
					if aabb.intersects(block_aabb):
						buffer.get_voxel_tool().paste(cpos3+offset,Generator.tree_models[tree_index].voxels,0,0)
#			if tops_pos[[int(offset.x),int(offset.z)]] >= 0:
#				buffer.get_voxel_tool().paste(cpos3/16,Generator.tt[tree_index],0)
#			var center = Generator.tree_models[tree_index].center
#			var voxels = Generator.tree_models[tree_index].voxels
#			var size = Generator.tree_models[tree_index].size
#			offset.y = tops_pos[[int(offset.x),int(offset.z)]]
#			var oy = offset.y + size.y
#			if oy <= 16:
#				if offset.y >= 0:
#					for lx in range(16):
#						for lz in range(16):
#							for ly in range(16):
#								var bp = Vector3(lx,ly,lz)
#								if bp.x < size.x && bp.y < size.y && bp.z < size.z:
#									var lp = Vector3(lx,ly,lz) + offset - center
#									if lp.x >= 0 && lp.y >= 0 && lp.z >= 0:
#										if lp.x < 16 && lp.y < 16 && lp.z < 16:
#											if Vector3(bp.x,bp.y,bp.z) in voxels:
#												var id = voxels[Vector3(bp.x,bp.y,bp.z)]
#												buffer.set_voxel(id,lp.x,lp.y,lp.z,channel)
	else:
		#肯定在地下
		buffer.fill(stone,channel)
		if cpos3.y >= -72:
			create_ore(Generator.coal_ore_models,cpos3,rand,buffer)
#	buffer.get_voxel_tool().paste(cpos3/16,a,0)
#	rand = RandomNumberGenerator.new()

#	rand.seed = int(noise.get_noise_2d(cpos3.x,cpos3.z)*99999)
	
	#other
#	for i in range(rand.randi()%3):
	#coal
	

func create_ore(models:Array,cpos3:Vector3,rand:RandomNumberGenerator,buffer:VoxelBuffer) -> void:
	var offset = Vector3(rand.randi()%10,rand.randi()%10,rand.randi()%10)
	var model_index = rand.randi()%7
	var voxels = models[model_index].voxels
	var size = models[model_index].size
	if offset.x + size.x <= 16 && offset.z + size.z <= 16 && offset.y + size.y <= 16:
		for lx in range(size.x):
			for lz in range(size.z):
				for ly in range(size.y):
					var bp = Vector3(lx,ly,lz)
					var lp = Vector3(lx,ly,lz) + offset
					if Vector3(bp.x,bp.y,bp.z) in voxels:
						var id = voxels[Vector3(bp.x,bp.y,bp.z)]
						buffer.set_voxel(id,lp.x,lp.y,lp.z,channel)


func get_height(data:float) -> int:
	return int(height.interpolate(0.5+0.5*data))
