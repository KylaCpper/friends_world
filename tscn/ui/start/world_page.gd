extends Node2D
var icon := preload("res://assets/img/ui/composite/type/natural.png")
var id := -1
func _ready() -> void:
	hide()
	$into.connect("pressed",self,"_on_into")
	$create.connect("pressed",self,"_on_create")
	$cancel.connect("pressed",self,"_on_cancel")
	$delete.connect("pressed",self,"_on_delete")
	$open.connect("pressed",self,"_on_open")
	
	$into.connect("mouse_entered",self,"_on_enter")
	$create.connect("mouse_entered",self,"_on_enter")
	$cancel.connect("mouse_entered",self,"_on_enter")
	$delete.connect("mouse_entered",self,"_on_enter")
	$open.connect("mouse_entered",self,"_on_enter")
	
	$blur.set_val(2.0)
	$ItemList.clear()
	var i = 0
	for key in Save.save_data_list:
		var save = Save.save_data_list[key]
		$ItemList.add_item(save.world_name+"----time: "+save.time+"----seed: "+str(save.seed_num),icon)
		$ItemList.set_item_tooltip(i,save.world_name+"\ntime: "+save.time+"\nseed: "+str(save.seed_num))
		i+=1
		
	$ItemList.connect("item_selected",self,"_on_save_select")
func _unhandled_input(event) -> void:
	if event.is_action_pressed("esc"):
		if $sure_page.visible:return
		if visible:
			hide()
			get_tree().set_input_as_handled()

func show() -> void:
	Save.read_save_list()
	id = -1
	$ItemList.clear()
	var i = 0
	for key in Save.save_data_list:
		var save = Save.save_data_list[key]
		$ItemList.add_item(save.world_name+"----time: "+save.time+"----seed: "+str(save.seed_num),icon)
		$ItemList.set_item_tooltip(i,save.world_name+"\ntime: "+save.time+"\nseed: "+str(save.seed_num))
		i+=1
	visible = true
	set_process_unhandled_input(true)
func hide() -> void:
	visible = false
	set_process_unhandled_input(false)

func _on_into() -> void:
	Overall.audio_node.play_ui("click")
	if id != -1:
		Save.select_read_save(id)
		$"../".free_world()
#		if Save.save_data.save:
		Overall.cg_scene  = 3
		Global.GoTo_Scene("res://scene/main/main.tscn")
#		else:
#			Global.GoTo_Scene("res://scene/cg/room/main.tscn")
func _on_create() -> void:
	Overall.audio_node.play_ui("click")
	$create_world_page.show()

func _on_cancel() -> void:
	Overall.audio_node.play_ui("click")
	hide()
func _on_delete() -> void:
	Overall.audio_node.play_ui("click")
	if id != -1:
		$sure_page.show(id)
func _on_open() -> void:
	Overall.audio_node.play_ui("click")
	OS.shell_open(ProjectSettings.globalize_path("user://"))
		
func _on_save_select(id_:int) -> void:
	id = id_

func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$blur._on_screen(window_size,diff_size)
	$bg.rect_size = window_size+Vector2(5,5)

	$ItemList.rect_size.x = window_size.x/5*4
	$ItemList.rect_size.y = abs(200 - window_size.y)
#	$ItemList.rect_size.y = window_size.y/5*4
	
	$ItemList.rect_position.x = window_size.x/2 - $ItemList.rect_size.x/2
	
	$into.rect_position.x = window_size.x/5 - $into.rect_size.x/2
	$create.rect_position.x = window_size.x/5*2 - $create.rect_size.x/2
	$cancel.rect_position.x = window_size.x/2- $cancel.rect_size.x/2
	$delete.rect_position.x = window_size.x/5*4- $delete.rect_size.x/2
	$open.rect_position.x = window_size.x/5*4- $delete.rect_size.x/2
	
	$into.rect_position.y = $ItemList.rect_size.y + $ItemList.rect_position.y + 10
	$create.rect_position.y = $into.rect_position.y
	$cancel.rect_position.y = $into.rect_position.y + 60
	$delete.rect_position.y = $into.rect_position.y
	$open.rect_position.y = $into.rect_position.y + 60
	
	$sure_page._on_screen(window_size,diff_size)
	$create_world_page._on_screen(window_size,diff_size)

func _on_enter() -> void:
	Overall.audio_node.play_ui("hover")
