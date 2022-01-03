extends GuiGrid

var current_index :=0

var tab_tscn := preload("res://tscn/ui/composite/tab0.tscn")
var grid_tscn := preload("res://tscn/ui/grid/grid.tscn")
var name_ := "default"
var tab_list := []


func _init() -> void:
	grid = 2
	gird_path = "scroll/grid/bar"
func _ready() -> void:
	$scroll/grid.rect_position.y = 2
	Overall.composite_node = self
	init_list_all()
#	$tabs.connect("tab_changed",self,"_on_change")
	$tabs.connect("tab_selected",self,"_on_selected")
func init_list_all() -> void:
	tab_list.clear()
	for node in $tabs.get_children():
		node.free()

	var i = 0
	var composite = Composite.data

	for key in Config.AGES_ORDER:
		if composite[key][name_].size()>0:
			var tscn = tab_tscn.instance()
			tscn.name = str(i)
			$tabs.add_child(tscn)
			$tabs.set_tab_title(i,Config.AGES[key].name)
			tab_list.append(Config.AGES[key])
			
			
			i += 1

	check_list()
func init_list_age() -> void:
	return
#	tab_list.clear()
#	for node in $tabs.get_children():
#		node.name += "_"
#		node.free()
#
#	var icon_num = Overall.age_list.size()
#	for i in range(icon_num):
#		var tscn = tab_tscn.instance()
#		tscn.name = str(i)
#		$tabs.add_child(tscn)
#		$tabs.set_tab_icon(i,Config.TABLE_ICONS[Overall.age_list[i]])
#		$tabs.set_tab_title(i,"")
#		tab_list.append(Overall.age_list[i])
func check_list() -> void:
	
	var i = 0
	for age_list in tab_list:
#		if Overall.age_list.find(tab_age) != -1:
		$tabs.set_tab_disabled(i,false)
		if i == current_index:
			$tabs.set_tab_title(i,age_list.name)
		$tabs.set_tab_icon(i,age_list.img)
#		else:
#			$tabs.set_tab_disabled(i,true)
#			$tabs.set_tab_title(i,tr("unknown"))
#			$tabs.set_tab_icon(i,Config.TABLE_ICONS[tab_age][1])
		i += 1
func _on_change(index_be:int) -> void:
	var index = int($tabs.get_current_tab_control().name)
	var tab_index = $tabs.get_previous_tab()
#	if Overall.age_list.find(tab_list[tab_index]) != -1:
#		$tabs.set_tab_title(index_be,"")
#		$tabs.set_tab_disabled(index_be,false)
#		$tabs.set_tab_icon(index_be,Config.TABLE_ICONS[tab_list[tab_index]][0])
#	else:
#		$tabs.set_tab_title(index_be,tr("unknown"))
#		$tabs.set_tab_disabled(index_be,true)
#		$tabs.set_tab_icon(index_be,Config.TABLE_ICONS[tab_list[tab_index]][1])

	
#	if Overall.age_list.find(tab_list[index]) != -1:
	$tabs.set_tab_title(index_be,tab_list[index].name)
	$tabs.set_tab_disabled(index_be,false)
	$tabs.set_tab_icon(index_be,tab_list[index].img)
#	else:
#		$tabs.set_tab_title(index_be,tr("unknown"))
#		$tabs.set_tab_disabled(index_be,true)
#		$tabs.set_tab_icon(index_be,Config.TABLE_ICONS[tab_list[index]][1])


	if current_index == index :
		return
	current_index = index
#	Overall.composite_info_node.update()
	change(index)

func _on_selected(index_be:int) -> void:
	if !permission:return
	var index = int($tabs.get_current_tab_control().name)
	var tab_index = $tabs.get_previous_tab()
	if $tabs.get_tab_disabled(index_be):
		index = -1
		clear()
		current_index = index
		return

#	if Overall.age_list.find(tab_list[tab_index]) != -1:
#	$tabs.set_tab_title(index_be,"")
#	$tabs.set_tab_disabled(index_be,false)
	$tabs.set_tab_icon(index_be,tab_list[tab_index].img)
#	else:
#		$tabs.set_tab_title(index_be,tr("unknown"))
#		$tabs.set_tab_disabled(index_be,true)
#		$tabs.set_tab_icon(index_be,Config.TABLE_ICONS[tab_list[tab_index]][1])

	
#	if Overall.age_list.find(tab_list[index]) != -1:
	$tabs.set_tab_title(index_be,tab_list[index].name)
	$tabs.set_tab_disabled(index_be,false)
	$tabs.set_tab_icon(index_be,tab_list[index].img)
