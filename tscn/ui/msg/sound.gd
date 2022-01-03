extends Label
var name_ := "default"
var index := 1
func _ready() -> void:
	var offset = index*Vector2(0,-30)
	text = name_
	yield(get_tree(),"idle_frame")
	rect_position.x = 0
	$tween.connect("tween_all_completed",self,"_on_finished")
	$tween.interpolate_property(self, "modulate",
		Color(1,1,1,0), Color(1,1,1,1), 1.5,
		Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	$tween.interpolate_property(self, "modulate",
		Color(1,1,1,1), Color(1,1,1,0), 1.5,
		Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	$tween.interpolate_property(self, "rect_position",
		Vector2(rect_position.x, 0), Vector2(rect_position.x, -70)+offset, 3,
		Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	$tween.start()
	
func _on_finished()-> void:
	queue_free()
