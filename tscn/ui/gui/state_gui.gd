extends GuiGrid
func _init() -> void:
	grid = 5

var green_color := Color("#b442bd69")
var yellow_color := Color("#b4b7c046")
var orange_color := Color("#b4c08d46")
var red_color := Color("#b4c04646")
var black_color := Color("#b4353535")

func _ready():
	Overall.state_gui_node = self
	list = Save.save_data.player.armor

	update()
	yield($"../","ready")
	check_armor(list[0].name,0)
	check_armor(list[1].name,1)
	check_armor(list[2].name,2)
	check_armor(list[3].name,3)
	check_armor(list[4].name,4)
func check_armor(name_:String,index:int):
	var item = Item.get(name_)
	if index == 0:
		if item:
			Overall.status_node.sub_armor_ani("head",list[index].hp,item.hp)
		else:
			Overall.status_node.sub_armor_ani("head",0,0)
	if index == 1:
		if item:
			Overall.status_node.sub_armor_ani("body",list[index].hp,item.hp)
		else:
			Overall.status_node.sub_armor_ani("body",0,0)
	if index == 2:
		if item:
			Overall.status_node.sub_armor_ani("arm_left",list[index].hp,item.hp)
			Overall.status_node.sub_armor_ani("arm_right",list[index].hp,item.hp)
		else:
			Overall.status_node.sub_armor_ani("arm_left",0,0)
			Overall.status_node.sub_armor_ani("arm_right",0,0)
	if index == 3:
		if item:
			Overall.status_node.sub_armor_ani("leg_left",list[index].hp,item.hp)
			Overall.status_node.sub_armor_ani("leg_right",list[index].hp,item.hp)
		else:
			Overall.status_node.sub_armor_ani("leg_left",0,0)
			Overall.status_node.sub_armor_ani("leg_right",0,0)
	if index == 4:
		if item:
			Overall.status_node.sub_armor_ani("foot_left",list[index].hp,item.hp)
			Overall.status_node.sub_armor_ani("foot_right",list[index].hp,item.hp)
		else:
			Overall.status_node.sub_armor_ani("foot_left",0,0)
			Overall.status_node.sub_armor_ani("foot_right",0,0)
			
			
func on_change(index:int,bar_index:int) -> void:
	Overall.player_node.on_armor(list[index].name,index)
	check_armor(list[index].name,index)
	pass
func on_take(name_:String,index:int) -> void:
	Overall.player_node.on_armor("",index)
	check_armor(name_,index)
func on_put(name_:String,index:int) -> void:
#	Save.save_data.player.armor[index] = list[index]
	Overall.player_node.on_armor(name_,index)
	check_armor(name_,index)
func is_accord(name_:String,index:int) -> bool:
	if Item.is_in(name_):
		var item = Item.get(name_)
		if "armor" in item:
#			Overall.player_node.on_armor(name_,index)
			if index == 0 && item.armor == "hat":
				return true
			if index == 1 && item.armor == "coat":
				return true
			if index == 2 && item.armor == "sleeve":
				return true
			if index == 3 && item.armor == "pants":
				return true
			if index == 4 && item.armor == "shoe":
				return true
	return false
func sub_armor(hp:float,body:String) -> bool:
	
	if body == "head":
		if list[0].name:
			list[0].hp -= hp
			if list[0].hp <= 0:
				Overall.item_clear(list[0])
				on_take("",0)
			check_armor(list[0].name,0)
			update()
			return true
	if body == "body" :
		if list[1].name:
			list[1].hp -= hp
			if list[1].hp <= 0:
				Overall.item_clear(list[1])
				on_take("",1)
			check_armor(list[1].name,1)
			update()
			return true
	if body == "arm_left" || body == "arm_right":
		if list[2].name:
			list[2].hp -= hp
			if list[2].hp <= 0:
				Overall.item_clear(list[2])
				on_take("",2)
			check_armor(list[2].name,2)
			update()
			return true
	if body == "leg_left" || body == "leg_right":
		if list[3].name:
			list[3].hp -= hp
			if list[3].hp <= 0:
				Overall.item_clear(list[3])
				on_take("",3)
			check_armor(list[3].name,3)
			update()
			return true
	if body =="foot_left" || body == "foot_right":
		if list[4].name:
			list[4].hp -= hp
			if list[4].hp <= 0:
				Overall.item_clear(list[4])
				on_take("",4)
			check_armor(list[4].name,4)
			update()
			return true
	return false
func set_hp(body:String,hp:int) -> void:
	var sprite_c = get_node(body+"/sprite")
	if body == "body":
		if hp > 0:
			sprite_c.modulate = red_color
			if hp > 1:
				sprite_c.modulate = orange_color
				if hp > 2:
					sprite_c.modulate = yellow_color
					if hp > 3:
						sprite_c.modulate = green_color
		else:
			sprite_c.modulate = black_color
	else:
		if hp > 0:
			sprite_c.modulate = red_color
			if hp > 1:
				sprite_c.modulate = orange_color
				if hp > 2:
					sprite_c.modulate = green_color

		else:
			sprite_c.modulate = black_color
			

func add_item(item:Dictionary) -> bool:
	for i in range(list.size()):
		var item_be = Item.get(item.name)
		if "armor" in item_be:
			var armor = item_be.armor
			if list[i].name==""||list[i].num<=0:
				if (armor == "hat" && i == 0) || (armor == "coat" && i == 1) || (armor == "sleeve" && i ==2) || (armor == "pants" && i == 3) || (armor == "shoe" && i == 4):
					list[i].name = item.name
					list[i].num = item.num
					list[i].hp = item.hp
					item.num = 0
					item.hp = 0
					item.name = ""
					update()
					if list[i].name:
						on_put(list[i].name,i)
					else:
						on_take(list[i].name,i)
					return true
					
	update()
	return false
func shift_mouse_left(index:int) -> bool:
	if Overall.gui_node_node.get_node("bag").add_item(list[index]):
		if list[index].name:
			on_put(list[index].name,index)
		else:
			on_take(list[index].name,index)
	return true

func _input(event):
	$"Viewport/Viewport/player/player/Skeleton".on_input(event,$Viewport.rect_global_position+Vector2(58,44))
func input_key(event:InputEvent) -> void:
	if index_enter == -1:return
	for i in range(1,9):
		if event.is_action_pressed(str(i)):
			var name_ = list[index_enter].name
			var num = list[index_enter].num
			var hp = list[index_enter].hp
			if !(!Overall.bar_node.list[i-1].name || is_accord(Overall.bar_node.list[i-1].name,index_enter)):
				return
			
			list[index_enter].name = Overall.bar_node.list[i-1].name
			list[index_enter].num = Overall.bar_node.list[i-1].num 
			list[index_enter].hp = Overall.bar_node.list[i-1].hp
			Overall.bar_node.list[i-1].name = name_
			Overall.bar_node.list[i-1].num = num
			Overall.bar_node.list[i-1].hp = hp
			Overall.msg_grid_item_node.set_item(list[index_enter])
			if list[index_enter].name:
				on_put(list[index_enter].name,index_enter)
			else:
				on_take(list[index_enter].name,index_enter)
			update()
			Overall.bar_node.update()
			break
