extends Node
class_name GeneratorBase
var noise := Terrain.noise
var random := Terrain.random
var channel := VoxelBuffer.CHANNEL_TYPE
static func get_local_pos1(x:int) -> int:
	x = int(x) % 16
	if x<0:x +=16
	return x
static func get_local_pos3(bpos3:Vector3) -> Vector3:
	var x = int(bpos3.x) % 16
	var y = int(bpos3.y) % 16
	var z = int(bpos3.z) % 16
	if x<0:x +=16
	if y<0:y +=16
	if z<0:z +=16
	return Vector3(x,y,z)

static func random(data:float,pros:Array) -> bool:
	if abs(int(data*pros[0])%pros[1]) < pros[2]:
		return true
	else:
		return false
