extends Furnace

	
var img_front :=preload("res://script/wood_age/img/dirt_furnace0.png")
var img_other := preload("res://script/wood_age/img/dirt_furnace1.png")

var material_work = preload("res://assets/model/material.tres").duplicate()
var ani_list = [
	preload("res://script/wood_age/img/dirt_furnace2.png"),
	preload("res://script/wood_age/img/dirt_furnace3.png"),
	preload("res://script/wood_age/img/dirt_furnace4.png"),
	preload("res://script/wood_age/img/dirt_furnace5.png"),
	preload("res://script/wood_age/img/dirt_furnace6.png"),
]



func _ready() -> void:
	
	name_ = "dirt_furnace"
	export_grid = 1
	grid = 2
	fuel_grid = 1
	energy_offset = 1.0
	gui_name = "stone_furnace_node"
	block_tscn = preload("res://script/stone_age/model/stone_furnace.tscn")
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
	Overall.gui_node_node.change_ui("stone_furnace","dirt_furnace")
	return true

	
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
		if index > 4:index = 0
		material_work.albedo_texture = ani_list[index]



