extends Node2D
class_name GuiGrid
var list = []
var grid := 9
var bg_list = ["bg","bg2"]

var own_rects = []

var index_left_old = -1
var index_right_old = -1

var gird_path := "grid/bar"

var enter := false
var permission := true
var mouse_pos := Vector2()
var offset = Vector2()
var mouse_left_indexs = []

var is_press := false
func change_permission(be:bool) -> void:
	pass
static func enter(name_:String) -> void:
	
	var be := false
	for grid_obj in Overall.gui_node_node.grid_objs:
		if grid_obj.name == name_:
			be = true
			grid_obj.enter = true
		else:
			grid_obj.enter= false
		if be:
			if grid_obj.permission == false:
				grid_obj.permission = true
				grid_obj.change_permission(true)
		else:
			if grid_obj.permission == true:
				grid_obj.permission = false
				grid_obj.change_permission(false)
		if !name_:
			if grid_obj.permission == false:
				grid_obj.permission = true
				grid_obj.change_permission(true)



static func permission(name_:String) -> void:
	
	var be := false
	for grid_obj in Overall.gui_node_node.grid_objs:
		if grid_obj.name == name_:be = true
		if be:
			if grid_obj.permission == false:
				grid_obj.permission = true
				grid_obj.change_permission(true)
		else:
			if grid_obj.permission == true:
				grid_obj.permission = false
				grid_obj.change_permission(false)
		if !name_:
			if grid_obj.permission == false:
				grid_obj.permission = true
				grid_obj.change_permission(true)
	
onready var z_i = z_index
func _ready() -> void:
	for i in range(grid):
		list.append({"name":"","num":0,"hp":0})
	for i in range(grid):
		own_rects.append(get_node(gird_path+str(i)))
	hide()
	connect("hide",self,"_on_hide")
	update()
func _on_mouse_right(index) -> void:
	if Overall.pick_item_node.is_item:
		if !is_accord(Overall.pick_item_node.item.name,index):return
		if list[index].name:
			if list[index].name == Overall.pick_item_node.item.name:
				if list[index].hp <= 0:
					if list[index].num < Item.get_max(list[index].name):
						list[index].num += 1
						Overall.pick_item_node.sub(1)
						on_put(list[index].name,index)

		else:
			list[index].name = Overall.pick_item_node.item.name
			list[index].num += 1
			Overall.pick_item_node.sub(1)
			if Overall.pick_item_node.item.num <=0:
				Overall.msg_grid_item_node.set_item(list[index])
			on_put(list[index].name,index)
		
	else:
		if list[index].name and list[index].num > 0:
			var oname = list[index].name
			var num = ceil(list[index].num/2.0)
			var hp = 0
			if num > 0:
				hp = Item.get_hp(list[index].name)
				Overall.pick_item_node.set_item({"name":list[index].name,"num":num,"hp":hp})
				list[index].num -= num
			if list[index].num <=0:
				Overall.item_clear(list[index])
				Overall.msg_grid_item_node.set_item()
			
			on_take(oname,index)
	update()
func on_put(name_:String,index:int) -> void:
	pass
func on_take(name_:String,index:int) -> void:
	pass
func is_accord(name_:String,index:int) -> bool:
	return true
func shift_mouse_left(index:int) -> bool:
	return true
func _on_mouse_left(index:int) -> void:
	if Input.is_action_pressed("shift"):
		if list[index].name and list[index].num > 0:
			if shift_mouse_left(index):
				update()
				return
		
	if Overall.pick_item_node.is_item:
		if !is_accord(Overall.pick_item_node.item.name,index):return
		if list[index].name:
			if list[index].name == Overall.pick_item_node.item.name:
				if list[index].hp <= 0:
					var num_max = Item.get_max(list[index].name)
					if list[index].num < num_max:
						var num = Overall.pick_item_node.item.num
						if list[index].num+num > num_max:
							Overall.pick_item_node.sub(num_max - list[index].num)
							list[index].num = num_max
						else:
							list[index].num += num
							Overall.pick_item_node.set_item()
				else:
					change(index)
					Overall.msg_grid_item_node.set_item(list[index])
					Overall.pick_item_node.update()
			else:
				change(index)
				Overall.msg_grid_item_node.set_item(list[index])
				Overall.pick_item_node.update()
		else:
			list[index] = Overall.pick_item_node.item
			Overall.pick_item_node.set_item()
			Overall.msg_grid_item_node.set_item(list[index])
		on_put(list[index].name,index)
	else:
		if list[index].name and list[index].num > 0:
			var oname = list[index].name
			Overall.pick_item_node.set_item(list[index])
			Overall.msg_grid_item_node.set_item()
			list[index] = {"name":"","num":0,"hp":0}
			on_take(oname,index)
	update()
