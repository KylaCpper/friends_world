extends GuiGrid
var name_ := ""
var export_list = [{"name":"","num":0,"hp":0},{"name":"","num":0,"hp":0}]
var fuel_grid = 1
var fuel_time_max := 0.0
var fuel_time := 0.0
var make := [0,0]
var make_table := {}
var make_time := 0.0
var pos3 = Vector3(0,0,0)
var working := false
var table_name := "stone_furnace"
var energy_offset := 1.0
var energy := 0.0
func _init() -> void:
	grid = 3
	

func _ready() -> void:
	$energy.text = str(0.0)
	hide()
	$warning.hide()
#	$Button.connect("pressed",self,"_on_export_press")
	$make_pro.value = 0.0
	$fuel_pro.value = 0.0
	$arrow.value = 0.0
#	$next.connect("pressed",self,"_on_next")
#	$back.connect("pressed",self,"_on_back")
	set_process(false)
#func _on_next() -> void:
#	var composites = Composite.get_table_small(name_)
#	var size = composites.size()
#	$back.show()
#	if page+2 >= size:
#		$next.hide()
#	if page+1 < size:
#		page += 1
#	update()
#func _on_back() -> void:
#	var composites = Composite.get_table_small(name_)
#	var size = composites.size()
#	if size>1:
#		$next.show()
#
#	if page-1 <= 0:
#		$back.hide()
#	if page > 0:
#		page -= 1
#	update()
func show() -> void:
	
	set_process(true)
	.show()
func hide() -> void:
	set_process(false)
#	clear()
	.hide()
func update(u:=true) -> void:
	var pos3_arr= Function.vec_arr(pos3)
	var box = Terrain.get_save_from_pos3(pos3)
	if box:
		if u:
			Item.get(table_name).script.update(box,pos3)
		var data = Terrain.get_save_from_pos3(pos3)
		var fuel_time = data.fuel_time
		if data.fueling:
			fuel_time_max = Item.get(data.fuel).fuel[1]
		if !fuel_time_max:fuel_time_max = 1.0
#			fuel_time_max = Item.get(data.fuel).time
		var make_time = data.make_time
		if data.make[0]:
			var make_table = Composite.furnace[data.make[0]][data.make[1]]
			$make_pro.value = make_time*100/make_table.time
			$arrow.value = $make_pro.value
		else:
			$make_pro.value = 0.0
			$arrow.value = 0.0
		
		$fuel_pro.value = fuel_time*100/fuel_time_max
			
		list = data.list
		export_list = data.export_list
#	work()
#	make()
	update_export()
	.update()
func on_put(name_:String,index:int) -> void:
	var pos3_arr= Function.vec_arr(pos3)
	var box = Terrain.get_save_from_pos3(pos3)
	if box:
		if box.fueling:
			if box.make[0]:
				var make_table = Composite.furnace[box.make[0]][box.make[1]]
				if box.energy < make_table.energy:
					box.make[0]=""
					Item.get(table_name).script.update(box,pos3)
func on_take(name_:String,index:int) -> void:
	var pos3_arr= Function.vec_arr(pos3)
	var box = Terrain.get_save_from_pos3(pos3)
	if box:
		if box.fueling:
			if box.make[0]:
				var make_table = Composite.furnace[box.make[0]][box.make[1]]
				if box.energy < make_table.energy:
					box.make[0]=""
					Item.get(table_name).script.update(box,pos3)
#	._on_mouse_left(index)

#func is_make() -> bool:
#	var size := 0
#	var grid_com = grid-fuel_grid
#	for i in range(grid_com):
#		if list[i].name:
#			size = size+1
#	if size in  Composite.furnace && size >0:
#		var composites = Composite.furnace[size]
#		for d in composites:
#			var tables = d.table
#			var have := {}
#			for table in tables:
#				for i in range(grid_com):
#					if !i in have:
#						if table[0] == list[i].name:
#							have[i] = [table[0],table[1]]
#							break
#				if have.size() >= grid_com:break
#			if tables.size() == have.size():
#				return true
#	return false
	
