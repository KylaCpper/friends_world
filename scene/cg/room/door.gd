extends Event

var stop = false
var text =[
	"cg_room_door1",
	"cg_room_door2",
	
]
func _ready() -> void:
	if Overall.cg_scene != 1:
		stop = true
func _event(pos3:Vector3) -> bool:
	if stop:return
	Overall.player_node.control=false
	
	Overall.msg_big_node._show(text[0],"player",1.0)
	yield(Overall.msg_big_node,"end")
	
	Overall.msg_big_node._show(text[1],"player",1.0)
	yield(Overall.msg_big_node,"end")
	
	Overall.cg_scene+=1
	Global.GoTo_Scene("res://scene/cg/office1/main.tscn")
	return true

