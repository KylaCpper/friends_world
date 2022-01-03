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
func play_atk(speed:float) -> void:
	if !eating:
		if !$AnimationPlayer1.is_playing():
			$AnimationPlayer1.play("atk",-1,speed)
		$AnimationPlayer.play("atk",-1,speed)
func play_event(speed:float) -> void:
	if !eating:
		if !$AnimationPlayer1.is_playing():
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
			$AnimationPlayer1.play("default")
			$AnimationPlayer1.play("change")
	$Armature/Skeleton/hand_bone.change_hand(name_)
onready var vec := self.translation
var time := 0.0
var type := 0
var time_max := 0.32
var shake := false
var offset_pro := 1.0
var damage := false
var damage_pro := 1.0
var yy := 0.0
var xx := 0.0
func _unhandled_input(event) -> void:
	if !Overall.gui:
		if event is InputEventMouseMotion:
			xx += event.relative.x * 0.0001
			xx = clamp(xx, -0.05, 0.05)
			yy += event.relative.y * 0.0001
			yy = clamp(yy, -0.05, 0.05)
			$Armature/Skeleton.translation = Vector3(xx,0,yy)
			
func _process(delta:float) -> void:
	if !shake:
#		$tween.stop_all()
		$tween2.stop_all()
#		translation = vec
#		$"../".translation = Vector3()
		time = 2
		type = 0
		return
	time_max = 0.32/offset_pro
	time += delta
	if time >= time_max:
		time = 0.0

		var tween = $tween
		if type == 1:
			var offset : Vector3
			if damage:
				offset = Vector3(0.05,(randf()-0.5)*0.1,0.01)*damage_pro
			else:
				offset = Vector3(0.02,0.01,0.01)
			tween.interpolate_property(self, "translation",
					translation, translation+offset, time_max,
					Tween.TRANS_SINE , Tween.EASE_IN)
		if type == 3:
			var offset : Vector3
			if damage:
				offset = Vector3(-0.05,(randf()-0.5)*0.1,0.01)*damage_pro
			else:
				offset = Vector3(-0.02,0.01,0.01)
			tween.interpolate_property(self, "translation",
					translation, translation+offset, time_max,
					Tween.TRANS_SINE , Tween.EASE_IN)
		if type == 0 || type == 2:
			tween.interpolate_property(self, "translation",
					translation,vec, time_max,
					Tween.TRANS_SINE , Tween.EASE_IN)
		tween.start()
		
		tween = $tween2
		var camera = $"../"
		var tran = camera.translation
		if type == 1:
			var offset : Vector3
			if damage:
				offset = Vector3(0.1,(randf()-0.5),(randf()-0.5))*damage_pro
			else:
				offset = Vector3(0.05,-0.05,0.0)
			tween.interpolate_property(camera, "translation",
					tran, tran+offset, time_max,
					Tween.TRANS_SINE , Tween.EASE_OUT)
		if type == 3:
			var offset : Vector3
			if damage:
				offset = Vector3(-0.1,(randf()-0.5),(randf()-0.5))*damage_pro
			else:
				offset = Vector3(-0.05,-0.05,0.0)
			tween.interpolate_property(camera, "translation",
					tran, tran+offset, time_max,
					Tween.TRANS_SINE , Tween.EASE_OUT)
		if type == 0 || type == 2:
			tween.interpolate_property(camera, "translation",
					tran,Vector3(), time_max,
					Tween.TRANS_SINE , Tween.EASE_OUT)
		tween.start()
		
		type += 1
		if type == 4:
			type = 0