#	var composites = Composite.get_table_furnace(table_name)
#	for key in composites:
#		var table = composites[key]
#		var have := {}
#		var grid_com = grid-fuel_grid
#		for data in table.table:
#			for i in range(grid_com):
#				if !i in have:
#					if data == list[i].name:
#						have[i] = data
#						break
#			if have.size() >= grid_com:break
#		if table.table.size() == have.size():
#			return true
#	return false
#func make() -> void:
#	if make[0] || !working:return
#	var size := 0
#	var grid_com = grid-fuel_grid
#	for i in range(grid_com):
#		if list[i].name:
#			size = size+1
#	if size in  Composite.furnace && size >0:
#		var composites = Composite.furnace[size]
#		var keyi := 0
#		for d in composites:
#			var tables = d.table
#			var have := {}
#			for table in tables:
#				for i in range(grid_com):
#					if !i in have:
#						if table[0] == list[i].name:
#							have[i] = [table[0],table[1]]
#							break
#				if have.size() >= grid_com:break
#			if tables.size() == have.size():
#				make[0] = size
#				make[1] = keyi
#				make_table = d
#				for index in have:
#					list[index].num -= have[index][1]
#					if list[index].num <=0 :
#						Overall.item_clear(list[index])
#				$make_pro.value = 0.0
#				$arrow.value = 0.0
#				update()
#
#				break
#			keyi = keyi +1
#	var composites = Composite.get_table_furnace(table_name)
#	for key in composites:
#		var table = composites[key]
#		var have := {}
#		var grid_com = grid-fuel_grid
#		for data in table.table:
#			for i in range(grid_com):
#				if !i in have:
#					if data == list[i].name:
#						have[i] = data
#						break
#			if have.size() >= grid_com:break
#		if table.table.size() == have.size():
#			make[0] = key
#			make_table = table
#			for index in have:
#				list[index].num -= 1
#				if list[index].num <=0 :
#					Overall.item_clear(list[index])
#			$make_pro.value = 0.0
#			$arrow.value = 0.0
#			update()
#			break

#func work() -> void:
#	if !is_make() && !make[0]:return
#	if fuel_time == 0.0:
#		if list[grid-1].name:
#			var item = Item.get(list[grid-1].name)
##			if "fuel" in item:
##				fuel_time = item.fuel
##				fuel_time_max = item.fuel
#			fuel_time = 10
#			fuel_time_max = 10
#			working = true
#			list[grid-1].num -= 1
#			if list[grid-1].num <= 0:
#				Overall.item_clear(list[grid-1])
#			set_process(true)



#func maked() -> void:
#	if make[0]:
#		for data1 in make_table["export"]:
#			var data = data1.duplicate()
#			var drop := true
#			if !(Function.rand()<data[2]):
#				drop = false
#			if drop:
#				if data[3]:break
#				for i in range(export_list.size()-1):
#					if i < export_list.size()-1:
#						if export_list[i].name:
#							if export_list[i].name == data[0]:
#								var item = Item.get(export_list[i].name)
#								export_list[i].num += data[1]
#								if export_list[i].num > item["max"]:
#									data[1] = export_list[i].num - item["max"]
#									export_list[i].num = item["max"]
#								else:
#									break
#						else:
#							export_list[i].name = data[0]
#							export_list[i].num = data[1]
#							break
#					else:
#						if export_list[i].name:
#							if export_list[i].name == data[0]:
#								var item = Item.get(export_list[i].name)
#								export_list[i].num += data[1]
#								if export_list[i].num > item["max"]:
#									data[1] = export_list[i].num - item["max"]
#									Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),1.1,randf()),{"name":data[0],"num":data[1]},Vector3(0,1,0))
#									export_list[i].num = item["max"]
#							else:
#								Overall.terrain_node_node.drop_force(pos3+Vector3(randf(),1.1,randf()),{"name":data[0],"num":data[1]},Vector3(0,1,0))
#						else:
#							export_list[i].name = data[0]
#							export_list[i].num = data[1]
#					var item = Item.get(export_list[i].name)
#					if item.type == "tool":
#						export_list[i].hp = item.hp
#
#		make_time = 0.0
#		$make_pro.value = 0.0
#		$arrow.value = 0.0
#		make = [0,0]
#		update()
func _process(delta:float) -> void:
#	var pos3_arr = Function.vec_arr(pos3)
	var box = Terrain.get_save_from_pos3(pos3)
	if box:
