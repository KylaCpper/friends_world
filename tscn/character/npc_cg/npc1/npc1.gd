extends Spatial

var text = [
	"cg_npc1_1","cg_npc1_2","cg_npc1_3",
	"cg_npc1_4"
]
func _ready() -> void:
	
	$"player/Skeleton/body".material_override = $"player/Skeleton/body".material_override.duplicate()
	$AnimationPlayer.connect("animation_finished",self,"_on_finished")
	$AnimationPlayer.play("keyboard")
	while true :
		$msg._show(text[randi()%text.size()],false)
		var time = randi()%10+3
		yield(get_tree().create_timer(time),"timeout")
func _on_finished(name_:String) ->void:
	$AnimationPlayer.play("keyboard")
	

func _event(pos3:Vector3) -> bool:
	$msg._show(text[randi()%text.size()])
	return true
	
