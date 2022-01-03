extends Event

var done := false
var text = [
	"cg_office_door1",
	"cg_office_door2",
]

func _ready() -> void:
	pass
func _event(pos3:Vector3) -> bool:
	Overall.player_node.control=false
	
	if done:
		Overall.msg_big_node._show(text[0],"player",1.0)
		yield(Overall.msg_big_node,"end")
		Overall.cg_scene+=1
		Global.GoTo_Scene("res://scene/cg/room/main.tscn")
	else:
		Overall.msg_big_node._show(text[1],"player",1.0)
		yield(Overall.msg_big_node,"end")
		Overall.player_node.control=true
	return true

