extends Control
var arrow_pos=Vector2()

var index=-1
var angle = 90
var arrow_range = Vector2(350,350)
signal touch_event (touch_pos,angle,press)
var press := false
func _ready():
#	$bg.connect("gui_input",self,"_gui_event")
	if !Overall.phone:
		set_process_input(false)
		return
#	var window = get_viewport().size
	var window = Config.window_size
	arrow_range = Vector2(window.x/3,window.y/2)
	connect("touch_event",self,"_on_touch_event")
	set_process_input(true)
func _on_touch_event(touch_pos,angle,press):
	Overall.arrow_pos_left = touch_pos
	Overall.arrow_angle_left = angle
	self.press = press
	if press:
		check()
	else:
		clear()
func _input(event):
	if Overall.gui:return
	if event is InputEventScreenTouch:
		if event.pressed:
			if !(event.position.x<arrow_range.x and event.position.y>arrow_range.y):
				Overall.player_node.mouse = false
				return
			index = -1
			$handle/arrow.position = Vector2()
			index = event.index
			$ani.stop()
			$handle.modulate.a=1
			$handle.position=event.position-rect_position
			arrow_pos = event.position
			emit_signal("touch_event",Vector2(),angle,true)
			Overall.player_node.mouse = true
		else:
			if index == event.index:
				_on_clear()
	if event is InputEventScreenDrag:
		if index == event.index:
			Overall.player_node.mouse = true
			$ani.stop()
			$handle.modulate.a=1
			var pos = event.position-arrow_pos
			if pos.distance_to(Vector2(0,0))<50:
				$handle/arrow.position = pos
			else:
				pos = pos.clamped(50)
				$handle/arrow.position = pos
			angle=180/3.14*pos.angle()
			emit_signal("touch_event",pos,angle,true)
func _on_clear():
	if index == -1:return
	index = -1
	$handle/arrow.position = Vector2()
	emit_signal("touch_event",Vector2(),angle,false)
	$ani.play("hide")
	Overall.player_node.mouse = false
	
var w := false
var a := false
var d := false
var s := false
func check():
	
	if angle > -70 && angle < 70:
		if !d:
			d = true
			var ev = InputEventAction.new()
			ev.pressed = true
			ev.action = "d"
			Input.parse_input_event(ev)
	else:
		if d:
			d = false
			var ev = InputEventAction.new()
			ev.pressed = false
			ev.action = "d"
			Input.parse_input_event(ev)
	if angle > -160 && angle < -20:
		if !w:
			w = true
			var ev = InputEventAction.new()
			ev.pressed = true
			ev.action = "w"
			Input.parse_input_event(ev)
	else:
		if w:
			w = false
			var ev = InputEventAction.new()
			ev.pressed = false
			ev.action = "w"
			Input.parse_input_event(ev)
	if angle > 20 && angle < 160:
		if !s:
			s = true
			var ev = InputEventAction.new()
			ev.pressed = true
			ev.action = "s"
			Input.parse_input_event(ev)
	else:
		if s:
			s = false
			var ev = InputEventAction.new()
			ev.pressed = false
			ev.action = "s"
			Input.parse_input_event(ev)
	if angle > 110 || angle < -110:
		if !a:
			a = true
			var ev = InputEventAction.new()
			ev.pressed = true
			ev.action = "a"
			Input.parse_input_event(ev)
	else:
		if a:
			a = false
			var ev = InputEventAction.new()
			ev.pressed = false
			ev.action = "a"
			Input.parse_input_event(ev)

func clear():
	if d:
		d = false
		var ev = InputEventAction.new()
		ev.pressed = false
		ev.action = "d"
		Input.parse_input_event(ev)
	if w:
		w = false
		var ev = InputEventAction.new()
		ev.pressed = false
		ev.action = "w"
		Input.parse_input_event(ev)
	if s:
		s = false
		var ev = InputEventAction.new()
		ev.pressed = false
		ev.action = "s"
		Input.parse_input_event(ev)
	if a:
		a = false
		var ev = InputEventAction.new()
		ev.pressed = false
		ev.action = "a"
		Input.parse_input_event(ev)
