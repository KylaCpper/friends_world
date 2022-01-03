extends TextureButton

export var key := "jump"
var press := false
func _ready() -> void:
	if !Overall.phone:
		set_process_input(false)
		
	
func _on_pressed() -> void:
	if !press:
		var ev = InputEventAction.new()
		ev.action = key
		ev.pressed = true
		Input.parse_input_event(ev)
	press = true
	pressed = true
func _on_released() -> void:
	if press:
		var ev = InputEventAction.new()
		ev.action = key
		ev.pressed = false
		Input.parse_input_event(ev)
	press = false
	pressed = false
func _input(event) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if get_global_rect().has_point(event.position):
				_on_pressed()
			else:
				_on_released()
		else:
			_on_released()
#	if event is InputEventScreenDrag:
#		if get_global_rect().has_point(event.position):
#			_on_pressed()
