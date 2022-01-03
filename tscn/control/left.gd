extends Control
var arrow_pos=Vector2()
var dis_max = 50
var index=-1
var angle = 90
var arrow_range = Vector2(672,704)
signal touch_event (touch_pos,angle,press)
func _ready():
#	$bg.connect("gui_input",self,"_gui_event")
	connect("touch_event",self,"_on_touch_event")
	set_process_input(true)
func _on_touch_event(touch_pos,angle,press):
	
	Overall.arrow_pos_left = touch_pos/dis_max
	Overall.arrow_angle_left = angle
	
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if !(event.position.x<arrow_range.x and event.position.y>arrow_range.y):return
			index = -1
			$handle/arrow.position = Vector2()
			index = event.index
			$ani.stop()
			$handle.modulate.a=1
			$handle.position=event.position-rect_position
			arrow_pos = event.position
			emit_signal("touch_event",Vector2(),angle,true)
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
			angle=180/3.14*pos.angle()
			emit_signal("touch_event",pos,angle,true)
func _on_clear():
	if index == -1:return
	index = -1
	$handle/arrow.position = Vector2()
	emit_signal("touch_event",Vector2(),angle,false)
	$ani.play("hide")
