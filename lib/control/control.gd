extends Node2D


func _ready() -> void:
	if !Overall.phone:
		hide()
	else:
		show()
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	
#	position += diff_size
	var x = window_size.x-200
	var y = window_size.y-100
	$left2.rect_position = Vector2(window_size.x/4,window_size.y/1.2)
	$bag.rect_position = Vector2(x,y-400)
	$jump.rect_position = Vector2(x,y-200)
	$shift.rect_position = Vector2(x,y-100)
	$enter.rect_position = Vector2(x+100,y)

	$return.rect_position = Vector2(15,30)
