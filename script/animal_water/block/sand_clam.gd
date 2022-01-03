extends Gravity
const VEC_LIST=[
	Vector3(0,0,-1),
	Vector3(0,0,1),
	Vector3(-1,0,0),
	Vector3(1,0,0),
	Vector3(0,1,0),
]
const VEC_LIST2=[
	Vector3(0,0,-1),
	Vector3(0,0,1),
	Vector3(-1,0,0),
	Vector3(1,0,0),
	Vector3(0,-1,0),
	Vector3(0,1,0),
]
func _ready() -> void:
	pass
func _random_tick(pos3:Vector3,block:Dictionary,block_key:String) -> void:
	if Overall.terrain_main_node.get_name_(pos3) == block_key:
		for offset in VEC_LIST:
			var pos3_ = pos3 + offset
			var key = Overall.terrain_main_node.get_name_(pos3_)
			if  key== "water" || key == "water_branch0" || key == "water_branch1" || key == "water_branch2" || key == "water_branch3" || key == "water_branch4" || key == "water_branch5" || key == "water_branch6":
				reproduce(pos3)
				return
		Overall.terrain_node_node.create_drop(pos3,{"name":"clam","num":1,})
		Overall.terrain_main_node.add_block(pos3,"sand")

func reproduce(pos3:Vector3) -> void:
	for offset in VEC_LIST2:
		var pos3_ = pos3 + offset
		var key =  Overall.terrain_main_node.get_name_(pos3_)
		if key == "sand_wet":
			Overall.terrain_main_node.add_block(pos3_,"sand_clam")
			return
			
			
func _event(pos3:Vector3,block_name:String,dire:int) -> bool:
	Overall.terrain_main_node.add_block(pos3,"sand_wet")
	Overall.bar_node.add_item({"name":"clam","num":1,"hp":0})
	return true
