extends VoxelGeneratorScript
var channel := VoxelBuffer.CHANNEL_TYPE
var noise := Terrain.noise
var random := Terrain.random
var seed_num := Terrain.seed_num

#func _get_used_channels_mask () -> int:
#	return 1<<channel



func _generate_block(buffer:VoxelBuffer, cpos3:Vector3, lod:int) -> void:
	if cpos3.y>127||cpos3.y<-128:return 
	
	Generator.default.generate(buffer, cpos3)
#	cpos3.x += 15
#	cpos3.y += 15
#	cpos3.z += 15
	if Net.is_master():return
	var ccpos3 = get_chunk_pos3(cpos3)
	var cccpos3 = get_chunk_pos3(ccpos3)
	var key1 = [cccpos3.x,cccpos3.y,cccpos3.z]
	var key2 = [ccpos3.x,ccpos3.y,ccpos3.z]
	var map_queue = Terrain.map_queue
	if key1 in map_queue:
		if key2 in map_queue[key1]:
			for key3 in map_queue[key1][key2]:
				var pos3 = Vector3(key3[0],key3[1],key3[2])
				if pos3.x < 0:
					pos3.x = (key3[0])%16 +16
				else:
					pos3.x = key3[0] % 16
				if pos3.y < 0:
					pos3.y = (key3[1])%16 +16
				else:
					pos3.y = key3[1] % 16
				if pos3.z < 0:
					pos3.z = (key3[2])%16 +16
				else:
					pos3.z = key3[2] % 16
				if pos3.x ==16:pos3.x =0
				if pos3.y ==16:pos3.y =0
				if pos3.z ==16:pos3.z =0
				buffer.set_voxel_v(map_queue[key1][key2][key3],pos3)
			map_queue[key1].erase(key2)
			if map_queue[key1].size()==0:map_queue.erase(key1)

func get_chunk_pos3(world_pos3:Vector3) -> Vector3:
	var chunk_pos3 = world_pos3/16
	chunk_pos3 = Vector3(int(floor(chunk_pos3.x)),int(floor(chunk_pos3.y)),int(floor(chunk_pos3.z)))
	return chunk_pos3
