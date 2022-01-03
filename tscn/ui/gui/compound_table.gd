extends GuiGrid
var export_obj = {"name":"","num":0,"hp":0}
func _init() -> void:
	grid = 9
func _ready() -> void:
	Overall.composite_table = self
#	list = Save.save_data.player.bag
#	list[1].name = "rubbish"
#	list[1].num = 33
#	list[2].name = "rubbish"
#	list[2].num = 22
#	list[3].name = "rubbish"
#	list[3].num = 21
	update()
#	connect("visibility_changed",self,"_on_visible")
	$export.connect("pressed",self,"_on_export_press")
func _on_export_press() -> void:
	if export_obj.num > 0:
		for i in range(grid):
			list[i].num -= 1
			if list[i].num <=0:
				list[i].num = 0
				list[i].name = ""
				list[i].hp = 0
		make()
func make() -> void:
	if !Overall.pick_item_node.is_item:
		Overall.pick_item_node.item = export_obj.duplicate()
	else:
		if Overall.pick_item_node.item.name == export_obj.name:
			if !Overall.pick_item_node.item.num + export_obj.num > Config.item_max:
				Overall.pick_item_node.item.num += export_obj.num
	update()
				
func update() -> void:
	.update()
	for i in range(grid):
		if !list[i].name == "rubbish":
			break
		else:
			if i == grid - 1:
				export_obj.name = "han"
				export_obj.num = 1
				export_obj.hp = Item.get_hp("han")
	
	if export_obj.num > 0:
		
		if Item.get(export_obj.name).type == "block":
			Overall.photograph_node.set_texture(export_obj.name,$export/texture)
		else:
			$export/texture.texture = Item.get(export_obj.name).img
		$export/num.text = str(export_obj.num)
	else:
		$export/texture.texture = null
		$export/num.hide()
	
	
	

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
	if Overall.bag_node.is_items(items):
		sure = true
	return sure
func is_item(item:Dictionary) -> bool:
	for i in range(grid):
		if list[i].name == item.name:
			if  list[i].num - item.num >= 0:
				return true
			else:
				item.num -= list[i].num
	return false
	
func input_mouse(event:InputEvent,control) -> void:
	if control.mouse:
		var pos = event.position
		if $export.get_global_rect().has_point(pos):
			$export/bg.show()
			Overall.msg_grid_item_node.set_item(export_obj)
		else:
			$export/bg.hide()
			Overall.msg_grid_item_node.set_item()

		if control.mouse_button:
			if control.mouse_left:
				if $export.get_global_rect().has_point(pos):
					_on_export_press()
