extends MeshInstance
var crack_img1 := preload("res://assets/img/block/crack/crack1.png")
var crack_img2 := preload("res://assets/img/block/crack/crack2.png")
var crack_img3 := preload("res://assets/img/block/crack/crack3.png")
var crack_img4 := preload("res://assets/img/block/crack/crack4.png")
var crack_img5 := preload("res://assets/img/block/crack/crack5.png")
var material_tres := preload("res://tscn/block/crack/crack.tres")
var size := 0.501
func _ready() -> void:
	Overall.crack_node = self
	scale = Vector3(size,size,size)
func sync_pos3(name_:String,pos3:Vector3) -> void:
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
	material_tres.uv1_scale = scale*2
	translation = pos3
func update_state(pro:float) -> void:
	if Overall.cg:return
	Overall.player_node_node.rset1_udp("crack",[translation,pro,material_tres.uv1_scale])
	show()
	if pro == 0.0:
		hide()
		return
	if pro<20:
		material_tres.albedo_texture = crack_img1
	else:
		if pro<40:
			material_tres.albedo_texture = crack_img2
		else:
			if pro<60:
				material_tres.albedo_texture = crack_img3
			else:
				if pro<80:
					material_tres.albedo_texture = crack_img4
				else:
					if pro<100:
						material_tres.albedo_texture = crack_img5
