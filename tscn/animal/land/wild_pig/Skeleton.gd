extends Skeleton
var head_vec3 := Vector3()
onready var head_id := find_bone("head")
var bone_list={
	#id : transfrom
}
func _ready() -> void:
	bone_list[head_id] = get_bone_pose(head_id)
	


func set_bone_rot(id:int, ang:Vector3) -> void:
	var newpose = bone_list[id].rotated(Vector3(1.0, 0.0, 0.0), ang.x)
	newpose = newpose.rotated(Vector3(0.0, 1.0, 0.0), ang.y)
	newpose = newpose.rotated(Vector3(0.0, 0.0, 1.0), ang.z)
	set_bone_pose(id, newpose)

func rot_head_y(rot:float,sync_:=false) -> void:
#	head_vec3.y += rot
#	var end = head_vec3.y + rot
	
#	head_vec3.y = 0.0
	if !sync_:
		rot = rot - head_vec3.y
		rot *= 0.1
		for i in range(10):
			yield(get_tree(),"idle_frame")
			head_vec3.y += rot
			head_vec3.y = clamp(head_vec3.y, -0.5, 0.5)
			set_bone_rot(head_id,head_vec3)
	else:
		head_vec3.y = rot
		head_vec3.y = clamp(head_vec3.y, -0.5, 0.5)
		set_bone_rot(head_id,head_vec3)
	
func rot_head_x(rot:float,sync_:=false) -> void:
#	head_vec3.y += rot
#	var end = head_vec3.y + rot
	
#	head_vec3.y = 0.0
	if !sync_:
		rot = rot - head_vec3.x
		rot *= 0.1
		for i in range(10):
			yield(get_tree(),"idle_frame")
			head_vec3.x += rot
			head_vec3.x = clamp(head_vec3.x, -0.5, 0.5)
			set_bone_rot(head_id,head_vec3)
	else:
		head_vec3.x = rot
		head_vec3.x = clamp(head_vec3.x, -0.5, 0.5)
		set_bone_rot(head_id,head_vec3)
	