func _change_gird(index:int) -> void:
	pass
var mouse_left_name := ""
func _on_mouse_left_move() -> void:
	if mouse_left_indexs.size()<2:return
	_on_mouse_left_restore()
	if Overall.pick_item_node.is_item:
		mouse_left_name = Overall.pick_item_node.item.name
		if Overall.pick_item_node.item.hp > 0:
			for i in mouse_left_indexs:
				if !list[i].name:
					list[i].name = Overall.pick_item_node.item.name
					list[i].num = 1
					list[i].hp = Overall.pick_item_node.item.hp
					Overall.pick_item_node.item.num = 0
					Overall.pick_item_node.update()
					break
		else:
			var num = int(Overall.pick_item_node.item.num)
			var index_num = 0
			var num_more = 0
			for i in mouse_left_indexs:
				if !list[i].name:index_num += 1
			num_more = num%index_num
			for i in mouse_left_indexs:
				if !list[i].name:
					if Overall.pick_item_node.item.num > 1:
						list[i].name = Overall.pick_item_node.item.name
						list[i].num = num/index_num
						Overall.pick_item_node.sub(num/index_num)
	update()
func _on_mouse_left_restore() -> void:
	if Overall.pick_item_node.item.hp > 0:
		for i in mouse_left_indexs:
			if list[i].name == Overall.pick_item_node.item.name:
				Overall.pick_item_node.item.num = 1
				Overall.pick_item_node.update()
				Overall.item_clear(list[i])
				break
	else:
		for i in mouse_left_indexs:
			if list[i].name == Overall.pick_item_node.item.name:
				Overall.pick_item_node.add(list[i].num,Overall.pick_item_node.item.name)
				Overall.item_clear(list[i])
			else:
				pass

	update()
func change(index:int) -> void:
	var name_ = list[index].name
	var num  = list[index].num
	var hp = list[index].hp
	list[index].name = Overall.pick_item_node.item.name
	list[index].num = Overall.pick_item_node.item.num
	list[index].hp = Overall.pick_item_node.item.hp
	Overall.pick_item_node.item.name = name_
	Overall.pick_item_node.item.num = num
	Overall.pick_item_node.item.hp = hp
static func change_extra(var1) -> void:
	var name_ = var1.name
	var num  = var1.num
	var hp = var1.hp
	var1.name = Overall.pick_item_node.item.name
	var1.num = Overall.pick_item_node.item.num
	var1.hp = Overall.pick_item_node.item.hp
	Overall.pick_item_node.item.name = name_
	Overall.pick_item_node.item.num = num
	Overall.pick_item_node.item.hp = hp

static func mouse_left(var1) -> void:

	if Overall.pick_item_node.is_item:
		if var1.name:
			if var1.name == Overall.pick_item_node.item.name:
				if var1.hp <= 0:
					var num_max = Item.get_max(var1.name)
					if var1.num < num_max:
						var num = Overall.pick_item_node.item.num
						if var1.num+num > num_max:
							Overall.pick_item_node.sub(num_max - var1.num)
							var1.num = num_max
						else:
							var1.num += num
							Overall.pick_item_node.set_item()
				else:
					change_extra(var1)
					Overall.msg_grid_item_node.set_item(var1)
					Overall.pick_item_node.update()
			else:
				change_extra(var1)
				Overall.msg_grid_item_node.set_item(var1)
				Overall.pick_item_node.update()
		else:
			var item = Overall.pick_item_node.item.duplicate()
			var1.name = item.name
			var1.num = item.num
			var1.hp = item.hp
			Overall.pick_item_node.set_item()
			Overall.msg_grid_item_node.set_item(var1)
	else:
		if var1.name and var1.num > 0:
			Overall.pick_item_node.set_item(var1.duplicate())
			Overall.msg_grid_item_node.set_item()
			var1.name = ""
			var1.num = 0
			var1.hp = 0
static func mouse_left_confine(var1) -> void:
	if Overall.pick_item_node.is_item:
		if var1.name:
			if var1.name == Overall.pick_item_node.item.name:
				if Overall.pick_item_node.item.hp <= 0:
					var num_max = Item.get_max(Overall.pick_item_node.item.name)
					if Overall.pick_item_node.item.num < num_max:
						var num = var1.num
						if Overall.pick_item_node.item.num+num > num_max:
							var1.num -= num_max - var1.num
							Overall.pick_item_node.item.num = num_max
							Overall.pick_item_node.update()
						else:
							Overall.pick_item_node.add(num,Overall.pick_item_node.item.name)
							var1.name = ""
							var1.num = 0
							var1.hp = 0
	else:
		if var1.name and var1.num > 0:
			Overall.pick_item_node.set_item(var1.duplicate())
			Overall.msg_grid_item_node.set_item()
			var1.name = ""
			var1.num = 0
			var1.hp = 0
