extends Node2D
var id := -1
var stop := false
func _ready() -> void:
	hide()
	$sure.connect("pressed",self,"_on_sure")
	$cancel.connect("pressed",self,"_on_cancel")
	
	$sure.connect("mouse_entered",self,"_on_enter")
	$cancel.connect("mouse_entered",self,"_on_enter")
func _on_sure() -> void:
	Overall.audio_node.play_ui("click")
	if id != -1:
		stop = true
		$delete_wait_page.show()
		Save.delete_save(id)
		yield(Save,"done")
		$delete_wait_page.hide()
		stop = false
		_on_cancel()
		$"../".show()
func _on_cancel() -> void:
	Overall.audio_node.play_ui("click")
	if !stop:
		hide()

func show(id_:=-1) -> void:
	id = id_
	.show()


func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$delete_wait_page._on_screen(window_size,diff_size)
	$bg.rect_size = window_size+Vector2(5,5)
	$bg2.rect_position += diff_size
	$sure.rect_position += diff_size
	$cancel.rect_position += diff_size
	$Label.rect_position += diff_size
func _on_enter() -> void:
	Overall.audio_node.play_ui("hover")
