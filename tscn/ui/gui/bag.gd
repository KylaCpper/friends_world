extends GuiGrid
func _init() -> void:
	grid = 24
func _ready() -> void:
	Overall.bag_node = self
	list = Save.save_data.player.bag
#	list[1].name = "stone"
#	list[1].num = 33
#	list[2].name = "rubbish"
#	list[2].num = 22
#	list[3].name = "rubbish"
#	list[3].num = 21
	update()
#	v_bar = $scroll.get_v_scrollbar()
#	v_bar.add_stylebox_override("scroll",load("res://scene/main/gui/vscrollbar/scroll.tres"))
#	v_bar.add_stylebox_override("grabber",load("res://scene/main/gui/vscrollbar/grabber.tres"))
#	v_bar.mouse_filter = 2
#	v_bar.connect("changed",self,"_on_change")
#func _on_change() -> void:
#	var tween = $tween
#	tween.interpolate_property(v_bar, "modulate",
#			Color(1,1,1,1),  Color(1,1,1,0), 1.5,
#			Tween.TRANS_SINE, Tween.EASE_OUT)
#	tween.start()
# [{"name":"num"},...]
func is_items_arr(items:Array) -> Array:
	var data := []
	for item in items:
		if is_item(item):
			data.append(item.name)
	return data
func is_items(items:Array) -> bool:
	for item in items:
		if !is_item(item):
			return false
	return true
func is_item(item:Dictionary) -> bool:
	for i in range(grid):
		if list[i].name == item.name:
			if  list[i].num - item.num >= 0:
				return true
			else:
				item.num -= list[i].num
				
	var sure := true
	if item.num != 0:
		sure = false
		if Overall.bar_node.is_item(item):
			sure = true
	return sure
	
func sub_items(items:Array) -> bool:
	
	var item_indexs = []
	var subs = []
	for item in items:
		for i in range(grid):
			if item.num > 0:
				if list[i].name == item.name:
					if  list[i].num - item.num >= 0:
	#					list[i].num -= item.num
						item_indexs.append(i)
						subs.append(item.num)
						item.num = 0
						item.hp = 0
						item.name = ""
						break
					else:
	#					list[i].num -= item.num
						item_indexs.append(i)
						subs.append(list[i].num)
						item.num -= list[i].num
			else:break
	var sure = true
	for item in items:
		if item.num != 0:
			sure = false
	if sure:
		for i in range(item_indexs.size()):
			list[item_indexs[i]].num -= subs[i]
			if !list[item_indexs[i]].num:
				Overall.item_clear(list[item_indexs[i]])
		update()
		return true
	if Overall.bar_node.sub_items(items):
		for i in range(item_indexs.size()):
			list[item_indexs[i]].num -= subs[i]
			if !list[item_indexs[i]].num:
				Overall.item_clear(list[item_indexs[i]])
		return true
	return false

func sub_item(item:Dictionary) -> bool:
	var item_indexs = []
	var subs = []
	for i in range(grid):
		if item.num > 0:
			if list[i].name == item.name:
				if  list[i].num - item.num >= 0:
#					list[i].num -= item.num
					item_indexs.append(i)
					subs.append(item.num)
					item.num = 0
					break
				else:
#					list[i].num -= item.num
					item_indexs.append(i)
					subs.append(list[i].num)
					item.num -= list[i].num
		else:break
	var sure = true
	if item.num != 0:
		sure = false
	if sure:
		for i in range(item_indexs.size()):
			list[item_indexs[i]].num -= subs[i]
			if !list[item_indexs[i]].num:
				Overall.item_clear(list[item_indexs[i]])
				
		update()
		return true
	if Overall.bar_node.sub_item(item):
		for i in range(item_indexs.size()):
			list[item_indexs[i]].num -= subs[i]
			if !list[item_indexs[i]].num:
				Overall.item_clear(list[item_indexs[i]])
		return true
	return false

func add_item(item:Dictionary) -> bool:
	for i in range(list.size()):
		var grid_item = Item.get(list[i].name)
		if list[i].name==""||list[i].num<=0:
			list[i].name = item.name
			list[i].num = item.num
			list[i].hp = item.hp
			item.num = 0
			item.hp = 0
			item.name = ""
			update()
			return true
		if list[i].name == item.name:
			if list[i].num+item.num <= grid_item["max"]:
				list[i].num += item.num
				update()
				item.num = 0
				item.hp = 0
				item.name = ""
				return true
			else:
				var be = grid_item["max"] - list[i].num
				item.num -= be
				list[i].num += be
	update()
	return false
func shift_mouse_left(index:int) -> bool:
	if Overall.gui_node_node.list.bag:
		Overall.gui_node_node.get_node("state_gui").add_item(list[index])
	return true
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	position += diff_size

