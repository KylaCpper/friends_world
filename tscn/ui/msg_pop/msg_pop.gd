extends Panel

var text := ""

func _ready() -> void:
	$text.text = text
	$AnimationPlayer.connect("animation_finished",self,"_on_finished")
	$AnimationPlayer.play("start")

func _on_finished(name_:String) -> void:
	queue_free()
