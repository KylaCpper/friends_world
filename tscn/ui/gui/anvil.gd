extends GuiGrid
var name_ = "anvil"
var key := -1
var grid_tscn := preload("res://tscn/ui/grid/grid.tscn")
var table_list := []
var export_list := [{"name":"","num":0,"hp":0}]
var pros := [0,0]
var composite_own_rects := []

var model = {"hp":0}
var obj_script
var obj_pos3 : Vector3
func _init() -> void:
	grid = 2
	gird_path = "grid/bar"

var composites = Composite.anvil
func _ready() -> void:
	Overall.anvil_node = self
	$make_pro.value = 0
#	$export/make_num.hide()
#	check_rect()
#	connect("visibility_changed",self,"_on_visible")
#	$export/Button.connect("pressed",self,"_on_export_press")
#	$export/pro.value = 0.0
#	$next.connect("pressed",self,"_on_next")
#	$back.connect("pressed",self,"_on_back")

	var ii:= 0
	for composite in composites:
		var c_name = composite[0][0][0]
		var c_num = composite[0][0][1]
		var c_time = composite[1]
		var c_table = composite[2]
		var tscn = grid_tscn.instance()
		tscn.name = str(ii)
		
		
		var item = Item.get(c_name)
		if item.type == "block":
			Overall.photograph_node.set_texture(c_name,tscn.get_node("texture"))
		else:
			tscn.get_node("texture").texture = item.img
		tscn.get_node("num").text = str(c_num)
		tscn.get_node("num").show()
		
#		$result/num.text = str(c_num)
#		pro_time = get_make_time(composite)
#		result_obj.num = c_num
#		result_obj.name = c_name
#		var hp = Item.get_hp(name_)
#		result_obj.hp = hp
#		for name__ in c_table:
#			hp = Item.get_hp(name__)
#			list.append({"name":name__,"num":composite.table[name__],"hp":hp})
#			var tscn = grid_tscn.instance()
#			tscn.name = "bar"+str(grid)
#			$grid.add_child(tscn)
#			grid +=1
		
		if "hp" in item:
			table_list.append({"name":c_name,"num":c_num,"hp":item.hp})
		else:
			table_list.append({"name":c_name,"num":c_num,"hp":0})
		composite_own_rects.append(tscn)
		$scroll/grid.add_child(tscn)
		ii+=1

func show() -> void:
	$hp.max_value = int(Block.get(Block.get_name_from_id(model.id)).other)
	.show()
	var i :=0
	for data in model.list:
		list[i] = data
	
		i +=1
	i =0
	for data in model.export_list:
		export_list[i] = data
	
		i +=1
	pros=model.pros
	key = model.key
	
func hide() -> void:
	.hide()
func sync_model() -> void:
	if model.empty():return
	var i :=0
	for data in list:
		model.list[i] = data
	
		i +=1
	i =0
	for data in export_list:
		model.export_list[i] = data
	
		i +=1
	model.pros = pros
	model.key = key
	obj_script.update(obj_pos3)
	obj_script.sync_all(obj_pos3)
func update() -> void:
	if pros[1]:
		$make_pro.value = pros[0]/pros[1]*100
	else:
		$make_pro.value = 0
	$hp.value = model.hp
	$hp_text.text = str(model.hp)
	for i in range(list.size()):
		get_node("grid/num"+str(i)).hide()

		get_node(gird_path+str(i)+"/bg2").hide()
		if list[i].name=="" || list[i].num<=0:
			Overall.item_clear(list[i])
			get_node(gird_path+str(i)+"/texture").texture = null
			get_node(gird_path+str(i)+"/texture").hide()
			get_node(gird_path+str(i)+"/num").text = ""
			get_node(gird_path+str(i)+"/hp").hide()
				
		else:
			if  Item.get(list[i].name).type == "block":
				get_node(gird_path+str(i)+"/texture").show()
				Overall.photograph_node.set_texture(list[i].name,get_node(gird_path+str(i)+"/texture"))
				get_node(gird_path+str(i)+"/num").text = str(list[i].num)
				get_node(gird_path+str(i)+"/num").show()
				if list[i].hp > 0 && list[i].hp < Item.get_hp(list[i].name):
					get_node(gird_path+str(i)+"/hp").max_value = Item.get_hp(list[i].name)
					get_node(gird_path+str(i)+"/hp").value = list[i].hp
					get_node(gird_path+str(i)+"/hp").show()
				else:
					get_node(gird_path+str(i)+"/hp").hide()
			else:
				get_node(gird_path+str(i)+"/texture").show()
				get_node(gird_path+str(i)+"/texture").texture = Item.get(list[i].name).img
				get_node(gird_path+str(i)+"/num").text = str(list[i].num)
				get_node(gird_path+str(i)+"/num").show()
				if list[i].hp > 0 && list[i].hp < Item.get_hp(list[i].name):
					get_node(gird_path+str(i)+"/hp").max_value = Item.get_hp(list[i].name)
					get_node(gird_path+str(i)+"/hp").value = list[i].hp
					get_node(gird_path+str(i)+"/hp").show()
				else:
					get_node(gird_path+str(i)+"/hp").hide()
	update_export()
	if key == -1:return
	var i := 0
	
	for composite in composites[key][2]:
		get_node("grid/num"+str(i)).show()
		get_node("grid/num"+str(i)).text = "x"+str(composite[1])
		if i == 0:
			if composite[0] == list[0].name:
				if composite[1] <= list[0].num:
					get_node(gird_path+str(i)+"/bg2").hide()
				else:
					get_node(gird_path+str(i)+"/bg2").show()
			else:
				get_node(gird_path+str(i)+"/bg2").show()
		if i == 1:
			if composite[0] == list[1].name:
				if composite[1] <= list[1].num:
					get_node(gird_path+str(i)+"/bg2").hide()
				else:
					get_node(gird_path+str(i)+"/bg2").show()
			else:
				get_node(gird_path+str(i)+"/bg2").show()
		if !list[0].name:
			var texture_node = get_node(gird_path+str(i)+"/texture")
			texture_node.show()
			texture_node.texture = Item.get(composite[0]).img
		if !list[1].name:
			var texture_node = get_node(gird_path+str(i)+"/texture")
			texture_node.show()
			texture_node.texture = Item.get(composite[0]).img
		i += 1
