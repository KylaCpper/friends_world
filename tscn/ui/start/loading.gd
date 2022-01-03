extends Node2D
func _ready() -> void:
	add_to_group("loading")
	hide()
	$time_text.connect("timeout",self,"_on_time_text")
	$time_bar.connect("timeout",self,"_on_time_bar")
	$cancel.connect("pressed",self,"_on_pressed")
	
	$fail/cancel.connect("pressed",self,"_on_fail_hide")
	
	
func connect_err_name() -> void:
	_on_fail_show("connect_err_name")
	
	
	
	
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$blur._on_screen(window_size,diff_size)
	$blur.rect_position -= diff_size
#	position += diff_size
#
const text_num_max := 5
var text_num := 1
func _on_time_text() -> void:
	$text.text = tr("connecting_ui")
	for i in range(text_num):
		$text.text += "."
	text_num += 1
	if text_num >= text_num_max:
		text_num = 1

var index := 0
const index_max := 22
func _on_time_bar() -> void:
	for i in range(index_max): 
		var i_ = i - index
		if i_ < 0:
			i_ = index_max + i_ 
		var pro = i_ * 0.045
		get_node("bar/bar"+str(i)).modulate = Color(pro,pro,pro)
#		get_node("bar/bar"+str(i)).rect_scale.y = 0.8+pro/5
		get_node("bar/bar"+str(i)).rect_scale.y = 1.0
	index += 1
	if index >= index_max:
		index = 0
		
func _input(event:InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if $fail.visible:
			return
		if visible:
			hide()
			get_tree().set_input_as_handled()
func _on_pressed() -> void:
	hide()
	Net.close_connect()
	
func _on_fail_show(text:String) -> void:
	$fail/text.text = text
	$fail.show()
	$fail/blur.set_val(1.0)
func _on_fail_hide() -> void:
	$fail.hide()
	hide()
#	Net.close_connect()

func hide() -> void:
	.hide()
	$time_bar.stop()
	$time_text.stop()
func show() -> void:
	.show()
	$blur.set_val(1.0)
	$time_bar.start()
	$time_text.start()
