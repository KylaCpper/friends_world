extends Object
var log_type := 1
var leaves_type := 2
var apple_grow0 := 0
var channel := VoxelBuffer.CHANNEL_TYPE

func _init() -> void:
	log_type = Block.get("wood").id+4
	leaves_type = Block.get("apple_leaves").id
	apple_grow0 = Block.get("apple_grow0").id
func generate(rand:RandomNumberGenerator) -> Dictionary:
	var voxels := {}
	voxels[Vector3(0,7,0)] = leaves_type
	for y in 7:
		voxels[Vector3(0,y,0)] = log_type
	for ix in 5:
		for iz in 5:
			var x = ix-2
			var z = iz-2
			if !(!x && !z):
				voxels[Vector3(x,4,z)] = leaves_type
				voxels[Vector3(x,5,z)] = leaves_type
				if abs(x)<2 && abs(z)<2: 
					voxels[Vector3(x,6,z)] = leaves_type
	for i in rand.randi_range(1,5):
		var x = rand.randi()%5-2
		var z = rand.randi()%5-2
		if !(!x && !z):
			voxels[Vector3(x,3,z)] = apple_grow0
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

