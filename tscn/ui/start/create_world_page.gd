extends Node2D

func _ready() -> void:
	hide()
	$blur.set_val(3.0)
	$create.connect("pressed",self,"_on_create")
	$cancel.connect("pressed",self,"_on_cancel")
	$seed/Button.connect("pressed",self,"_on_rand")
	
	$create.connect("mouse_entered",self,"_on_enter")
	$cancel.connect("mouse_entered",self,"_on_enter")
	$seed/Button.connect("mouse_entered",self,"_on_enter")
	
	$world_name.connect("text_changed",self,"_on_world_name")
	$seed.text = str(randi())
func _on_create() -> void:
	Overall.audio_node.play_ui("click")
	Save.save_data_be.seed_num = int($seed.text)
	Save.create_new_save()
	hide()
	$"../".show()
func _on_cancel() -> void:
	Overall.audio_node.play_ui("click")
	hide()
func _on_world_name(text:String) -> void:
	Save.save_data_be.world_name = text

func _on_rand() -> void:
	Overall.audio_node.play_ui("click")
	$seed.text = str(randi())
func _input(event:InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			hide()
			get_tree().set_input_as_handled()

func show() -> void:
	$world_name.text = Save.world_name+str(Save.world_name_index)
	_on_world_name($world_name.text)
	visible = true
	set_process_input(true)
func hide() -> void:
	visible = false
	set_process_input(false)





func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$blur._on_screen(window_size,diff_size)
	$bg.rect_size = window_size+Vector2(5,5)

	$create.rect_position.y = abs(180 - window_size.y)
	$cancel.rect_position.y = abs(180 - window_size.y)
	
	$create.rect_position.x += diff_size.x
	$cancel.rect_position.x += diff_size.x
	$seed.rect_position.x += diff_size.x
	$world_name.rect_position.x += diff_size.x

func _on_enter() -> void:
	Overall.audio_node.play_ui("hover")
