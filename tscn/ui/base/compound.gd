extends GuiGrid
var export_item = {"name":"","num":0}
func _init() -> void:
	grid = 9
func _ready() -> void:
	$export.connect("mouse_entered",self,"_on_export_mouse_entered")
	$export.connect("mouse_exited",self,"_on_export_mouse_exited")
	$export.connect("pressed",self,"_on_export_mouse_pressed")
	update()
func _on_export_mouse_entered():
	get_node("export/bg").show()
	Overall.msg_grid_item_node.set_item(export_item)
func _on_export_mouse_exited():
	get_node("export/bg").show()
	Overall.msg_grid_item_node.set_item()
func _on_export_mouse_pressed():
	if Overall.pick_item_node.item:
		return
	else:
		if export_item.name and export_item.num > 0:
			Overall.pick_item_node.item = export_item
			Overall.msg_grid_item_node.set_item()
			export_item = {"name":"","num":0}
			for i in range(grid):
				if list[i].num >0:
					list[i].num -= 1
					if list[i].num <=0:
						list[i].name = ""
						list[i].num = 0
				
			update()
func update() -> void:
	.update()
	check_table()
	if export_item.name:
		if Block.is_in(export_item.name):
			Overall.photograph_node.set_texture(export_item.name,get_node("export/texture"))
		else:
			get_node("export/texture").texture = Item.get(export_item.name).img
		get_node("export/num").text = str(export_item.num)
		get_node("export/num").show()
	else:
		get_node("export/texture").texture = null
		get_node("export/num").hide()
	
func check_table() -> void:
	var index = 0
	for i in range(grid):
		if list[i].name == "rubbish":
			index += 1
	if index == 4:
		export_item.name = "idiot1"
		export_item.num = 1
	elif index == 6:
		export_item.name = "idiot2"
		export_item.num = 1
	elif index == 9:
		export_item.name = "idiot3"
		export_item.num = 1
	else:
		export_item = {"name":"","num":0}
