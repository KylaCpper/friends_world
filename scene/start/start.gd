extends Node2D

func _ready() -> void:
	$single.connect("pressed",self,"_on_single")
	$multiplayer.connect("pressed",self,"_on_multiplayer")
	$set.connect("pressed",self,"_on_set")
	$exit.connect("pressed",self,"_on_exit")
	$single.connect("mouse_entered",self,"_on_enter")
	$multiplayer.connect("mouse_entered",self,"_on_enter")
	$set.connect("mouse_entered",self,"_on_enter")
	$exit.connect("mouse_entered",self,"_on_enter")
	
	get_tree().connect("screen_resized",self,"_on_screen")
	_on_screen()
	var env = preload("res://default_environment.tres")
	set_process(false)
	$WorldEnvironment.environment = null
	yield(get_tree(),"idle_frame")
	$WorldEnvironment.environment = env
	set_process(true)
func queue_free() -> void:
	set_process(false)
	$WorldEnvironment.environment = null
	$WorldEnvironment.free()
	.queue_free()
var view_dis := 30.0
func _process(delta:float) -> void:
	if view_dis > 150 : 
		set_process(false)
		view_dis = 150
	$WorldEnvironment.environment.fog_depth_begin = 0+view_dis
	$WorldEnvironment.environment.fog_depth_end = 50+view_dis
	view_dis += 0.2
	
func free_world() -> void:
#	$WorldEnvironment.environment.f()
#	$WorldEnvironment.free()
	pass
var window_size_be = Config.window_size
func _on_screen() -> void:
	var window_size = get_viewport().size
	if !Config.ADAPTATION:
		window_size = Vector2(1024,600)
	var diff_size = window_size - window_size_be 
	diff_size /=2
	window_size_be = window_size
#	$single.rect_position.x = 150*window_size.x/Config.window_size.x
#	$multiplayer.rect_position.x = $single.rect_position.x
#	$set.rect_position.x = $single.rect_position.x
#	$exit.rect_position.x = $single.rect_position.x
	$single.rect_position.x = 150
	$multiplayer.rect_position.x = $single.rect_position.x
	$set.rect_position.x = $single.rect_position.x
	$exit.rect_position.x = $single.rect_position.x
	
	$single.rect_position.y = window_size.y-360
	$multiplayer.rect_position.y = window_size.y-280
	$set.rect_position.y = window_size.y-200
	$exit.rect_position.y = window_size.y-120
	
	
	$world_page._on_screen(window_size,diff_size)
	$set_page._on_screen(window_size,diff_size)
	$net_page._on_screen(window_size,diff_size)
	
func _on_single() -> void:
	Overall.audio_node.play_ui("click")
	$world_page.show()
func _on_multiplayer() -> void:
	Overall.audio_node.play_ui("click")
	$net_page.show()
func _on_set() -> void:
	Overall.audio_node.play_ui("click")
	$set_page.show()
func _on_exit() -> void:
	Overall.audio_node.play_ui("click")
	get_tree().quit()


func _on_enter() -> void:
	Overall.audio_node.play_ui("hover")


