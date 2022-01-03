extends Area

signal entered_player(obj)

func _ready() -> void:
	connect("body_entered",self,"_on_entered")
func _on_entered(obj) -> void:
	emit_signal("entered_player",obj)
