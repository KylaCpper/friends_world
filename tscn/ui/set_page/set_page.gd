extends Node2D

func _ready() -> void:
	hide()
	$blur.show()
	$bg.show()
	$sure.connect("pressed",self,"_on_sure")
	$sure.connect("mouse_entered",self,"_on_enter")
	$full_screen.connect("pressed",self,"_on_full_screen")
	$full_screen.connect("mouse_entered",self,"_on_enter")
	
	$blur.set_val(2.0)
	$main_sound_pro/scroll.connect("value_changed",self,"_on_main_sound_pro")
	$music_pro/scroll.connect("value_changed",self,"_on_music_pro")
	$sound_pro/scroll.connect("value_changed",self,"_on_sound_pro")
	$main_sound_pro/scroll.value = Save.set_data.main
	$music_pro/scroll.value = Save.set_data.music
	$sound_pro/scroll.value = Save.set_data.sound
func _on_sure() -> void:
	Overall.audio_node.play_ui("click")
	Save.save_set()
	Config.set_language(Config.languages_index)
	hide()
func _on_main_sound_pro(val:float) -> void:
	$main_sound_pro.value = val
	Save.set_data.main = val
	Save.set_sound()
func _on_music_pro(val:float) -> void:
	$music_pro.value = val
	Save.set_data.music = val
	Save.set_sound()
func _on_sound_pro(val:float) -> void:
	$sound_pro.value = val
	Save.set_data.sound = val
	Save.set_sound()
func _on_full_screen() -> void:
	Save.set_data.full = !Save.set_data.full
	OS.window_fullscreen = Save.set_data.full
	Save.save_set()
func _input(event) -> void:
	if event.is_action_pressed("esc"):
		if visible:
			_on_sure()
			get_tree().set_input_as_handled()

func show() -> void:
	visible = true
	set_process_input(true)
func hide() -> void:
	visible = false
	set_process_input(false)
	


func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$blur._on_screen(window_size,diff_size)
	$bg.rect_size = window_size+Vector2(5,5)
#	$sure.rect_position.x = window_size.x/2 - $sure.rect_size.x/2
#	$sure.rect_position.y += diff_size.y
	$sure.rect_position.x += diff_size.x
	$sure.rect_position.y = window_size.y - 140
	
	
	$main_sound_pro.rect_position.x += diff_size.x
	$music_pro.rect_position.x += diff_size.x
	$sound_pro.rect_position.x += diff_size.x

	$OptionButton.rect_position.x += diff_size.x
	$full_screen.rect_position.x += diff_size.x
func _on_enter() -> void:
	Overall.audio_node.play_ui("hover")
