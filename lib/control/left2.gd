extends Control
var arrow_pos=Vector2()

var index=-1
var angle = 90
var arrow_range = Vector2(350,350)
signal touch_event (touch_pos,angle,press)
var w := false
var a := false
var d := false
var s := false
func _ready():
#	$bg.connect("gui_input",self,"_gui_event")
	var window = get_viewport().size
	arrow_range = Vector2(window.x/2,window.y/2)
	
	connect("touch_event",self,"_on_touch_event")
	
	set_process_input(true)
func _on_touch_event(touch_pos,angle,press):
	Overall.arrow_pos_left = touch_pos
	Overall.arrow_angle_left = angle
	
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
#			if !(event.position.x<arrow_range.x and event.position.y>arrow_range.y):return
			index = -1
#			$handle/arrow.position = Vector2()
			index = event.index
			check(event.position)
		else:
			if index == event.index:
				_on_clear()
	if event is InputEventScreenDrag:
		if index == event.index:
			check(event.position)

func _on_clear():
	if index == -1:return
	index = -1
	check(Vector2(0,0))

var up := preload("res://lib/control/control3.png")
var down := preload("res://lib/control/control4.png")
func check(vec2):
	if $right.get_global_rect().has_point(vec2):
		d = true
		var ev = InputEventAction.new()
		ev.pressed = true
		ev.action = "d"
		Input.parse_input_event(ev)
		$right/Sprite.texture = down
	else:
		d = false
		var ev = InputEventAction.new()
		ev.pressed = false
		ev.action = "d"
		Input.parse_input_event(ev)
		$right/Sprite.texture = up
	if $up.get_global_rect().has_point(vec2):
		w = true
		var ev = InputEventAction.new()
		ev.pressed = true
		ev.action = "w"
		Input.parse_input_event(ev)
		$up/Sprite.texture = down
	else:
		w = false
		var ev = InputEventAction.new()
		ev.pressed = false
		ev.action = "w"
		Input.parse_input_event(ev)
		$up/Sprite.texture = up
	if $down.get_global_rect().has_point(vec2):
		s = true
		var ev = InputEventAction.new()
		ev.pressed = true
		ev.action = "s"
		Input.parse_input_event(ev)
		$down/Sprite.texture = down
	else:
		s = false
		var ev = InputEventAction.new()
		ev.pressed = false
		ev.action = "s"
		Input.parse_input_event(ev)
		$down/Sprite.texture = up
	if $left.get_global_rect().has_point(vec2):
		a = true
		var ev = InputEventAction.new()
		ev.pressed = true
		ev.action = "a"
		Input.parse_input_event(ev)
		$left/Sprite.texture = down
	else:
		a = false
		var ev = InputEventAction.new()
		ev.pressed = false
		ev.action = "a"
		Input.parse_input_event(ev)
		$left/Sprite.texture = up
