extends Area

signal entered_player(obj)
signal exited_player(obj)
func _ready() -> void:
	connect("body_entered",self,"_on_entered")
	connect("body_exited",self,"_on_exited")
func _on_entered(obj) -> void:
	emit_signal("entered_player",obj)
func _on_exited(obj) -> void:
	emit_signal("exited_player",obj)