func mouse_left_entered(var1,node) -> void:
	_on_mouse_entered(-1)
	node.get_node("bg").show()
	Overall.msg_grid_item_node.set_item(var1)
static func mouse_left_exited(var1,node) -> void:
	node.get_node("bg").hide()
	if Overall.msg_grid_item_node.name_ == var1.name:
		Overall.msg_grid_item_node.set_item()
var index_enter = -1
func _on_mouse_entered(index) -> void:
	index_enter = index
	for i in range(grid):
		if index == i:
			get_node(gird_path+str(i)+"/bg").show()
		else:
			get_node(gird_path+str(i)+"/bg").hide()
	if list.size() > index:
		Overall.msg_grid_item_node.set_item(list[index])
func _on_mouse_exited() -> void:
	index_enter = -1
	for i in range(grid):
		get_node(gird_path+str(i)+"/bg").hide()
	Overall.msg_grid_item_node.set_item()
func update() -> void:
	for i in range(list.size()):
		if list[i].name=="" || list[i].num<=0 || list[i].hp<0:
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


func _on_hide():
	index_left_old = -1
	mouse_left_indexs.clear()
	index_right_old = -1 
	_on_mouse_exited()
var press_left := false
var press_right := false
var press_title := false
var focus := false
func is_enter() -> bool:
	
	
	var pos = get_parent().get_global_mouse_position()
	var bg_enter_num = 0
	if focus:
		for bg in bg_list:
			if get_node(bg).get_global_rect().has_point(pos):
				bg_enter_num = bg_enter_num +1
		if bg_enter_num == 0:
#			print(name)
			focus = false
			z_index = z_i
			press_title = false
			return false
	var in_bg := false
	for bg in bg_list:
		if get_node(bg).get_global_rect().has_point(pos):
			var be := true
			for grid_obj in Overall.gui_node_node.grid_objs:
				if grid_obj.name != name:
					if grid_obj.focus:
						be = false
						break
			if be:
				in_bg = true

				z_index = 0
				focus = true
				press_title = true
		
	return in_bg

	var be := false




var enter_num = 0
func _input(event:InputEvent) -> void:
	
	if !visible:return
	var control := {
		"mouse":false,
		"mouse_button":false,
		"mouse_left":false,
		"mouse_left_up":false,
		"mouse_right":false,
		"mouse_right_up":false,
	}
	var mouse := event is InputEventMouse
	var mouse_button := event is InputEventMouseButton
	var left_down := Input.is_action_pressed("mouse_left")
	var left_up := event.is_action_released("mouse_left")
	var right_down := event.is_action_pressed("mouse_right")
	var right_up := event.is_action_released("mouse_right")
	if Overall.phone:
		if event is InputEventScreenTouch || event is InputEventScreenDrag:
			mouse = true
			mouse_button = true

			if event is InputEventScreenTouch:
				if event.index == 0:
					if event.pressed:
						left_down = true
					else:
						left_up = true
				else:
					if event.pressed:
						right_down = true
					else:
						right_up = true
					
			else:
				left_down = true
				var pos = event.position
				if get_node("bg2").get_global_rect().has_point(pos):
					if mouse_pos != Vector2(0,0):
						position += pos - mouse_pos + offset
						mouse_pos = pos

	control.mouse = mouse
	control.mouse_button = mouse_button
	control.mouse_left = left_down
	control.mouse_left_up = left_up
	control.mouse_right = right_down
	control.mouse_right_up = right_up
	if mouse:
		if press_left:
			if press_title:
				if mouse_pos != Vector2(0,0):
					var window_size = Config.window_size_current
					var pos2 = position
					var pos = event.position
					position += pos - mouse_pos + offset
					mouse_pos = pos
					var bg2_pos = get_node("bg2").rect_global_position + get_node("bg2").rect_size/2
					if bg2_pos.x < 0:
						position = pos2
					elif bg2_pos.x>window_size.x:
						position = pos2
					if bg2_pos.y < 0:
						position = pos2
					elif bg2_pos.y>window_size.y:
						position = pos2
	if left_down:
		enter_num = enter_num+1
		if enter_num > 1:return
	else:
		enter_num = 0
	if !permission:
		press_left = false
		press_right = false
		return

	if permission:
		if is_enter():
			enter(name)
		else:
			if enter:
				enter = false
				permission("")
				_on_mouse_exited()
				
	if !enter:
		press_left = false
		press_right = false
		return
	var index = -1

	if mouse:
		var pos = event.position
		
		
		for i in range(own_rects.size()):
			if own_rects[i].get_global_rect().has_point(pos):
				_on_mouse_entered(i)
				index = i
		if index == -1:
			_on_mouse_exited()
			
		if press_left:
			if index != -1:
				if index_left_old != index:
					if mouse_left_indexs.find(index) == -1:
						mouse_left_indexs.append(index)
						_on_mouse_left_move()
		if press_right:
			if index != -1:
				if index_right_old != index:
					_on_mouse_right(index)
					index_right_old = index
		
		if mouse_button:
			if left_down:
				if !press_left && press_title:
					mouse_pos = pos
				press_left = true
				if Overall.pick_item_node.is_item:
					index_left_old = -1
				else:
					index_left_old = index
					
				mouse_left_indexs.clear()
				

			if right_down:
				press_right = true
				index_right_old = -1
			if left_up:
				if index != -1:
					if mouse_left_indexs.size()<2:
						_on_mouse_left(index)
				if Overall.pick_item_node.item.num == 0:
					Overall.pick_item_node.set_item()
				press_left = false
			if right_up:
				press_right = false
		input_mouse(event,control)
	if event is InputEventKey:
		input_key(event)
		
