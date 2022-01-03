extends Control
var index = -1
var arrow_pos = Vector2()
var relative = Vector2()
var arrow_range = Vector2(600,350)
var key = "mouse_left"
signal touch_event (touch_pos,relative,press)
func _ready():
	if !Overall.phone:
		set_process(false)
		set_process_input(false)
		return
#	var window = get_viewport().size
	var window = Config.window_size
#	arrow_range = Vector2(window.x/3*2,window.y/3*2)
	arrow_range = Vector2(window.x/3,window.y/2)
#	$bg.connect("gui_input",self,"_gui_event")
	connect("touch_event",self,"_on_touch_event")
#	set_process(false)
	set_process_input(true)
onready var objs = [$"../../bar/bg",$"../jump",$"../bag",$"../enter",$"../shift"]
var pos2 := Vector2()
func _on_touch_event(touch_pos,relative,press):
	Overall.arrow_pos_right = touch_pos
	Overall.arrow_angle_right = relative
	Overall.press=press
func _input(event):
	if Overall.gui:return
	if event is InputEventScreenTouch:
		pos2 = event.position
		if event.pressed:
			if (event.position.x<arrow_range.x and event.position.y>arrow_range.y):
				more = true
				
				return
			else:
				more = false
			index = -1
			$handle/arrow.position = Vector2()
			index = event.index
			
			Overall.touch_right_index = index
			$ani.stop()
			$handle.modulate.a=1
			$handle.position=event.position-rect_position

			arrow_pos = event.position
			emit_signal("touch_event",Vector2(),Vector2(),true)
		else:
			if index == event.index:
				_on_clear()
	if event is InputEventScreenDrag:
		pos2 = event.position
		if index == event.index:
			Overall.player_node.mouse = false
			$ani.stop()
			$handle.modulate.a=1
			var pos = event.position-arrow_pos
			if pos.distance_to(Vector2(0,0))<50:
				$handle/arrow.position = pos
			else:
				pos = pos.clamped(50)
				$handle/arrow.position = pos
			emit_signal("touch_event",pos,event.relative,true)

func _on_clear():
	if index == -1:return
	Overall.touch_right_index = -1
	index = -1
	$ani.play("hide")
	emit_signal("touch_event",Vector2(),Vector2(),false)
	$handle/arrow.position = Vector2()
var time := 0.0
var more := false
var mouse_left := false
func _process(delta:float) -> void:
	if Overall.gui:
#		if Overall.press:
#			time += delta
#			if time > 0.0:
#				if time <= 0.1:
#					var ev = InputEventAction.new()
#					ev.pressed = true
#					ev.action = "touch_left"
#					Input.parse_input_event(ev)
#					yield(get_tree(),"idle_frame")
#					yield(get_tree(),"idle_frame")
#					var ev1 = InputEventAction.new()
#					ev1.pressed = false
#					ev1.action = "touch_left"
#					Input.parse_input_event(ev1)
#				else:
#					var ev = InputEventAction.new()
#					ev.pressed = true
#					ev.action = "touch_right"
#					Input.parse_input_event(ev)
#					yield(get_tree(),"idle_frame")
#					yield(get_tree(),"idle_frame")
#					var ev1 = InputEventAction.new()
#					ev1.pressed = false
#					ev1.action = "touch_right"
#					Input.parse_input_event(ev1)
#
#			time = 0.0
			return
	if more:return

	if Overall.press:
		time += delta
		if time > 0.1:
			mouse_left = true
			var ev = InputEventMouseButton.new()
			ev.pressed = true
			ev.button_index = 1
			ev.position = pos2
			Input.parse_input_event(ev)
	else:
		if mouse_left:
			var ev = InputEventMouseButton.new()
			ev.pressed = false
			ev.button_index = 1
			ev.position = pos2
			Input.parse_input_event(ev)
		if time > 0.0:
			for obj in objs:
				if obj.get_global_rect().has_point(pos2):
					mouse_left = false
					time = 0.0
					return
			if time <= 0.1:
				var evf = InputEventAction.new()
				evf.pressed = true
				evf.action = "f"
				Input.parse_input_event(evf)
				var ev = InputEventMouseButton.new()
				ev.pressed = true
				ev.button_index = 2
				ev.position = pos2
				Input.parse_input_event(ev)
				yield(get_tree(),"idle_frame")
				yield(get_tree(),"idle_frame")
				var ev1 = InputEventMouseButton.new()
				ev1.pressed = false
				ev1.button_index = 2
				ev.position = pos2
				Input.parse_input_event(ev1)

		mouse_left = false
		time = 0.0
