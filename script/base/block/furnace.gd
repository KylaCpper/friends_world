extends Advanced_Block
class_name Furnace
#de2,de<>1,-de0,-de<>3

#x <> y
#-z  x<>y
#-x x<>y
#上前左下右后





var export_grid = 1
var grid = 2
var fuel_grid = 1
var energy_offset = 1.0
var done := false
var gui_name = "stone_furnace_node"
func init_c(pos3,key3) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	check_ani(list[key3],pos3_arr)
func _event(world_pos3:Vector3,block_name:String,dire:int) -> bool:
	var pos3 = Overall.terrain_main_node.get_block_pos3(world_pos3)
	var gui_node = Overall[gui_name]
	gui_node.pos3 = pos3
	var pos3_arr = Function.vec_arr(pos3)
	if !Terrain.is_in(pos3):
		Terrain.set_box(pos3,self)
	gui_node.list = list[pos3_arr].list
	gui_node.export_list = list[pos3_arr].export_list
	gui_node.table_name = name_
	gui_node.update()
	
	Overall.rpc_item_script(block_name,"u_c",[pos3_arr,list[pos3_arr]])

	return true
func g_d() -> void:
	pass

func _place(pos3:Vector3,block_name:String,dire:int) -> void:

	._place(pos3,block_name,dire)
	var pos3_arr = Function.vec_arr(pos3)
	Terrain.set_box(pos3,self)
#	Save.world.box[pos3_arr] = model.duplicate(true)
#	list[pos3_arr] = Save.world.box[pos3_arr]
	Overall.rpc_item_script(block_name,"_place_client",[pos3_arr])

func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	._damage(pos3,block_name,dire)
	var pos3_arr = Function.vec_arr(pos3)
	if pos3_arr in list:
		if Net.is_master():
			for data in list[pos3_arr].list:
				Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),randf(),randf()),data,Vector3(0,1,0))
			for data in list[pos3_arr].export_list:
				Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),randf(),randf()),data,Vector3(0,1,0))
			if list[pos3_arr].make[0]:
				var tables = Composite.furnace[list[pos3_arr].make[0]][list[pos3_arr].make[1]].table
				for table in tables:
					Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),randf(),randf()),{"name":table[0],"num":table[1]},Vector3(0,1,0))
		if list[pos3_arr].id == model.id:
			Terrain.del_box(pos3,self)
#			Save.world.box.erase(pos3_arr)
#			list.erase(pos3_arr)
	Overall.rpc_item_script(block_name,"_damage_client",[pos3_arr])
func update(data:Dictionary,pos3:Vector3) -> void:
	var pos3_arr = Function.vec_arr(pos3)
	Overall.rpc_item_script(name_,"u_c",[pos3_arr,data])
	fuel(data,pos3_arr)
	make(data,pos3_arr)
	check_ani(data,pos3_arr)
func check_ani(data:Dictionary,pos3_arr:Array) -> void:
	var pos3 = Function.arr_vec(pos3_arr)
	var mesh = Overall.chunks_node_node.get_block_real(pos3)
	if mesh:
		if data.fueling:
			play_ani(mesh)
		else:
			stop_ani(mesh)
		update_ani_real(data,mesh)


func play_ani(mesh) -> void:
	pass
func stop_ani(mesh) -> void:
	pass
func update_ani_real(data,mesh) -> void:
	pass
func next(data:Dictionary,pos3_arr:Array) -> void:
	if Overall[gui_name].pos3 == Function.arr_vec(pos3_arr):
		Overall[gui_name].update(false)
	fuel(data,pos3_arr)
	make(data,pos3_arr)


var index := 0
var time := 0.0
func _process(delta:float) -> void:
	process_ani(delta)

	for key in list:
		var data = list[key]
		if data.making:
			
			data.fuel_time -= delta
			if data.fuel_time < 0.0:
				data.fuel_time = 0.0
				
				data.fueling = false
				fuel(data,key)
				make(data,key)
				check_ani(data,key)
			if data.make[0]:
				var make_table = Composite.furnace[data.make[0]][data.make[1]]
				if data.fuel_time > 0.0:
					if data.energy >= make_table.energy:
						data.make_time += delta*(data.energy/make_table.energy)
					else:
						data.make_time = 0.0
					
		#			$make_pro.value = make_time*100/make_table.time
		#			$arrow.value = $make_pro.value
					if data.make_time >=  make_table.time:
						maked(data,key)
						fuel(data,key)
						make(data,key)
						check_ani(data,key)
				else:
					if data.make_time < make_table.time:
						data.make_time -= delta
						if data.make_time <= 0.0 : 
							data.making = false
							data.make_time = 0.0
		#				$make_pro.value = make_time*100/make_table.time
		#				$arrow.value = $make_pro.value
			else:
				if data.fuel_time == 0.0:
					data.making = false
					pass
#		var fuel_time_max = Item.get(data.fuel).fuel
	#	$fuel_pro.value = fuel_time*100/fuel_time_max
