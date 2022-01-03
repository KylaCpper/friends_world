extends Node2D

func _ready() -> void:
	hide()
func show() -> void:
	set_process(true)
	.show()
func hide() -> void:
	set_process(false)
	.hide()
var time := 0.0
var time_max := 0.8
var num := 0
var num_max := 6
func _process(delta:float) -> void:
	time+=delta
	if time > time_max:
		time = 0.0
		num += 1
		if num >= num_max:num =0
		for i in range(num_max):
			if i <= num:
				get_node("point"+str(i+1)).show()
			else:
				get_node("point"+str(i+1)).hide()

func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$bg.rect_size = window_size+Vector2(5,5)
	$Label.rect_position += diff_size
	$point1.rect_position += diff_size
	$point2.rect_position += diff_size
	$point3.rect_position += diff_size
	$point4.rect_position += diff_size
	$point5.rect_position += diff_size
	$point6.rect_position += diff_size
