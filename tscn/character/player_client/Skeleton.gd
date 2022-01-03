extends Skeleton
var head0_vec3 := Vector3()
var head1_vec3 := Vector3()
var waist1_vec3 := Vector3()
onready var head0_id :int = find_bone("head0")
onready var head1_id :int = find_bone("head1")
onready var waist1_id :int = find_bone("waist1")
var mouse_speed := 0.1
var bone_list={
	#id : transfrom
}
func _ready():
	bone_list[head0_id]=get_bone_pose(head0_id)
	bone_list[head1_id]=get_bone_pose(head1_id)
	bone_list[waist1_id] = get_bone_pose(waist1_id)
	var pname = Net.player_info[int($"../../".name)].name
	on_armor(Save.save_data.players[pname].armor[0].name,0)
	on_armor(Save.save_data.players[pname].armor[1].name,1)
	on_armor(Save.save_data.players[pname].armor[2].name,2)
	on_armor(Save.save_data.players[pname].armor[3].name,3)
	on_armor(Save.save_data.players[pname].armor[4].name,4)
	
func sync_bone(body_y:int,head0_vec3:Vector3,waist1_vec3:Vector3) -> void:
	rotation_degrees.y = body_y
	set_bone_rot(head0_id,head0_vec3)
	set_bone_rot(waist1_id,waist1_vec3)
	
func turn_around(dire:String) -> void:
	if dire == "left":
		rotation_degrees.y=45
		head0_vec3.z=0.75
		head0_vec3.y=0.16
		waist1_vec3.z=0.0
		waist1_vec3.y=0.0
	if dire == "right":
		rotation_degrees.y=-45
		head0_vec3.z=-0.75
		head0_vec3.y=-0.16
		waist1_vec3.z=-0.0
		waist1_vec3.y=-0.0
#		head1_vec3.z=-0.75
#		head1_vec3.y=-0.16
	if dire == "default":
		rotation_degrees.y=0
		head0_vec3.z=-0
		head0_vec3.y=-0
		waist1_vec3.z=-0
		waist1_vec3.y=-0
#		head1_vec3.z=-0
#		head1_vec3.y=-0
		
	set_bone_rot(head0_id,head0_vec3)
	set_bone_rot(waist1_id,waist1_vec3)
func set_bone_rot(id:int, ang:Vector3) -> void:
	var newpose = bone_list[id].rotated(Vector3(1.0, 0.0, 0.0), ang.x)
	newpose = newpose.rotated(Vector3(0.0, 1.0, 0.0), ang.y)
	newpose = newpose.rotated(Vector3(0.0, 0.0, 1.0), ang.z)
	set_bone_pose(id, newpose)

func ragdoll(be:bool) -> void:
	if be:
		physical_bones_start_simulation()
	else:
		physical_bones_stop_simulation()
		
func change_hand(name_:="") -> void:
	if name_:
		var obj = Item.get(name_)
		if obj.type=="block":
			if obj.model:
				$hand/item.hide()
				$hand/single.hide()
				$hand/model.show()
				$hand/model.mesh = obj.model
				$hand/model.material_override = load("res://tscn/world/terrain"+str(obj.material)+".tres")
			else:
				$hand/item.hide()
				$hand/model.hide()
				$hand/single._show(name_)
	
		else:
			$hand/single.hide()
			$hand/model.hide()
			$hand/item.create(obj.img)
			$hand/item.show()
			
	else:
		$hand/item.hide()
		$hand/single.hide()
		$hand/model.hide()

func on_armor(name_:String,index:int) ->void:
	if name_:
		if index == 0:
			$head/hat.show()
		if index == 1:
			$waist.show()
		if index == 2:
			$arm0_left.show()
			$arm1_left.show()
			$arm0_right.show()
			$arm1_right.show()
		if index == 3:
			$leg0_left.show()
			$leg0_right.show()
			$leg1_left.show()
			$leg1_right.show()
		if index == 4:
			$shoe_left.show()
			$shoe_right.show()
	else:
		if index == 0:
			$head/hat.hide()
		if index == 1:
			$waist.hide()
		if index == 2:
			$arm0_left.hide()
			$arm1_left.hide()
			$arm0_right.hide()
			$arm1_right.hide()
		if index == 3:
			$leg0_left.hide()
			$leg0_right.hide()
			$leg1_left.hide()
			$leg1_right.hide()
		if index == 4:
			$shoe_left.hide()
			$shoe_right.hide()

