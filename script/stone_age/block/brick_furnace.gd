extends Furnace
#de2,de<>1,-de0,-de<>3

#x <> y
#-z  x<>y
#-x x<>y
var check_build_mat = "brick"
var check_build_vecs = [
	[Vector3(-1,2,0),"brick"],[Vector3(0,2,0),"brick"],[Vector3(1,2,0),"brick"],
	[Vector3(-1,1,0),"brick"],[Vector3(0,1,0),"brick"],[Vector3(1,1,0),"brick"],
	[Vector3(-1,0,0),"brick"],							[Vector3(1,0,0),"brick"],

	Vector3(-1,2,1),Vector3(0,2,1),Vector3(1,2,1),
	Vector3(-1,1,1)					,Vector3(1,1,1),
	Vector3(-1,0,1),				Vector3(1,0,1),

	Vector3(-1,2,2),Vector3(0,2,2),Vector3(1,2,2),
	Vector3(-1,1,2),Vector3(0,1,2),Vector3(1,1,2),
	Vector3(-1,0,2),Vector3(0,0,2),Vector3(1,0,2),

]
var build_mat = "brick_blast_furnace_brick"
var build_vecs = [
	[Vector3(-1,2,0),"brick_blast_furnace_brick"],[Vector3(0,2,0),"brick_blast_furnace_brick"],[Vector3(1,2,0),"brick_blast_furnace_brick"],
	[Vector3(-1,1,0),"brick_blast_furnace_brick"],[Vector3(0,1,0),"brick_blast_furnace_brick"],[Vector3(1,1,0),"brick_blast_furnace_brick"],
	[Vector3(-1,0,0),"brick_blast_furnace_brick"],												[Vector3(1,0,0),"brick_blast_furnace_brick"],

	Vector3(-1,2,1),Vector3(0,2,1),Vector3(1,2,1),
	Vector3(-1,1,1),				Vector3(1,1,1),
	Vector3(-1,0,1),				Vector3(1,0,1),

	Vector3(-1,2,2),Vector3(0,2,2),Vector3(1,2,2),
	Vector3(-1,1,2),Vector3(0,1,2),Vector3(1,1,2),
	Vector3(-1,0,2),Vector3(0,0,2),Vector3(1,0,2),

]
var building_name := "brick_blast_furnace"
func _check_building(pos3:Vector3) -> void:
	Terrain.check_building(pos3,self)
func building(pos3:Vector3,dire:int) ->void:
	Overall.terrain_main_node.place(pos3,building_name,dire,false)
	
var img_front :=preload("res://script/stone_age/img/brick_furnace0.png")
var img_other := preload("res://script/stone_age/img/brick_furnace1.png")

var material_work = preload("res://assets/model/material.tres").duplicate()
var ani_list = [
	preload("res://script/stone_age/img/brick_furnace2.png"),
	preload("res://script/stone_age/img/brick_furnace3.png"),
	preload("res://script/stone_age/img/brick_furnace4.png"),
	preload("res://script/stone_age/img/brick_furnace5.png"),
	preload("res://script/stone_age/img/brick_furnace6.png"),
]



func _ready() -> void:
	name_ = "brick_furnace"
	model = {
		"id":Block.get_id_from_name(name_),
		"list":[{"name":"","num":0,"hp":0},{"name":"","num":0,"hp":0}],
		"export_list":[{"name":"","num":0,"hp":0}],
		"fuel":"",
		"fuel_time":0.0,
		"make":[0,0],
		"make_time":0.0,
		"fueling":false,
		"making":false
	}
	export_grid = 1
	grid = 2
	fuel_grid = 1
	energy_offset = 1.0
	gui_name = "stone_furnace_node"
	
	materials[0].albedo_texture = img_other
	materials[1].albedo_texture = img_front
	materials[2].albedo_texture = img_other
	materials[3].albedo_texture = img_other
	materials[4].albedo_texture = img_other
	materials[5].albedo_texture = img_other
	init()
	Overall.connect("_process",self,"_process")
func _event(world_pos3:Vector3,block_name:String,dire:int) -> bool:
	._event(world_pos3,block_name,dire)
	Overall.gui_node_node.change_ui("stone_furnace","brick_furnace")
	return true

func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	._place(pos3,block_name,dire)
	_check_building(pos3)
	
func play_ani(mesh) -> void:
	mesh.set_surface_material(1,material_work)
func stop_ani(mesh) -> void:
	mesh.set_surface_material(1,materials[1])
func update_ani_real(data,mesh) -> void:
	var model0 = mesh.get_node("model0")
	var model1 = mesh.get_node("model1")
	var name0 = data.export_list[0].name
	var name1 = data.list[0].name
	model0._show(name0)
	model1._show(name1)


func process_ani(delta:float) -> void:
	time += delta
	if time > 0.1:
		time = 0.0
		index += 1
		if index > ani_list.size()-1:index = 0
		material_work.albedo_texture = ani_list[index]



