extends Object
var log_type := 1
var leaves_type := 2
var banana_grow0 := 0
var channel := VoxelBuffer.CHANNEL_TYPE

func _init() -> void:
	log_type = Block.get("wood").id+4
	leaves_type = Block.get("banana_leaves").id
	banana_grow0 = Block.get("banana_grow0").id
func generate(i) -> Dictionary:
	var voxels := {}
	voxels[Vector3(0,7,0)] = leaves_type
	for y in 5+i:
		voxels[Vector3(0,y,0)] = log_type
	var height = 6+i-4
	height += 1
	voxels[Vector3(-1,height,0)] = leaves_type
	voxels[Vector3(0,height,-1)] = leaves_type
	voxels[Vector3(0,height,1)] = leaves_type
	voxels[Vector3(1,height,0)] = leaves_type
	height += 1
	voxels[Vector3(-1,height,-1)] = leaves_type
	voxels[Vector3(-1,height,0)] = leaves_type
	voxels[Vector3(-1,height,1)] = leaves_type
	voxels[Vector3(0,height,-1)] = leaves_type
	voxels[Vector3(0,height,1)] = leaves_type
	voxels[Vector3(1,height,-1)] = leaves_type
	voxels[Vector3(1,height,0)] = leaves_type
	voxels[Vector3(1,height,1)] = leaves_type
	height += 1
	voxels[Vector3(-1,height,-1)] = leaves_type
	voxels[Vector3(-1,height,0)] = leaves_type
	voxels[Vector3(-1,height,1)] = leaves_type
	voxels[Vector3(0,height,-1)] = leaves_type
	voxels[Vector3(0,height,1)] = leaves_type
	voxels[Vector3(1,height,-1)] = leaves_type
	voxels[Vector3(1,height,0)] = leaves_type
	voxels[Vector3(1,height,1)] = leaves_type
	
	voxels[Vector3(-2,height,0)] = leaves_type
	voxels[Vector3(2,height,0)] = leaves_type
	voxels[Vector3(0,height,-2)] = leaves_type
	voxels[Vector3(0,height,2)] = leaves_type
	height += 1
	voxels[Vector3(-1,height,0)] = leaves_type
	voxels[Vector3(0,height,-1)] = leaves_type
	voxels[Vector3(0,height,1)] = leaves_type
	voxels[Vector3(1,height,0)] = leaves_type
	height += 1
	voxels[Vector3(0,height,0)] = leaves_type
	
	height -=5
	voxels[Vector3(-1,height,0)] = banana_grow0
	voxels[Vector3(1,height,0)] = banana_grow0
	voxels[Vector3(0,height,-1)] = banana_grow0
	voxels[Vector3(0,height,1)] = banana_grow0
	# Make structure
	var aabb := AABB()
	for pos in voxels:
		aabb = aabb.expand(pos)
	var data = {
		"offset":Vector3(6,0,6),
		"voxels":VoxelBuffer.new(),
		"size":Vector3()
	}
	data.size = aabb.size
	data.offset = -aabb.position
	var buffer = data.voxels
	buffer.create(int(aabb.size.x) + 1, int(aabb.size.y) + 1, int(aabb.size.z) + 1)

	for pos in voxels:
		var rpos = pos + data.offset
		var v = voxels[pos]
		buffer.set_voxel(v, rpos.x, rpos.y, rpos.z, channel)

	return data

