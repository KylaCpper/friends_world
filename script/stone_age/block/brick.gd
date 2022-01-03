extends Multe_Block


func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	find(pos3,block_name,"brick_furnace")
