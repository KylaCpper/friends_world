extends Node
var chunk_voxel_tscn := preload("res://tscn/chunk/chunk_voxel.tscn")
var chunk_grid_tscn := preload("res://tscn/chunk/chunk_grid.tscn")
var offset := Vector3(0,0,0)
var chunks_pos3 := Vector3(0,0,0)
func _ready() -> void:
	pass

func add_block(block_pos3,chunk_pos3,name_,dire) -> void:
	
	if Block.get(name_).block:
		var chunk_name = str(chunk_pos3.x)+","+str(chunk_pos3.y)+","+str(chunk_pos3.z)+","+"voxel"
		if self.has_node(chunk_name):
			var chunk = get_node(chunk_name)
			chunk.add_block(block_pos3,name_,dire)
#		else:
#			var tscn = chunk_voxel_tscn.instance()
#			tscn.name = chunk_name
#			tscn.chunk = chunk_pos3
#			add_child(tscn)
#			tscn.add_block(block_pos3,name_,dire)
	else:
		var chunk_name = str(chunk_pos3.x)+","+str(chunk_pos3.y)+","+str(chunk_pos3.z)+","+"grid"
		if self.has_node(chunk_name):
			var chunk = get_node(chunk_name)
			chunk.add_block(block_pos3,name_,dire)
		else:
			var tscn = chunk_grid_tscn.instance()
			tscn.name = chunk_name
			tscn.chunk = chunk_pos3
			add_child(tscn)
			tscn.add_block(block_pos3,name_,dire)



func place(world_pos3,chunk_pos3,name_,dire,update) -> bool:

	if Block.get(name_).block:
		var chunk_name = str(chunk_pos3.x)+","+str(chunk_pos3.y)+","+str(chunk_pos3.z)+","+"voxel"
		
		if self.has_node(chunk_name):
			var chunk = get_node(chunk_name)
			return chunk.place(world_pos3,name_,dire,update)
		else:
			var tscn = chunk_voxel_tscn.instance()
			tscn.name = chunk_name
			tscn.chunk_pos3 = chunk_pos3
			add_child(tscn)
			return tscn.place(world_pos3,name_,dire,update)
	else:
		var chunk_name = str(chunk_pos3.x)+","+str(chunk_pos3.y)+","+str(chunk_pos3.z)+","+"grid"
		
		if self.has_node(chunk_name):
			var chunk = get_node(chunk_name)
			return chunk.place(world_pos3,name_,dire,update)
		else:
			var tscn = chunk_grid_tscn.instance()
			tscn.name = chunk_name
			tscn.chunk_pos3 = chunk_pos3
			add_child(tscn)
			return tscn.place(world_pos3,name_,dire,update)


func update(name_ = ""):
	if !name_:
		for obj in get_children():
			obj.update()
				
	else:
		var chunk_name =  str(name_.x)+","+str(name_.y)+","+str(name_.z)+"voxel"
		if has_node(chunk_name):
#			yield(get_tree(),"idle_frame")
			get_node(chunk_name).update()
	