func on_put(name_:String,index:int) -> void:
	sync_model()
func on_take(name_:String,index:int) -> void:
	sync_model()
func _on_mouse_right(index:int) -> void:
	._on_mouse_right(index)
func _on_mouse_left(index:int) -> void:
	._on_mouse_left(index)
func _on_mouse_left_move() -> void:
	._on_mouse_left_move()
func _on_mouse_left_restore() -> void:
	._on_mouse_left_restore()
func _on_mouse_entered(index:int) -> void:
	for i in range(grid):
		if index == i:
			get_node(gird_path+str(i)+"/bg").show()
		else:
			get_node(gird_path+str(i)+"/bg").hide()
	Overall.msg_grid_item_node.set_item(list[index])
	

func input_mouse(event:InputEvent,control) -> void:
	if control.mouse:
		var pos = event.position
		var i := 0
		if $scroll.get_global_rect().has_point(pos):
			for data in table_list:
				if composite_own_rects[i].get_global_rect().has_point(pos):
					#选择配方
					if control.mouse_button:
						if control.mouse_left:
							if key != i:
								key = i
								pros[0] = 0
								pros[1] = composites[key][1]
								update()
								sync_model()
						if control.mouse_right:
							if key == i:
								key = -1
								pros[0] = 0
								pros[1] = 0
								update()
								sync_model()
					composite_own_rects[i].get_node("bg").show()
					Overall.msg_grid_item_node.set_item(data)
				else:
					composite_own_rects[i].get_node("bg").hide()
					if Overall.msg_grid_item_node.name_ == data.name:
						Overall.msg_grid_item_node.set_item()
				if key == i:
					composite_own_rects[i].get_node("bg").show()
				i += 1
		else:
			for data in table_list:
				composite_own_rects[i].get_node("bg").hide()
				if key == i:
					composite_own_rects[i].get_node("bg").show()
				i += 1
		i = 0
		for data in export_list:
			if get_node("export"+str(i)).get_global_rect().has_point(pos):
				get_node("export"+str(i)+"/bg").show()
				Overall.msg_grid_item_node.set_item(data)
			else:
				get_node("export"+str(i)+"/bg").hide()
				if Overall.msg_grid_item_node.name_ == data.name:
					Overall.msg_grid_item_node.set_item()
			i +=1
		if control.mouse_button:
			if control.mouse_left:
				i = 0
				for data in export_list:
					if get_node("export"+str(i)).get_global_rect().has_point(pos):
						if !Overall.pick_item_node.is_item:
							Overall.pick_item_node.set_item(data.duplicate())
							Overall.item_clear(data)
							sync_model()
							get_node("export"+str(i)+"/texture").texture = null
							get_node("export"+str(i)+"/num").text = ""
						else:
							if Overall.pick_item_node.item.name == data.name && Overall.pick_item_node.item.hp==0:
								if Overall.pick_item_node.add(data.num,data.name) == 0:
									Overall.item_clear(data)
									sync_model()
									get_node("export"+str(i)+"/texture").texture = null
									get_node("export"+str(i)+"/num").text = ""
					i +=1


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
