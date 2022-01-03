extends Panel

signal end
var free := false

var vec4_160 = Rect2(75,84,40,40)
var scale_160 = 2
var vec4_52 = Rect2(23,0,13,13)
var scale_52 = 6

func _ready() -> void:
	Overall.msg_big_node = self
	$AnimationPlayer.play("stop")
	hide()
	set_process(false)
	
func _show(text:String,name_ := "player",time:=1.0,audio:=true) -> void:
	visible = true
	var texture = Character[name_]
	var itex = ImageTexture.new()
	itex.create_from_image(texture.get_data(),0)
	if name_ == "boss":
		$Sprite.region_rect = vec4_160
		$Sprite.scale = Vector2(scale_160,scale_160)
	else:
		$Sprite.region_rect = vec4_52
		$Sprite.scale = Vector2(scale_52,scale_52)
	$Sprite.texture = itex
	$Label.text = ""
	self.text = tr(text)
	i = 0
	if audio:
		Overall.audio_node.talk(true,name_)
	set_process(true)
	free = false
	yield(get_tree().create_timer(time),"timeout")
	free = true
	if end:
		Overall.audio_node.talk(false)
		$AnimationPlayer.play("start")
	
func show(text:="",name_ := "player",time:=1.0,audio:=true) -> void:
	.show()
	var texture = Character[name_]
	var itex = ImageTexture.new()
	itex.create_from_image(texture.get_data(),0)
	if name_ == "boss":
		$Sprite.region_rect = vec4_160
		$Sprite.scale = Vector2(scale_160,scale_160)
	else:
		$Sprite.region_rect = vec4_52
		$Sprite.scale = Vector2(scale_52,scale_52)
	$Sprite.texture = itex
	$Label.text = ""
	self.text = tr(text)
	i = 0
	if audio:
		Overall.audio_node.talk(true,name_)
	set_process(true)
	free = false
	yield(get_tree().create_timer(time),"timeout")
	free = true
	if end:
		Overall.audio_node.talk(false)
		$AnimationPlayer.play("start")
	
var time := 0.0
var text := ""
var i := 0
var end := false
func _process(delta) -> void:
	end = false
	time += delta
	
	if time >= 0.1:
		time = 0
		$Label.text += text[i]
		i += 1
		if i >= text.length():
			set_process(false)
			yield(get_tree().create_timer(0.2),"timeout")
			end = true
			if free:
				Overall.audio_node.talk(false)
				$AnimationPlayer.play("start")
func _input(event:InputEvent) -> void:
	if end&&free:
		event
		if event.is_action_pressed("enter") || event.is_action_pressed("mouse_left") || event.is_action_pressed("space"):
			hide()
			$AnimationPlayer.play("stop")
			emit_signal("end")
onready var offset = Config.window_size - rect_size
onready var offset_pos = Config.window_size - rect_position
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	rect_size.x = window_size.x - offset.x
	rect_position.x = (window_size.x - rect_size.x)/2
	rect_position.y = window_size.y-offset_pos.y
	$Label.rect_size.x += diff_size.x*2
	$pos2.position.x += diff_size.x*2
