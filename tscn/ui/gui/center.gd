extends Node2D


func _ready() -> void:
	Overall.center_node = self

func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	position = window_size/2


var msg_pop_tscn := preload("res://tscn/ui/msg_pop/msg_pop.tscn")
func add_msg_pop(text:String) -> void:
	var tscn = msg_pop_tscn.instance()
	tscn.text = text
	add_child(tscn)
