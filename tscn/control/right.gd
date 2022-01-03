extends Control
var dis_max = 50
var index = -1
var arrow_pos = Vector2()
var relative = Vector2()
var arrow_range = Vector2(644,704)
signal touch_event (touch_pos,relative,press)
func _ready():
#	$bg.connect("gui_input",self,"_gui_event")
	connect("touch_event",self,"_on_touch_event")
	set_process(false)
#	set_process_input(true)
	set_process_input(false)
func _on_touch_event(touch_pos,relative,press):
	Overall.arrow_pos_right = touch_pos/dis_max
	Overall.arrow_angle_right = relative
	Overall.press=press
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if !(event.position.x>arrow_range.x and event.position.y>arrow_range.y):return
			index = -1
			$handle/arrow.position = Vector2()
			index = event.index
			$ani.stop()
			$handle.modulate.a=1
			$handle.position=event.position-rect_position
#			var ev = InputEventAction.new()
#			ev.pressed = true
#			ev.action = Overall.press_action
#			Input.parse_input_event(ev)
			arrow_pos = event.position
			emit_signal("touch_event",Vector2(),Vector2(),true)
		else:
			if index == event.index:
				_on_clear()
	if event is InputEventScreenDrag:
		if index == event.index:
			$ani.stop()
			$handle.modulate.a=1
			var pos = event.position-arrow_pos
			if pos.distance_to(Vector2(0,0))<dis_max:
				$handle/arrow.position = pos
			else:
				pos = pos.clamped(dis_max)
				$handle/arrow.position = pos
			emit_signal("touch_event",pos,event.relative,true)

func _on_clear():
	if index == -1:return
	index = -1
	$ani.play("hide")
	emit_signal("touch_event",Vector2(),Vector2(),false)
	$handle/arrow.position = Vector2()
