extends GeneratorBase
var tree_width = 3
var tree_height_min = 4
var tree_height_max = 8
# x - +
# z -
#   +
var wood_id

func _init() -> void:
	wood_id = Block.get("wood").id+4
func create(buffer:VoxelBuffer,cpos3:Vector3,l_pos2:Dictionary,noises:Array,plain:String) -> void:
	var pros = [100,10,4]
	var pro = int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1]
	if pro < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)
		var ly = l_pos2[Vector2(lx,lz)]
		if ly >= 0:
			var lpos3 = Vector3(lx,ly,lz)
			var height = get_height(cpos3,noises)
			create_wood(buffer,lpos3,height)
			lpos3.y+=height - 1
			create_leaves(buffer,lpos3)
func create_wood(buffer:VoxelBuffer, lpos3:Vector3,height:int) ->void:
	for i in range(height):
		if lpos3.y <16:
			buffer.set_voxel_v(wood_id,lpos3,channel)
		lpos3.y += 1
func create_leaves(buffer:VoxelBuffer, lpos3_:Vector3) -> void:
	var lpos3 = lpos3_
	lpos3.y+=1
	create_leaves_layer(buffer,lpos3,1)
	lpos3 = lpos3_
	create_leaves_layer(buffer,lpos3,2)
	lpos3 = lpos3_
	lpos3.y-=1
	create_leaves_layer(buffer,lpos3,3)
	lpos3 = lpos3_
	lpos3.y-=2
	create_leaves_layer(buffer,lpos3,2)
func create_leaves_layer(buffer:VoxelBuffer, lpos3_:Vector3,width:int) ->void:
	var width_ = width*2 -1
	if width_ < 1:return
	var width_half= width
	var lpos3 = lpos3_
	if lpos3.y > 15 || lpos3.y < 0:return
	lpos3.x -= width_half
	for x in range(width_):
		lpos3.z = lpos3_.z - width_half
		lpos3.x += 1
		if lpos3.x <16 &&lpos3.x >=0:
			for z in range(width_):
				lpos3.z += 1
				if lpos3.z <16&&lpos3.z >=0:
					if width_ > 1:
						if !(lpos3.x == lpos3_.x &&lpos3.z == lpos3_.z):
							buffer.set_voxel_v(Block.get("leaves").id,lpos3,channel)
					else:
						buffer.set_voxel_v(Block.get("leaves").id,lpos3,channel)
	
func create_leaves_layer_side_x(buffer:VoxelBuffer, lpos3:Vector3,x:int,z:int,reverse:=false) ->void:
	if lpos3.y <0 || lpos3.y >15:return
	for xx in range(x):
		for zz in range(-z,z+1):
			var lz = lpos3.z+zz
			if lz < 16 && lz >=0:
				if !reverse:
					buffer.set_voxel_v(Block.get("leaves").id,Vector3(xx,lpos3.y,lz),channel)
				else:
					buffer.set_voxel_v(Block.get("leaves").id,Vector3(15-xx,lpos3.y,lz),channel)
func create_leaves_layer_side_z(buffer:VoxelBuffer, lpos3:Vector3,x:int,z:int,reverse:=false) ->void:
	if lpos3.y <0 || lpos3.y >15:return
	for zz in range(z):
		for xx in range(-x,x+1):
			var lx = lpos3.x+xx
			if lx < 16 && lx >=0:
				if !reverse:
					buffer.set_voxel_v(Block.get("leaves").id,Vector3(lx,lpos3.y,zz),channel)
				else:
					buffer.set_voxel_v(Block.get("leaves").id,Vector3(lx,lpos3.y,15-zz),channel)
