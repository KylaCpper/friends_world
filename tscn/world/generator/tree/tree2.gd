extends Object


var trunk_len_min := 6
var trunk_len_max := 15
var log_type := 1
var leaves_type := 2
var channel := VoxelBuffer.CHANNEL_TYPE

func _init() -> void:
	log_type = Block.get("wood").id
	leaves_type = Block.get("leaves").id

func generate(rand:RandomNumberGenerator) -> Dictionary:
	var voxels := {}
	# Let's make crappy trees
	# Trunk
	var trunk_len := int(rand.randf_range(trunk_len_min, trunk_len_max))
	for y in trunk_len:
		voxels[Vector3(0, y, 0)] = log_type
	# Branches
	var branches_start := int(rand.randf_range(trunk_len / 3, trunk_len / 2))
	for y in range(branches_start, trunk_len):
		var t := float(y - branches_start) / float(trunk_len)
		var branch_chance := 1.0 - pow(t - 0.5, 2)
		if rand.randf() < branch_chance:
			var branch_len := int((trunk_len / 2.0) * branch_chance * rand.randf())
			var pos := Vector3(0, y, 0)
			var angle = rand.randf_range(-PI, PI)
			var dir := Vector3(cos(angle), 0.45, sin(angle))
			for i in branch_len:
				pos += dir
				var ipos = pos.round()
				voxels[ipos] = log_type

	# Leaves
	var log_positions := voxels.keys()
	log_positions.shuffle()
	var leaf_count := int(0.75 * len(log_positions))
	log_positions.resize(leaf_count)
	var dirs := [
		Vector3(-1, 0, 0),
		Vector3(1, 0, 0),
		Vector3(0, 0, -1),
		Vector3(0, 0, 1),
		Vector3(0, 1, 0),
		Vector3(0, -1, 0)
	]
	for c in leaf_count:
		var pos = log_positions[c]
		if pos.y < branches_start:
			continue
		for di in len(dirs):
			var npos = pos + dirs[di]
			if not voxels.has(npos):
				voxels[npos] = leaves_type


	var aabb := AABB()
	for pos in voxels:
		aabb = aabb.expand(pos)
	var data = {
		"center":Vector3(),
		"voxels":{},
		"size":Vector3()
	}

	data.center = -aabb.position
	data.size = aabb.size + Vector3(1,1,1)
	data.voxels = VoxelBuffer.new()
	data.voxels.create(data.size.x,data.size.y,data.size.z)
	for pos in voxels:
		var rpos = pos + data.center
		var v = voxels[pos]
		data.voxels.set_voxel(v,rpos.x, rpos.y, rpos.z)
#	for pos in voxels:
#		var rpos = pos + data.center
#		var v = voxels[pos]
#		data.voxels[Vector3(rpos.x, rpos.y, rpos.z)] = v
	return data

