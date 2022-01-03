extends Node2D
var text_tscn := preload("res://tscn/ui/msg/msg.tscn")

func add_msg(name_:String) -> void:
	var tscn = text_tscn.instance()
	tscn.name_ = name_
	tscn.index = get_child_count()
	add_child(tscn)
func _ready() -> void:
	Overall.msg_node = self
	
	


func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	position = Vector2(window_size.x/2,window_size.y/3)
