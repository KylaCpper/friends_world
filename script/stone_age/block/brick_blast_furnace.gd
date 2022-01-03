extends Furnace
#de2,de<>1,-de0,-de<>3
var check_build_mat = "brick"
var check_build_vecs = [
	[Vector3(-1,2,0),"brick"],[Vector3(0,2,0),"brick"],[Vector3(1,2,0),"brick"],
	[Vector3(-1,1,0),"brick"],[Vector3(0,1,0),"brick"],[Vector3(1,1,0),"brick"],
	[Vector3(-1,0,0),"brick"],						[Vector3(1,0,0),"brick"],

	Vector3(-1,2,1),Vector3(0,2,1),Vector3(1,2,1),
	Vector3(-1,1,1),			Vector3(1,1,1),
	Vector3(-1,0,1),			Vector3(1,0,1),

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
var unbuilding_name := "brick_furnace"
func _check_building(pos3:Vector3) -> void:
	Terrain.check_building_forming(pos3,self)
func unbuilding(pos3:Vector3,dire:int) ->void:
	Overall.terrain_main_node.place(pos3,unbuilding_name,dire,false)
	
	
var material_work = preload("res://assets/model/material.tres").duplicate()

var img_front :=preload("res://script/stone_age/img/brick_blast_furnace0.png") 
var img_other := preload("res://script/stone_age/img/brick_blast_furnace1.png")
var ani_list = [
	preload("res://script/stone_age/img/brick_blast_furnace1.png"),
	preload("res://script/stone_age/img/brick_blast_furnace2.png"),
	preload("res://script/stone_age/img/brick_blast_furnace3.png"),
	preload("res://script/stone_age/img/brick_blast_furnace4.png"),
]





func _ready() -> void:
	
	name_ = "brick_blast_furnace"
	model = {
		"id":Block.get_id_from_name(name_),
		"list":[{"name":"","num":0,"hp":0},{"name":"","num":0,"hp":0},{"name":"","num":0,"hp":0}],
		"export_list":[{"name":"","num":0,"hp":0},{"name":"","num":0,"hp":0}],
		"fuel":"",
		"fuel_time":0.0,
		"make":[0,0],
		"make_time":0.0,
		"fueling":false,
		"making":false,
		"energy":0,
		"e":1.2
	}
	block_tscn = preload("res://script/stone_age/model/stone_blast_furnace.tscn")
	export_grid = 2
	grid = 3
	fuel_grid = 1
	energy_offset = 1.2
	gui_name = "stone_blast_furnace_node"
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
	Overall.gui_node_node.change_ui("stone_blast_furnace","brick_blast_furnace")
	return true


func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	._damage(pos3,block_name,dire)
	Terrain.unbuilding_noself(pos3,dire,self)


func play_ani(mesh) -> void:
	mesh.set_surface_material(1,material_work)
func stop_ani(mesh) -> void:
	mesh.set_surface_material(1,materials[1])
func update_ani_real(data,mesh) -> void:
	var model0 = mesh.get_node("model0")
	var model1 = mesh.get_node("model1")
	var name0 = data.export_list[0].name
	var name1 = data.export_list[1].name
	model0._show(name0)
	model1._show(name1)

var add := 1
func process_ani(delta:float) -> void:
	time += delta
	if time > 0.1:
		time = 0.0
		index += add
		if index < 0:
			index = 0
			add *= -1
		if index > 3:
			index = 3
			add *= -1
		material_work.albedo_texture = ani_list[index]


func fuel(data:Dictionary,pos3_arr:Array) -> void:
	if !is_make(data) && !data.make[0]:return
	if data.fuel_time == 0.0:
		var fuel_index = grid-fuel_grid
		if data.list[fuel_index].name:
#			var item = Item.get(data.list[fuel_index].name)
#			if "fuel" in item:
#				fuel_time = item.fuel
			data.fuel = data.list[fuel_index].name
			var fuel = Item.get(data.fuel).fuel
			if !"e" in data:
				data["e"] = energy_offset
			data.energy = fuel[0]*data.e
			data.fuel_time = fuel[1]
			data.fueling = true
			data.list[fuel_index].num -= 1
			if data.list[fuel_index].num <= 0:
				Overall.item_clear(data.list[fuel_index])
			next(data,pos3_arr)
			data.making = true
			check_ani(data,pos3_arr)
var dires = [
	[
		#0
		[Vector3(-2,0,-1),3],
		[Vector3(2,0,-1),1],
		[Vector3(0,0,-4),0],
	],
	[
		#1
		[Vector3(1,0,2),2],
		[Vector3(1,0,-2),0],
		[Vector3(4,0,0),1],
	],
	[
		#2
		[Vector3(-2,0,1),3],
		[Vector3(2,0,1),1],
		[Vector3(0,0,4),2],
	],
	[
		#3
		[Vector3(-1,0,2),2],
		[Vector3(-1,0,-2),0],
		[Vector3(-4,0,0),3],
	]
]
func _multe_update(pos3:Vector3) -> void:
#	var dire = Block.get_dire(Overall.terrain_main_node.get_id(pos3))
	var pos3_arr = Function.vec_arr(pos3)
	var data = list[pos3_arr]
	if !"e" in data:
		data["e"] = energy_offset
	var p = Terrain.find_conform_block(pos3,dires,"wood_blower")
	if p:
		var script = Block.get("wood_blower").script
		if script.is_start(p):
			
			if data.e == 1.2:
				data.e = 1.3
				if data.energy:
					var fuel = Item.get(data.fuel).fuel
					data.energy = fuel[0]*data.e
			data.e = 1.3
		else:
			if data.e == 1.3:
				data.e = 1.2
				if data.energy:
					var fuel = Item.get(data.fuel).fuel
					data.energy = fuel[0]*data.e
			data.e = 1.2
				
	else:
		data.e = 1.2