func create_leaves_layer_side_xz(buffer:VoxelBuffer, lpos3:Vector3,x:int,z:int,re_x:=false,re_z:=false) ->void:
	if lpos3.y <0 || lpos3.y >15:return
	for xx in range(x):
		for zz in range(z):
			if !re_x:
				if !re_z:
					buffer.set_voxel_v(Block.get("leaves").id,Vector3(xx,lpos3.y,zz),channel)
				else:
					buffer.set_voxel_v(Block.get("leaves").id,Vector3(xx,lpos3.y,15-zz),channel)
			else:
				if !re_z:
					buffer.set_voxel_v(Block.get("leaves").id,Vector3(15-xx,lpos3.y,zz),channel)
				else:
					buffer.set_voxel_v(Block.get("leaves").id,Vector3(15-xx,lpos3.y,15-zz),channel)

	
func create_around(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,plain:String) -> void:
	var pros = [100,10,4]
	check_tree_left(buffer,cpos3,noises,pros)
	check_tree_right(buffer,cpos3,noises,pros)
	check_tree_forward(buffer,cpos3,noises,pros)
	check_tree_back(buffer,cpos3,noises,pros)
	check_tree_left_forward(buffer,cpos3,noises,pros)
	check_tree_right_forward(buffer,cpos3,noises,pros)
	check_tree_left_back(buffer,cpos3,noises,pros)
	check_tree_right_back(buffer,cpos3,noises,pros)

	check_tree_down(buffer,cpos3,noises,pros)
	check_tree_down_left(buffer,cpos3,noises,pros)
	check_tree_down_right(buffer,cpos3,noises,pros)
	check_tree_down_forward(buffer,cpos3,noises,pros)
	check_tree_down_back(buffer,cpos3,noises,pros)
	check_tree_down_left_forward(buffer,cpos3,noises,pros)
	check_tree_down_right_forward(buffer,cpos3,noises,pros)
	check_tree_down_left_back(buffer,cpos3,noises,pros)
	check_tree_down_right_back(buffer,cpos3,noises,pros)

func get_height(cpos3:Vector3,noises:Array) -> int:
	var height = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*100)%tree_height_min)+tree_height_max-tree_height_min
	if height < tree_height_min: height = tree_height_min
	return height
func check_tree_left(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	
	cpos3.x-=16
	var pro = int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1]
	if pro < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)
		
		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx + 2 > 15:
				if ly + height - 1 < 16:
					ly = ly + height -1
					create_tree_left(buffer,Vector3(lx,ly,lz),height)


func create_tree_left(buffer:VoxelBuffer, lpos3:Vector3,height:int) -> void:
	var x = lpos3.x + 2 - 15
	create_leaves_layer_side_x(buffer,lpos3,x-1,1)
	lpos3.y-=1
	create_leaves_layer_side_x(buffer,lpos3,x,2)
	lpos3.y-=1
	create_leaves_layer_side_x(buffer,lpos3,x-1,1)

	
