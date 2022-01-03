extends Node2D
var text_tscn := preload("res://tscn/ui/msg/sound.tscn")
#player_move_sound
#damage_block_sound
#fall_sound
#crash_block_sound
#fire_sound
#water_move_sound
func add_msg(name_:String) -> void:
	var tscn = text_tscn.instance()
	tscn.name_ = name_
	tscn.index = get_child_count()
	add_child(tscn)
func _ready() -> void:
	Overall.msg_sound_node = self 
	
	


onready var offset_x = position.x
onready var offset_y = Config.window_size.y - position.y
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	position = Vector2(offset_x,window_size.y - offset_y)
