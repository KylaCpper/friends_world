extends Node2D
var text_tscn := preload("res://tscn/ui/msg_pickup/text.tscn")
func add_msg(name_:String,num := 1) -> void:
	if name_:
		var tscn = text_tscn.instance()
		tscn.name_ = name_
		tscn.num = num
		tscn.index = get_child_count()
		add_child(tscn)
func _ready() -> void:
	Overall.msg_pickup_node = self 
	
	

onready var offset_pos = Config.window_size - position
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	position = window_size-offset_pos
