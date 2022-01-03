extends Object

var coal_ore := 1
var num := 0
var channel := VoxelBuffer.CHANNEL_TYPE
func _init() -> void:
	coal_ore = Block.get("coal_ore").id

func generate(rand:RandomNumberGenerator) -> Dictionary:
	
	var width = rand.randi_range(1,6)
	var width_z = rand.randi_range(1,6)
	var height = rand.randi_range(1,6)
	
	var data = {
		"voxels":{},
		"size":Vector3()
	}
	for x in width:
		for z in width_z:
			for y in height:
				data.voxels[Vector3(x,y,z)] = coal_ore
				
	
	data.size = Vector3(width,height,width_z)
	return data

