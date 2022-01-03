extends GeneratorBase

var flax
var grass
func _init() -> void:
	flax = Block.get("flax_ripe").id
	grass = Block.get("grass").id
func create(buffer:VoxelBuffer, cpos3:Vector3,l_pos2:Dictionary,noises:Array,plain:String) -> void:
	var pros = [1000,20,1]
	var data = noises[0][cpos3.x][cpos3.z][cpos3.y]
	if random(data,pros):
		create_flax(buffer,l_pos2,data,plain)
	pros = [1100,10,6]
	if random(data,pros):
		create_grass(buffer,l_pos2,data,plain)
func create_flax(buffer:VoxelBuffer,l_pos2:Dictionary,data:float,plain:String) -> void:
	var lx = abs(int(data*200)%16)
	var lz = abs(int(data*400)%16)
	var ly = l_pos2[Vector2(lx,lz)]
	if ly >= 0:
		var height = 1
		for y in range(height):
			if ly+y <16:
				var width = 1
				for xx in range(width):
					if lx+xx <16:
						for zz in range(width):
							if lz+zz <16:
								buffer.set_voxel_v(flax,Vector3(lx+xx,ly+y,lz+zz),channel)
func create_grass(buffer:VoxelBuffer,l_pos2:Dictionary,data:float,plain:String) -> void:
	var lx = abs(int(data*200)%16)
	var lz = abs(int(data*400)%16)
	var ly = l_pos2[Vector2(lx,lz)]
	if ly >= 0:
		var height = 1
		for y in range(height):
			if ly+y <16:
				var width = 1
				for xx in range(width):
					if lx+xx <16:
						for zz in range(width):
							if lz+zz <16:
								buffer.set_voxel_v(grass,Vector3(lx+xx,ly+y,lz+zz),channel)
