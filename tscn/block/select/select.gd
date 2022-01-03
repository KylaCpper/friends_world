extends MeshInstance
var size := 0.501
var select_material := preload("res://tscn/block/select/select.tres")
func _ready() -> void:
	Overall.select_node = self
	scale = Vector3(size,size,size)
func update(name_:String,pos3:Vector3) -> void:
	if Block.is_in(name_):
		var block = Block.get(name_)
		if block.aabb:
			pos3+=block.aabb.position
			if block.aabb.position.y!=0:
				pos3.y-=block.aabb.size.y/2
			if block.aabb.position.z!=0:
				pos3.z-=block.aabb.size.z/2
			if block.aabb.position.x!=0:
				pos3.x-=block.aabb.size.x/2
			scale = block.aabb.size/2
		else:
			scale = Vector3(size,size,size)
#		select_material.uv1_scale = scale*2
		show()
		translation = pos3
	else:
		hide()



