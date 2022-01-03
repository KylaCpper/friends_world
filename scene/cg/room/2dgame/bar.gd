extends Node2D


#extends GuiGrid
var offset = 5
var list = [
	{"name":"","num":0},{"name":"","num":0},{"name":"","num":0},
	{"name":"","num":0},{"name":"","num":0},{"name":"","num":0},
	{"name":"","num":0},{"name":"","num":0},{"name":"","num":0},
]
var grid = 9
var textures = {
	"grass":preload("res://assets/img/2dgame/room/grass.png"),
	"grass_dirt":preload("res://assets/img/2dgame/room/grass_dirt.png"),
	"dirt":preload("res://assets/img/2dgame/room/dirt.png"),
	"leaves":preload("res://assets/img/2dgame/room/leaves.png"),
	"wood":preload("res://assets/img/2dgame/room/wood.png"),
	"stone":preload("res://assets/img/2dgame/room/stone.png"),
	
}
var index = 0
var list_index = {
	"grass":0,
	"dirt":1,
	"grass_dirt":2,
	"leaves":3,
	"stone":4,
	"wood":5,
}
func _ready() -> void:
#	Overall.bar_node = self
#	list = Save.save_data.player.bar
	list[0].name = "grass"
	list[0].num = 9
	list[1].name = "grass_dirt"
	list[1].num = 9
	list[3].name = "dirt"
	list[3].num = 9
	list[4].name = "leaves"
	list[4].num = 9
	list[5].name = "dirt"
	list[5].num = 9
	list[6].name = "wood"
	list[6].num = 9
	list[7].name = "stone"
	list[7].num = 9
	update()
	show()
	select(0)

func update() -> void:
	for i in range(grid):
		if list[i].num > 0:
			
			get_node("grid/bar"+str(i)+"/texture").texture = textures[list[i].name]
			get_node("grid/bar"+str(i)+"/num").text = str(list[i].num)
			get_node("grid/bar"+str(i)+"/num").show()
		else:
			get_node("grid/bar"+str(i)+"/texture").texture = null
			get_node("grid/bar"+str(i)+"/num").text = "0"
			get_node("grid/bar"+str(i)+"/num").hide()
			

func sub_num(index,num_:=1) -> bool:
	if list[index].num > 0:
		list[index].num -= 1
		if list[index].num == 0:
			list[index].name = ""
		update()
		return true
	return false 
func select(index) -> void:
	$bg/select.rect_position.x = 68*index+offset
	self.index = index
func is_items(items:Array) -> bool:
	for i in range(grid):
		for item in items:
			if list[i].name == item.name:
				if  list[i].num - item.num >= 0:
#					list[i].num -= item.num
					item.num = 0
				else:
					item.num -= list[i].num
#					list[i].num -= item.num
	var sure = true
	for item in items:
		if item.num != 0:
			sure = false

	return sure
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
	for i in range(grid):
		for item in items:
			if list[i].name == item.name:
				if  list[i].num - item.num >= 0:
#					list[i].num -= item.num
					item_indexs.append(i)
					subs.append(item.num)
					item.num = 0
				else:
					item.num -= list[i].num
#					list[i].num -= item.num
					item_indexs.append(i)
					subs.append(list[i].num)
	var sure = true
	for item in items:
		if item.num != 0:
			sure = false
	if sure:
		for i in range(item_indexs.size()):
			list[item_indexs[i]].num -= subs[i]
			if !list[item_indexs[i]].num:
				list[item_indexs[i]].name = ""
		update()
		return true
	return false
	
func add_item(name_:String,num := 1) -> bool:
	$pick.play()
	for i in range(list.size()):
		if list[i].name==""||list[i].num<=0:
			list[i].name = name_
			list[i].num = num
			update()
			return true
		if list[i].name == name_:
			if list[i].num < 99:
				list[i].num += num
				update()
				return true
	update()
	return false

func _input(event) -> void:
	for i in 9:
		if event.is_action_pressed(str(i+1)):
			select(i)
	if event.is_action_pressed("mouse_right"):
		if list[index].num > 0:
			if $"../map".place(list_index[list[index].name]):
				list[index].num -= 1
				update()
