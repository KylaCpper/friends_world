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
	on_armor(Save.save_data.player.armor[0].name,0)
	on_armor(Save.save_data.player.armor[1].name,1)
	on_armor(Save.save_data.player.armor[2].name,2)
	on_armor(Save.save_data.player.armor[3].name,3)
	on_armor(Save.save_data.player.armor[4].name,4)
func _unhandled_input(event):
#	if event.is_action_pressed("f"):
#		$player/Skeleton.ragdoll(true)
#	if event.is_action_pressed("q"):
#		$player/Skeleton.ragdoll(false)
	if !Overall.gui:
		if event is InputEventMouseMotion:
			var yy = deg2rad(event.relative.y * mouse_speed/2)
			head0_vec3.x += yy
			head0_vec3.x = clamp(head0_vec3.x, -0.5, 0.5)


			waist1_vec3.x += yy
			waist1_vec3.x = clamp(waist1_vec3.x, -0.5, 0.5)
#
#			var w = Input.is_action_pressed("w")
#			var a = Input.is_action_pressed("a")
#			var s = Input.is_action_pressed("s")
#			var d = Input.is_action_pressed("d")
#			if !w && !d && !a && !s:
			var xx = deg2rad(event.relative.x * mouse_speed/2)
			head0_vec3.y -= xx
			head0_vec3.y = clamp(head0_vec3.y, -0.5, 0.5)
			waist1_vec3.y -= xx
			waist1_vec3.y = clamp(waist1_vec3.y, -0.5, 0.5)
			rotation_degrees.y = -head0_vec3.y*150
func turn_around(dire:String) -> void:
	if dire == "left":
		rotation_degrees.y=45
		head0_vec3.z=0.15
		head0_vec3.y=-0.75
		waist1_vec3.z=0
		waist1_vec3.y=0
	if dire == "right":
		rotation_degrees.y=-45
		head0_vec3.z=-0.15
		head0_vec3.y=0.75
		waist1_vec3.z=0
		waist1_vec3.y=0
#		head1_vec3.z=-0.75
#		head1_vec3.y=-0.16
	if dire == "forward":
		rotation_degrees.y=0
		head0_vec3.z=0
		head0_vec3.y=0
		waist1_vec3.z=0
		waist1_vec3.y=0
#		head1_vec3.z=-0
#		head1_vec3.y=-0
	if dire == "default":
		head0_vec3.z=0
		waist1_vec3.z=0
		pass
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
			$"../../camera_node/camera_f/hand/Armature/Skeleton/arm/arm".show()
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
			$"../../camera_node/camera_f/hand/Armature/Skeleton/arm/arm".hide()
		if index == 3:
			$leg0_left.hide()
			$leg0_right.hide()
			$leg1_left.hide()
			$leg1_right.hide()
		if index == 4:
			$shoe_left.hide()
			$shoe_right.hide()