#	else:
#		$tabs.set_tab_title(index_be,tr("unknown"))
#		$tabs.set_tab_disabled(index_be,true)
#		$tabs.set_tab_icon(index_be,Config.TABLE_ICONS[tab_list[index]][1])


	if current_index == index :
		return
	current_index = index
#	Overall.composite_info_node.update()
	change(index)

func show():
	visible = true
	var i = 0
	
	change(current_index)
func update_c(table_big) -> void:
	
	var unmake_queue := []
	var can_index := 0
	var i :=0
	var grid_node = get_node("scroll/grid")
	for key in table_big:
		var tscn = grid_tscn.instance()
		tscn.name = "bar"+str(i)
		var table_smalls = table_big[key]
		var size = 0
		for table_small in table_smalls:
			var is_make = is_make(table_small)
			var item = Item.get(key)
			var hp :=0.0
			if "hp" in item:
				hp = item.hp
			if is_make:
				can_index+=1
				list.append({"name":item.key,"num":table_small.num,"hp":hp})
				break
			else:
				size+=1
				if size == table_smalls.size():
					unmake_queue.append({"name":item.key,"num":table_small.num,"hp":hp})
		grid_node.add_child(tscn)
		i = i+1
	for data in unmake_queue:
		list.append(data)
	unmake_queue.clear()

	i =0
	for key in table_big:
		var node = get_node(gird_path+str(i))
		own_rects.append(node)
		var bg2_n = node.get_node("bg2")
		var num_n = node.get_node("num")
		bg2_n.hide()
		num_n.modulate = Config.COLCOR
		if i >= can_index:
			bg2_n.show()
			num_n.modulate = Config.COLCOR2
		i = i+1
	update()
func change(index:int) -> void:
	clear()
#	Overall.composite_info_node.hide()
	yield(get_tree(),"idle_frame")
	
	var table_big = Composite.get_table_big(name_,tab_list[index].key)
	update_c(table_big)

func update_change() -> void:
	clear_change()
	yield(get_tree(),"idle_frame")
	var table_big = Composite.get_table_big(name_,tab_list[current_index].key)

	var unmake_queue := []
	var can_index := 0
	var i :=0

	for key in table_big:
		var table_smalls = table_big[key]
		var size = 0
		for table_small in table_smalls:
			var is_make = is_make(table_small)
			var item = Item.get(key)
			var hp :=0.0
			if "hp" in item:
				hp = item.hp
			if is_make:
				can_index+=1
				list.append({"name":item.key,"num":table_small.num,"hp":hp})
				break
			else:
				size+=1
				if size == table_smalls.size():
					unmake_queue.append({"name":item.key,"num":table_small.num,"hp":hp})
	for data in unmake_queue:
		list.append(data)
	unmake_queue.clear()
	i =0
	yield(get_tree(),"idle_frame")
	for key in table_big:
		var node = get_node(gird_path+str(i))
#		own_rects.append(node)
		var bg2_n = node.get_node("bg2")
		var num_n = node.get_node("num")
		bg2_n.hide()
		num_n.modulate = Config.COLCOR
		if i >= can_index:
			bg2_n.show()
			num_n.modulate = Config.COLCOR2
		i+=1
	update()
func change_permission(be:bool) -> void:
	if be:
		$tabs.mouse_filter = 0
	else:
		$tabs.mouse_filter = 2
func is_make(composite) -> bool:
	var sub_list = []
	for name___ in composite.table:
		sub_list.append({"name":name___,"num":composite.table[name___],"hp":Item.get_hp(name___)})
	if Overall.bag_node.is_items(sub_list):
		return true
	else:
		return false
		
func clear() -> void:
	for obj in get_node("scroll/grid").get_children():
		obj.free()
	list = []
	own_rects = []
	grid = 0
func clear_change() -> void:
	list = []
#	own_rects = []
func _on_mouse_right(index) -> void:
	_on_mouse_left(index)
func _on_mouse_left(index) -> void:
	Overall.composite_info_node.set_name(list[index].name)
func _on_mouse_left_move() -> void:
	pass
func _on_mouse_left_restore() -> void:
	pass
func input_mouse(event:InputEvent,contorl) -> void:
	if event.is_action_pressed("mouse_up"):
		$tabs.anchor_right
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	position += diff_size