func process_ani(delta:float) -> void:
	pass
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
			data.energy = fuel[0]*energy_offset
			data.fuel_time = fuel[1]
			data.fueling = true
			data.list[fuel_index].num -= 1
			if data.list[fuel_index].num <= 0:
				Overall.item_clear(data.list[fuel_index])
			next(data,pos3_arr)
			data.making = true
			check_ani(data,pos3_arr)
func is_make(data:Dictionary) -> bool:
	var size := 0
	for i in range(grid-fuel_grid):
		if data.list[i].name:
			size = size+1
	if size in Composite.furnace && size >0:
		var composites = Composite.furnace[size]
		for d in composites:
#			if data.energy >= d.energy:
				var tables = d.table
				var have := {}
				for table in tables:
					for i in range(grid-fuel_grid):
						if !i in have:
							if table[0] == data.list[i].name:
								if table[1] <= data.list[i].num:
									have[i] = [table[0],table[1]]
									break
				if tables.size() == have.size():
					return true
	return false
func make(data:Dictionary,pos3_arr:Array) -> void:
	if data.make[0] || !data.fueling:return
	var size := 0
	for i in range(grid-fuel_grid):
		if data.list[i].name:
			size = size+1
	if size in Composite.furnace && size >0:
		var composites = Composite.furnace[size]
		var keyi := 0
		for d in composites:
#			if data.energy >= d.energy:
			var tables = d.table
			var have := {}
			for table in tables:
				for i in range(grid-fuel_grid):
					if !i in have:
						if table[0] == data.list[i].name:
							if table[1] <= data.list[i].num:
								have[i] = [table[0],table[1]]
								break
			if tables.size() == have.size():
				data.make = [size,keyi]
				for index in have:
#					if data.energy >= d.energy:
					data.list[index].num -= have[index][1]
					if data.list[index].num <=0 :
						Overall.item_clear(data.list[index])
					next(data,pos3_arr)
				break
			
			keyi = keyi+1
#	for key in composites:
#		var table = composites[key]
#		var have := {}
#		for name_ in table.table:
#			for i in range(grid-fuel_grid):
#				if !i in have:
#					if name_ == data.list[i].name:
#						have[i] = name_
#						break
#		if table.table.size() == have.size():
#			data.make = key
#			for index in have:
#				data.list[index].num -= 1
#				if data.list[index].num <=0 :
#					Overall.item_clear(data.list[index])
#				next(data,pos3_arr)
#
#			break

func maked(data:Dictionary,pos3_arr:Array) -> void:
	if data.make[0]:

		var export_list = data.export_list
		var make_table = Composite.furnace[data.make[0]][data.make[1]]
		if data.energy >= make_table.energy:
			for _export_ in make_table["export"]:
				var export_ = _export_.duplicate(true)
				var drop := true
				if !(Function.rand()<export_[2]):
					drop = false
				if drop:
					if export_[3]:break
					for i in range(export_list.size()):
						if i < export_grid-1:
							if export_list[i].name:
								if export_list[i].name == export_[0]:
									var item = Item.get(export_list[i].name)
									export_list[i].num += export_[1]
									if export_list[i].num > item["max"]:
										export_[1] = export_list[i].num - item["max"]
										export_list[i].num = item["max"]
									else:
										break
							else:
								export_list[i].name = export_[0]
								export_list[i].num = export_[1]
								break
						else:
							if export_list[i].name:
								var pos3 = Function.arr_vec(pos3_arr)
								if export_list[i].name == export_[0]:
									var item = Item.get(export_list[i].name)
									export_list[i].num += export_[1]
									if export_list[i].num > item["max"]:
										export_[1] = export_list[i].num - item["max"]
										if Net.is_master():
											Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),1.1,randf()),{"name":export_[0],"num":export_[1]},Vector3(0,1,0))
										export_list[i].num = item["max"]
								else:
									if Net.is_master():
										Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),1.1,randf()),{"name":export_[0],"num":export_[1]},Vector3(0,1,0))
							else:
								export_list[i].name = export_[0]
								export_list[i].num = export_[1]
						var item = Item.get(export_list[i].name)
						if item.type == "tool":
							export_list[i].hp = item.hp
							
		data.make_time = 0.0
		data.make = [0,0]
		next(data,pos3_arr)
		
#client
func _place_client(args:Array) -> void:
	var pos3_arr = args[0]
	Terrain.set_box_arr(pos3_arr,self)
#	Save.world.box[pos3_arr] = model.duplicate(true)
#	list[pos3_arr] = Save.world.box[pos3_arr]
func _damage_client(args:Array) -> void:
	var pos3_arr = args[0]
	Terrain.del_box_arr(pos3_arr,self)
func u_c(args:Array) -> void:
	var pos3_arr = args[0]
	var data = args[1]
	var pos3 = Vector3(pos3_arr[0],pos3_arr[1],pos3_arr[2])
	var box = Terrain.get_save_from_id(pos3,model.id)
	if !box:return
	for key in data:
		if key == "list" || key == "export_list":
			var i = 0
			for data1 in data[key]:
				box[key][i].name = data1.name
				box[key][i].num = data1.num
				box[key][i].hp = data1.hp
				i+=1
		else:
			box[key] = data[key]

	next(box,pos3_arr)
