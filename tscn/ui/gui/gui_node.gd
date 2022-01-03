extends Node2D

var list := {
	"bag" : false,
	"composite" : false
}
var grid_objs = []
var grid_obj_list = {
	"all":"all_grid_objs",
	"bag":"bag_grid_objs",
	"composite":"bag_grid_objs",
	"stone_furnace":"stone_furnace_grid_objs",
	"stone_blast_furnace":"stone_blast_furnace_grid_objs",
	"anvil":"anvli_grid_objs",
}
onready var all_grid_objs = [
	$bar,
	$bag,
	$composite,
	$composite_info,
	$stone_furnace,
	$stone_blast_furnace,
	$state_gui,
	$anvil,
]
onready var bag_grid_objs = [
	$bar,
	$bag,
	$composite,
	$composite_info,
	$state_gui,
]
onready var stone_furnace_grid_objs = [
	$bar,
	$bag,
	$stone_furnace,
]
onready var stone_blast_furnace_grid_objs = [
	$bar,
	$bag,
	$stone_blast_furnace,
]
onready var anvli_grid_objs = [
	$bar,
	$bag,
	$anvil,
]
func _ready() -> void:
#	$Label.hide()
#	$Label2.hide()
	Overall.gui_node_node = self
	Overall.bg_node = $bg
	change_grid_objs("all")
	check_ui()
	get_tree().connect("screen_resized",self,"_on_screen")
	_on_screen()
	Function.set_mouse(Input.MOUSE_MODE_CAPTURED)
	

func asd(name_,text):
	get_node(name_).text = text

var window_size_be = Config.window_size
func _on_screen() -> void:
	var window_size = get_viewport().size
	Config.window_size_current = window_size
	if !Config.ADAPTATION:
		window_size = Vector2(1024,600)
	var diff_size = window_size - window_size_be 
	diff_size /=2
	window_size_be = window_size
	for obj in get_children():
		if obj.has_method("_on_screen"):
			obj._on_screen(window_size,diff_size)
			
			
var esc := false


func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if Overall.gui:
			esc_press()
		else:
			$esc.show()
			$blur.set_val(2.0)
			check_ui()
	if event.is_action_pressed("v"):
		$status.change_armor()
#	if event.is_pressed()
#	for key in list:
#		if list[key]:
#			var nodes = self[grid_obj_list[key]]
#			for node in nodes:
				
func esc_press() -> void:
	$blur.set_val(1.0)
	esc = true
	close_ui()
####改变对应的gui 大状态
func change_ui(name_:String,arg1=false) -> void:
	if $hurt.dead:
		check_ui()
		return
	if !name_ in list:
		list[name_] = false
	if Overall.gui:
		if list[name_] == false:
			if name_ == "bag":close_ui()
			return
	list[name_] = !list[name_]
	for obj in all_grid_objs:
		obj.hide()
	grid_objs = []
	for key in list:
		if list[key]:
			if key == "bag" || key == "composite":
				$composite.name_ = arg1
			if key == "anvil":
				$anvil.model = arg1
				
			for obj in self[grid_obj_list[name_]]:
				obj.show()
				obj.permission = true
				
			change_grid_objs(name_)
			break



	check_ui()
	
#更新 当前是否有gui状态
func check_ui():
	
	$bar.show()
	var be := false
	for key in list:
		if list[key]:
			be = true
			break
	if be||$esc.visible||Overall.cmd||$hurt.dead:
		Overall.gui = true
		if Overall.cmd||$hurt.dead:
			$blur.hide()
		else:
			$blur.show()
		$bar.set_process_input(true)
	else:
		Overall.gui = false
		$blur.hide()
		$bar.set_process_input(false)
	if Overall.gui:
		Function.set_mouse(Input.MOUSE_MODE_VISIBLE)
	else:
		Function.set_mouse(Input.MOUSE_MODE_CAPTURED)
func close_ui():
	if esc:
		$esc.hide()
		esc = false
	for key in list:
		list[key] = false
	for obj in all_grid_objs:
		obj.hide()
	if Overall.pick_item_node.is_item:
		Overall.player_node.drop(Overall.pick_item_node.item.name,Overall.pick_item_node.item.num,Overall.pick_item_node.item.hp)
	Overall.pick_item_node.set_item()
	change_grid_objs("all")
	check_ui()
###
func _process(delta):
	if delta:
		$Label.text = str(1.0/delta)
		if Overall.player_node:
			$Label2.text = str(Overall.player_node.translation)
func change_grid_objs(name_:String):
	grid_objs = self[grid_obj_list[name_]]
	
	
	
func free_world() -> void:
	var p_node = $"../"
	p_node.get_node("WorldEnvironment").free()