func on_change(index:int,bar_index:int) -> void:
	
	pass
func input_key(event:InputEvent) -> void:
	if index_enter == -1:return
	for i in range(1,9):
		if event.is_action_pressed(str(i)):
#			if list[index_enter].name:
			var name_ = list[index_enter].name
			var num = list[index_enter].num
			var hp = list[index_enter].hp
			
				
			list[index_enter].name = Overall.bar_node.list[i-1].name
			list[index_enter].num = Overall.bar_node.list[i-1].num 
			list[index_enter].hp = Overall.bar_node.list[i-1].hp
			Overall.bar_node.list[i-1].name = name_
			Overall.bar_node.list[i-1].num = num
			Overall.bar_node.list[i-1].hp = hp
			Overall.msg_grid_item_node.set_item(list[index_enter])

			on_change(index_enter,i-1)
#				if !Overall.bar_node.list[i-1].name:
#					Overall.bar_node.list[i-1].name = list[index_enter].name
#					Overall.bar_node.list[i-1].num = list[index_enter].num
#					Overall.bar_node.list[i-1].hp = list[index_enter].hp
#					Overall.item_clear(list[index_enter])
#					Overall.msg_grid_item_node.set_item()
#				else:
#					if list[index_enter].name != Overall.bar_node.list[i-1].name || list[index_enter].hp>0 || Overall.bar_node.list[i-1].hp>0:
#						var name_ = list[index_enter].name
#						var num = list[index_enter].num
#						var hp = list[index_enter].hp
#						list[index_enter].name = Overall.bar_node.list[i-1].name
#						list[index_enter].num = Overall.bar_node.list[i-1].num 
#						list[index_enter].hp = Overall.bar_node.list[i-1].hp
#						Overall.bar_node.list[i-1].name = name_
#						Overall.bar_node.list[i-1].num = num
#						Overall.bar_node.list[i-1].hp = hp
#						Overall.msg_grid_item_node.set_item(list[index_enter])
#					else:
#						var num = list[index_enter].num
#						var num_max = Item.get_max(list[index_enter].name)
#						if Overall.bar_node.list[i-1].num + num > num_max:
#							list[index_enter] -= num_max - Overall.bar_node.list[i-1].num
#							Overall.bar_node.list[i-1].num = num_max
#						else:
#							Overall.bar_node.list[i-1].num += list[index_enter].num
#							Overall.bar_node.list[i-1].hp = list[index_enter].hp
#							Overall.item_clear(list[index_enter])
#							Overall.msg_grid_item_node.set_item()
			update()
			Overall.bar_node.update()
			break

func input_mouse(event:InputEvent,control) -> void:
	pass


func add_item(item:Dictionary) -> bool:
	for i in range(list.size()):
		var grid_item = Item.get(list[i].name)
		if list[i].name==""||list[i].num<=0:
			list[i].name = item.name
			list[i].num = item.num
			list[i].hp = item.hp
			item.num = 0
			update()
			return true
		if list[i].name == item.name:
			if list[i].num+item.num <= grid_item["max"]:
				list[i].num += item.num
				update()
				item.num = 0
				return true
			else:
				var be = grid_item["max"] - list[i].num
				item.num -= be
				list[i].num += be
	update()
	return false
