extends Anvil
func _ready() -> void:
	block_tscn = preload("res://script/copper_age/tscn/copper_anvil.tscn")
	name_ = "steel_anvil"
	var block = Block.get(name_)
	model = {
		"id" : Block.get_id_from_name(name_),
		"key":-1,
		"hp":int(block.other),
		"pros":[0,0],
		"list":[{"name":"","num":0,"hp":0},{"name":"","num":0,"hp":0}],
		"export_list":[{"name":"","num":0,"hp":0}],
	}
	init()
func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	._place(pos3,block_name,dire)
	var pos3_arr = Function.vec_arr(pos3)
	var node = Overall.chunks_node_node.get_block_real(pos3)
	node.mesh = load("res://assets/model/iron_age/steel_anvil_real.obj")
