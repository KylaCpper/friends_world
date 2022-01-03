extends Multe_Block


func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	find(pos3,block_name,"stone_blast_furnace")
func _update(pos3:Vector3,block_name:String,dire:int) -> void:
	._update(pos3,block_name,dire)
	find_update(pos3,block_name,"stone_blast_furnace")
