extends VoxelStreamRegionFiles
#extends VoxelStreamBlockFiles
var channel := VoxelBuffer.CHANNEL_TYPE
func _init():
#	directory = OS.get_executable_path().get_base_dir()
#	directory = "res://"
	if Net.is_master():
		directory = "user://"+Save.folder
		save_generator_output = true
#		save_fallback_output = true
	else:
		save_generator_output = false
		#save_fallback_output = false
#	fallback_stream = Generator.voxelgenerator
	pass
	
#func emerge_block(out_buffer:VoxelBuffer,origin_in_voxels:Vector3, lod:int):
#	print(origin_in_voxels)
#
#func immerge_block(out_buffer:VoxelBuffer,origin_in_voxels:Vector3, lod:int):
#	print(origin_in_voxels)
#func get_used_channels_mask() -> int:
#	return 1<<channel