#		Item.get("stone_furnace").script.update(Save.world.box[pos3_arr])
		var data = box
		var fuel_time = data.fuel_time
		var item = Item.get(data.fuel)
		var fuel_time_max = 1.0
		if item:
			if "fuel" in item:
				fuel_time_max = item.fuel[1]
		if !data.fueling:
			data.energy=0.0
			
		$energy.text = str(data.energy)
			
		if !fuel_time_max:fuel_time_max = 1.0
#		fuel_time_max = Item.get(data.fuel).time
		var make_time = data.make_time
		if data.fueling:
			if data.make[0]:
				var make_table = Composite.furnace[data.make[0]][data.make[1]]
				if data.energy >= make_table.energy:
					$warning.hide()
					$make_pro.value = make_time*100/make_table.time
					$arrow.value = $make_pro.value
				else:
					$warning.show()
					$make_pro.value = 0.0
					$arrow.value = 0.0
			else:
				$warning.hide()
				$make_pro.value = 0.0
				$arrow.value = 0.0
		else:
			$warning.hide()
			$make_pro.value = 0.0
			$arrow.value = 0.0
#		if data.make[0] && data.fueling:
#			var make_table = Composite.furnace[data.make[0]][data.make[1]]
#			if data.energy >= make_table.energy:
#				$warning.hide()
#			else:
#				$warning.show()
#			$make_pro.value = make_time*100/make_table.time
#			$arrow.value = $make_pro.value
#		else:
#			$warning.hide()
#			$make_pro.value = 0.0
#			$arrow.value = 0.0
		$fuel_pro.value = fuel_time*100/fuel_time_max
	else:
		$warning.hide()
		$energy.text = "0.0"
func input_mouse(event:InputEvent,control) -> void:
	if control.mouse:
		var pos = event.position
#		if $result.get_global_rect().has_point(pos):
#			$result/bg.show()
#			Overall.msg_grid_item_node.set_item(result_obj)
#		else:
#			$result/bg.hide()
#
#			if Overall.msg_grid_item_node.name_ == result_obj.name:
#				Overall.msg_grid_item_node.set_item()
#		if $export.get_global_rect().has_point(pos):
#			$export/bg.show()
#			Overall.msg_grid_item_node.set_item(export_obj)
#		else:
#			$export/bg.hide()
#			if Overall.msg_grid_item_node.name_ == export_obj.name:
#				Overall.msg_grid_item_node.set_item()
		var i = 0
		for data in export_list:
			var export_node = get_node("export"+str(i))
			if export_node.get_global_rect().has_point(pos):
				mouse_left_entered(export_list[i],export_node)
			else:
				mouse_left_exited(export_list[i],export_node)
			i+=1
		if control.mouse_button:
			if control.mouse_left:
				var ii = 0
				for data in export_list:
					var export_node = get_node("export"+str(ii))
					if export_node.get_global_rect().has_point(pos):
						mouse_left_confine(export_list[ii])
						update()
					ii+=1

func update_export() -> void:
	var i = 0
	for data in export_list:
		var export_num_node = get_node("export"+str(i)+"/num")
		var export_texture_node = get_node("export"+str(i)+"/texture")
		if data.name:
			if Item.get(data.name).type == "block":
				Overall.photograph_node.set_texture(data.name,export_texture_node)
			else:
				export_texture_node.texture = Item.get(data.name).img
			export_num_node.text = str(data.num)
			export_num_node.show()
		else:
			export_num_node.hide()
			export_texture_node.texture = null
			export_num_node.text = ""
		i+=1

func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	position += diff_size
