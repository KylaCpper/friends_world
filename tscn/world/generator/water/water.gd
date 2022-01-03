extends GeneratorBase

var water
var sand
func _init() -> void:
	water = Block.get("water").id
	sand = Block.get("sand").id
func create(buffer:VoxelBuffer, cpos3:Vector3,l_pos2:Dictionary,noises:Array,plain:String) -> void:
	var data = noises[0][cpos3.x][cpos3.z][cpos3.y]
	if random(data,[600,20,1]):
		create_pool(buffer, cpos3,l_pos2,noises,plain)
	

func create_lake(buffer:VoxelBuffer, cpos3:Vector3,l_pos2:Dictionary,noises:Array,plain:String) -> void:
	pass
func create_pool(buffer:VoxelBuffer, cpos3:Vector3,l_pos2:Dictionary,noises:Array,plain:String) -> void:
	var data = noises[0][cpos3.x][cpos3.z][cpos3.y]
	var height = abs(int(data*500)%3)+1
	var width_x = abs(int(data*700)%6)+5
	var width_z = abs(int(data*650)%6)+5
	var lx = 3
	var lz = 3 
	if l_pos2[Vector2(lx,lz)] >= 3:
		for xx in range(width_x):
			for zz in range(width_z):
				var ly = l_pos2[Vector2(lx+xx,lz+zz)]
				for y in range(height):
					if ly-y >= 0:
						l_pos2[Vector2(lx+xx,lz+zz)] = -3
						buffer.set_voxel_v(water,Vector3(lx+xx,ly-y,lz+zz),channel)
		#size
		for xx in range(width_x+1):
			var ly = l_pos2[Vector2(lx+xx,lz-1)]
			for y in range(height):
				if ly-y >= 1:
					l_pos2[Vector2(lx+xx,lz-1)] = -3
					l_pos2[Vector2(lx+xx,lz+width_z)] = -3
					buffer.set_voxel_v(sand,Vector3(lx+xx,ly-y,lz-1),channel)
					buffer.set_voxel_v(sand,Vector3(lx+xx,ly-y,lz+width_z),channel)
					buffer.set_voxel_v(sand,Vector3(lx+xx,ly-y+1,lz-1),channel)
					buffer.set_voxel_v(sand,Vector3(lx+xx,ly-y+1,lz+width_z),channel)
	
		for zz in range(width_z+1):
			var ly = l_pos2[Vector2(lx-1,lz+zz)]
			for y in range(height):
				if ly-y >= 1:
					l_pos2[Vector2(lx-1,lz+zz)] = -3
					l_pos2[Vector2(lx-width_x,lz+zz)] = -3
					buffer.set_voxel_v(sand,Vector3(lx-1,ly-y,lz+zz),channel)
					buffer.set_voxel_v(sand,Vector3(lx+width_x,ly-y,lz+zz),channel)
					buffer.set_voxel_v(sand,Vector3(lx-1,ly-y+1,lz+zz),channel)
					buffer.set_voxel_v(sand,Vector3(lx+width_x,ly-y+1,lz+zz),channel)
		



