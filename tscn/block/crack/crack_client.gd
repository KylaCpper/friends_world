extends MeshInstance
var crack_img1 := preload("res://assets/img/block/crack/crack1.png")
var crack_img2 := preload("res://assets/img/block/crack/crack2.png")
var crack_img3 := preload("res://assets/img/block/crack/crack3.png")
var crack_img4 := preload("res://assets/img/block/crack/crack4.png")
var crack_img5 := preload("res://assets/img/block/crack/crack5.png")
var material_tres := preload("res://tscn/block/crack/crack.tres")
var size := 0.5
func _ready() -> void:
	scale = Vector3(size,size,size)
	var material = material_tres.duplicate()
	material_override = material

func sync_state(data:Array) -> void:
	translation = data[0]
	var pro = data[1]
	material_override.uv1_scale = data[2]
	if pro<10:
		hide()
	else:
		show()
		if pro<30:
			material_override.albedo_texture = crack_img1
		else:
			if pro<50:
				material_override.albedo_texture = crack_img2
			else:
				if pro<70:
					material_override.albedo_texture = crack_img3
				else:
					if pro<90:
						material_override.albedo_texture = crack_img4
					else:
						if pro<95:
							material_override.albedo_texture = crack_img5
