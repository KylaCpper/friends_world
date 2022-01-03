extends GuiGrid
var offset_grid_first = 13
var offset_grid = 68
var index = 0
func _init() -> void:
	grid = 9
	bg_list = ["bg"]
func _ready() -> void:
	$text.hide()
	Overall.bar_node = self
	list = Save.save_data.player.bar
	if !Overall.phone:
		set_process_unhandled_input(false)
#	list[0].name = "gu_"
#	list[0].num = 43
#	list[1].name = "default"
#	list[1].num = 43
#	list[3].name = "grass"
#	list[3].num = 43
#	list[4].name = "grass_dirt"
#	list[4].num = 43
#	list[5].name = "dirt"
#	list[5].num = 43
#	list[6].name = "wood"
#	list[6].num = 43
#	list[7].name = "craft_table"
#	list[7].num = 43
#	list[7].name = "rubbish"
#	list[7].num = 43
	
	update()
	show()
	select(0)
func change_item(name_:String,num:int) -> void:
	var item = Item.get(name_)
	if item:
		list[index].name = name_
		var num_max = item["max"]
		if num > num_max:num = num_max
		if num <= 0:num = 1
		list[index].num = num
		list[index].hp = Item.get_hp(name_)
		update()
		show_ani()
func can_place(index_:=index) -> bool:
	index = index_
	if Block.is_in(list[index].name):
		if list[index].num > 0:
			return true
	return false
func sub_hp(hp:=1.0) -> void:
	if list[index].name:
		var item = Item.get(list[index].name)
		if "tool" in item:
			if item.tool:
				list[index].hp -= hp
				if list[index].hp <= 0:
					sub_num()
				show_ani()
				update()
func sub_num(index_:=index,num_:=1) -> bool:
	index = index_
	if list[index].num > 0:
		list[index].num -= 1
		if list[index].num == 0:
			Overall.item_clear(list[index])
		update()
		show_ani()
		return true
	return false 

func select(index_:=index) -> void:
	Overall.player_node.bar_index = index_
	index = index_
	if list[index].name:
		var item = Item.get(list[index].name)
		$text.text = item.name
		$AnimationPlayer.stop()
		$AnimationPlayer.play("show")
	show_ani()
	$bg/select.rect_position.x = offset_grid*index+offset_grid_first
	Overall.player_node.change_hand(list[index].name)
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
			
	return false

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
						break
					else:
						item.num -= list[i].num
	#					list[i].num -= item.num
						item_indexs.append(i)
						subs.append(list[i].num)
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
		show_ani()
		update()
		return true
	else:
		return false
func sub_item(item:Dictionary) -> bool:
	var item_indexs = []
	var subs = []
	for i in range(grid):
		if item.num > 0:
			if list[i].name == item.name:
				if  list[i].num - item.num >= 0:
					item_indexs.append(i)
					subs.append(item.num)
					item.num = 0
					break
				else:
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
		show_ani()
		update()
		return true
	else:
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
			show_ani()
			update()
			return true
		if list[i].name == item.name:
			if list[i].num+item.num <= grid_item["max"]:
				list[i].num += item.num
				update()
				item.num = 0
				item.hp = 0
				item.name = ""
				show_ani()
				return true
			else:
				var be = grid_item["max"] - list[i].num
				item.num -= be
				list[i].num += be
				
	update()
	if !Overall.bag_node.add_item(item):
		Overall.player_node.drop(item.name,item.num,item.hp)
	else:
		show_ani()
		return true
	return false

func update() -> void:
	.update()
	if Overall.player_node:
		select()
func _unhandled_input(event:InputEvent) -> void:
	if event is InputEventScreenTouch:
		for i in range(own_rects.size()):
			if own_rects[i].get_global_rect().has_point(event.position):
				select(i)
				return
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	if window_size.x >= 1130:
		position.x = (window_size.x - Config.window_size.x)/2
	else:
		if window_size.x >= 880:
			position.x = (window_size.x - Config.window_size.x)/2 + (1130 - window_size.x)/2
		else:
			position.x = (window_size.x - Config.window_size.x)/2 + 250/2
	position.y = window_size.y-Config.window_size.y
	
var is_show := true
var time := 0.0
var time_max := 2.0

func _process(delta:float) -> void:
	if Overall.gui:
		show_ani()
		return
	if is_show:
		time += delta
		if time>time_max:
			time = 0.0
			hide_ani()
func show_ani() -> void:
	time = 0.0
	if is_show:return
	is_show = true
	$AnimationPlayer2.play("show")
func hide_ani() -> void:
	if !is_show:return
	is_show = false
	time = 0.0
	$AnimationPlayer2.play("hide")
func shift_mouse_left(index:int) -> bool:
	Overall.gui_node_node.get_node("bag").add_item(list[index])
	return true
