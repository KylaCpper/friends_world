extends Spatial
var hand := ""
var is_ready := false
func _ready() -> void:
	$AnimationPlayer.connect("animation_finished",self,"_on_ani_finished")
	$AnimationPlayer.play("default")
	yield($AnimationPlayer,"animation_finished")
	is_ready = true

func _on_ani_finished(name_:String) -> void:
	if name_ == "eat":
		if eating:
			$AnimationPlayer.play("eating")
	
	
func play_event(speed:float) -> void:
	if !eating:
		$AnimationPlayer1.play("event",-1,speed)
		$AnimationPlayer.play("event",-1,speed)
var eating := false
func play_eat(eat:bool) -> void:
	eating = eat
	if eat:
		$AnimationPlayer.play("eat")
	else:
		$AnimationPlayer.play("default")

func change_hand(name_:="") -> void:
	if hand != name_:
		hand = name_
		if is_ready:
			$AnimationPlayer1.play("change")
	$Armature/Skeleton/hand_bone.change_hand(name_)

