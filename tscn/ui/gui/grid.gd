extends Node2D

func drop() -> void:
	if Overall.pick_item_node.is_item:
		Overall.pick_item_node.item.num -= 1
		Overall.player_node.drop(Overall.pick_item_node.item.name,1,Overall.pick_item_node.item.hp)
func drops() -> void:
	if Overall.pick_item_node.is_item:
		Overall.player_node.drop(Overall.pick_item_node.item.name,Overall.pick_item_node.item.num,Overall.pick_item_node.item.hp)
		Overall.pick_item_node.set_item(false)
func is_gui() -> bool:
	for grid_obj in Overall.gui_node_node.grid_objs:
		if grid_obj.is_enter():
			return true
	
	return false


func _input(event:InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		if !is_gui():
			drops()
	if event.is_action_pressed("mouse_right"):
		if !is_gui():
			drop()