func check_tree_right(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x+=16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx - 2 < 0:
				if ly + height - 1 < 16:
					ly = ly + height -1
					create_tree_right(buffer,Vector3(lx,ly,lz),height)
					
func create_tree_right(buffer:VoxelBuffer, lpos3:Vector3,height:int) -> void:
	var x = abs(lpos3.x - 2)

	create_leaves_layer_side_x(buffer,lpos3,x-1,1,true)
	lpos3.y-=1
	create_leaves_layer_side_x(buffer,lpos3,x,2,true)
	lpos3.y-=1
	create_leaves_layer_side_x(buffer,lpos3,x-1,1,true)
	
func check_tree_forward(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:

	cpos3.z-=16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lz + 2 > 15:
				if ly + height - 1 < 16:
					ly = ly + height -1
					create_tree_forward(buffer,Vector3(lx,ly,lz),height)
					
func create_tree_forward(buffer:VoxelBuffer, lpos3:Vector3,height:int) -> void:
	var z = lpos3.z + 2 - 15
	create_leaves_layer_side_z(buffer,lpos3,1,z-1)
	lpos3.y-=1
	create_leaves_layer_side_z(buffer,lpos3,2,z)
	lpos3.y-=1
	create_leaves_layer_side_z(buffer,lpos3,1,z-1)
	
	
	
func check_tree_back(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:

	cpos3.z+=16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lz - 2 < 0:
				if ly + height - 1 < 16:
					ly = ly + height -1
					create_tree_back(buffer,Vector3(lx,ly,lz),height)
					
func create_tree_back(buffer:VoxelBuffer, lpos3:Vector3,height:int) -> void:
	var z = abs(lpos3.z - 2)
	create_leaves_layer_side_z(buffer,lpos3,1,z-1,true)
	lpos3.y-=1
	create_leaves_layer_side_z(buffer,lpos3,2,z,true)
	lpos3.y-=1
	create_leaves_layer_side_z(buffer,lpos3,1,z-1,true)	
	
func check_tree_left_forward(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x-=16
	cpos3.z-=16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx + 2 > 15:
				if lz + 2 > 15:
					if ly + height - 1 < 16:
						ly = ly + height -1
						create_tree_left_forward(buffer,Vector3(lx,ly,lz),height)
					
func create_tree_left_forward(buffer:VoxelBuffer, lpos3:Vector3,height:int) -> void:
	var x = lpos3.x + 2 -15
	var z = lpos3.z + 2 -15
	create_leaves_layer_side_xz(buffer,lpos3,x-1,z-1)
	lpos3.y-=1
	create_leaves_layer_side_xz(buffer,lpos3,x,z)
	lpos3.y-=1
	create_leaves_layer_side_xz(buffer,lpos3,x-1,z-1)

	
	
func check_tree_right_forward(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x+=16
	cpos3.z-=16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx -2 < 0:
				if lz + 2 > 15:
					if ly + height - 1 < 16:
						ly = ly + height -1
						create_tree_right_forward(buffer,Vector3(lx,ly,lz),height)
					
func create_tree_right_forward(buffer:VoxelBuffer, lpos3:Vector3,height:int) -> void:
	var x = abs(lpos3.x - 2)
	var z = lpos3.z + 2 -15
	create_leaves_layer_side_xz(buffer,lpos3,x-1,z-1,true)
	lpos3.y-=1
	create_leaves_layer_side_xz(buffer,lpos3,x,z,true)
	lpos3.y-=1
	create_leaves_layer_side_xz(buffer,lpos3,x-1,z-1,true)
	
	
	
	
	
func check_tree_left_back(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x-=16
	cpos3.z+=16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx + 2 > 15:
				if lz - 2 < 0:
					if ly + height - 1 < 16:
						ly = ly + height -1
						create_tree_left_back(buffer,Vector3(lx,ly,lz),height)
					
func create_tree_left_back(buffer:VoxelBuffer, lpos3:Vector3,height:int) -> void:
	var x = lpos3.x + 2 -15
	var z = abs(lpos3.z - 2)
	create_leaves_layer_side_xz(buffer,lpos3,x-1,z-1,false,true)
	lpos3.y-=1
	create_leaves_layer_side_xz(buffer,lpos3,x,z,false,true)
	lpos3.y-=1
	create_leaves_layer_side_xz(buffer,lpos3,x-1,z-1,false,true)
	
func check_tree_right_back(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x+=16
	cpos3.z+=16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx -2 < 0:
				if lz - 2 < 0:
					if ly + height - 1 < 16:
						ly = ly + height - 1
						create_tree_right_back(buffer,Vector3(lx,ly,lz),height)
					
func create_tree_right_back(buffer:VoxelBuffer, lpos3:Vector3,height:int) -> void:
	var x = abs(lpos3.x - 2)
	var z = abs(lpos3.z - 2)
	create_leaves_layer_side_xz(buffer,lpos3,x-1,z-1,true,true)
	lpos3.y-=1
	create_leaves_layer_side_xz(buffer,lpos3,x,z,true,true)
	lpos3.y-=1
	create_leaves_layer_side_xz(buffer,lpos3,x-1,z-1,true,true)


func check_tree_down(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.y -= 16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			ly = ly + height -1 - 16
			if ly >= -1:
				# 特殊情况 树干在下个区块全部生成，上面区块只有一个顶部树叶 
				if ly == -1:
					create_leaves_layer(buffer,Vector3(lx,0,lz),1)
				else:
					create_tree_down(buffer,Vector3(lx,ly,lz),height)
					
func create_tree_down(buffer:VoxelBuffer, lpos3:Vector3,height:int) -> void:
	var y = lpos3.y
	for yy in range(y+1):
		buffer.set_voxel_v(wood_id,Vector3(lpos3.x,yy,lpos3.z),channel)
#	if y >= 2:
	create_leaves(buffer,lpos3)
#	else:
#		lpos3.y+=1
#		create_leaves_layer(buffer,lpos3,1)
#		lpos3.y-=1
#		create_leaves_layer(buffer,lpos3,2)
#		if y == 1:
#			lpos3.y-=1
#			create_leaves_layer(buffer,lpos3,3)

func check_tree_down_left(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x -= 16
	cpos3.y -= 16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx + 2 > 15:
				if ly + height -1 > 15:
					ly = ly + height -1 - 16
					create_tree_left(buffer,Vector3(lx,ly,lz),height)
func check_tree_down_right(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x += 16
	cpos3.y -= 16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx - 2 < 0:
				if ly + height -1 > 15:
					ly = ly + height -1 - 16
					create_tree_right(buffer,Vector3(lx,ly,lz),height)
func check_tree_down_forward(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.z -= 16
	cpos3.y -= 16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lz + 2 > 15:
				if ly + height -1 > 15:
					ly = ly + height -1 - 16
					create_tree_forward(buffer,Vector3(lx,ly,lz),height)
					
					
func check_tree_down_back(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.z += 16
	cpos3.y -= 16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lz - 2 < 0:
				if ly + height -1 > 15:
					ly = ly + height -1 - 16
					create_tree_back(buffer,Vector3(lx,ly,lz),height)
					
	
func check_tree_down_left_forward(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x -= 16
	cpos3.z -= 16
	cpos3.y -= 16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height =get_height(cpos3,noises)
			if lx + 2 > 15:
				if lz + 2 > 15:
					if ly + height -1 > 15:
						ly = ly + height -1 - 16
						create_tree_left_forward(buffer,Vector3(lx,ly,lz),height)
func check_tree_down_right_forward(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x += 16
	cpos3.z -= 16
	cpos3.y -= 16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx -2 < 0:
				if lz + 2 > 15:
					if ly + height -1 > 15:
						ly = ly + height -1 - 16
						create_tree_right_forward(buffer,Vector3(lx,ly,lz),height)
func check_tree_down_left_back(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x -= 16
	cpos3.z += 16
	cpos3.y -= 16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx + 2 > 15:
				if lz - 2 < 0:
					if ly + height -1 > 15:
						ly = ly + height -1 - 16
						create_tree_left_back(buffer,Vector3(lx,ly,lz),height)
	
func check_tree_down_right_back(buffer:VoxelBuffer,cpos3:Vector3,noises:Array,pros:Array) -> void:
	cpos3.x += 16
	cpos3.z += 16
	cpos3.y -= 16
	if int(noises[0][cpos3.x][cpos3.z][cpos3.y]*pros[0])%pros[1] < pros[2]:
		var lx = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*160)%16)
		var lz = abs(int(noises[0][cpos3.x][cpos3.z][cpos3.y]*320)%16)

		var yy = noise.get_noise_3d(cpos3.x+lx,0,cpos3.z+lz)*20
		yy = int(yy)+1
		if yy > cpos3.y && yy < cpos3.y+16:
			var ly = get_local_pos1(yy)
			var height = get_height(cpos3,noises)
			if lx -2 < 0:
				if lz - 2 < 0:
					if ly + height -1 > 15:
						ly = ly + height -1 - 16
						create_tree_right_back(buffer,Vector3(lx,ly,lz),height)
