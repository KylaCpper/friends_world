extends Node
var chunk_pos3 := Vector3()
var change := false
func _ready() -> void:
	add_to_group("chunk")
	$chunk.connect("ready",self,"_on_done")

	CollisionGroup.collision($chunk/StaticBody,"block")
func _on_done() -> void:
	pass
	
func set_chunk() -> void:
	pass

func place(world_pos3,name_,dire,update) -> bool:
	return $chunk/StaticBody.place(world_pos3,name_,dire,update)
func add_block(block_pos3,name_,dire) -> void:
	change = true
	$chunk/StaticBody.add_block(block_pos3,name_,dire)
func update():
	$chunk.update()
#	if change:
#		change = false
#		$chunk.update()

