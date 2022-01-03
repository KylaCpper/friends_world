extends KinematicBody2D

var move_speed = 50
var jump_speed = 80
var gravity = 2
func _ready() -> void:
	set_physics_process(true)
var vec = Vector2()
var is_jump = true
var time = 0
var time_max = 0.6
func _physics_process(delta) -> void:
	if !$"../".start:return
	vec.x = 0
	var w = Input.is_action_pressed("w")
	var a = Input.is_action_pressed("a")
	var s = Input.is_action_pressed("s")
	var d = Input.is_action_pressed("d")
	var jump = Input.is_action_pressed("space")
	if a:
		vec.x = -move_speed
		$head.flip_h = true
		$body.flip_h = true
	if d:
		vec.x = move_speed
		$head.flip_h = false
		$body.flip_h = false
	if a||d:
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play("walk")
		time+=delta
		if time>time_max:
			time=0
			var name_ = $"../map".get_block(position+Vector2(0,16))
			if name_:
				if name_ == "grass_dirt":name_ = "grass"
				if name_ == "leaves":name_ = "leaf"
				get_node("walk/"+name_).play()
	else:
		$AnimationPlayer.play("stop")
	vec.y += gravity
	
	if is_on_floor():
		vec.y = 0
		is_jump = true
	if jump&&is_jump:
		vec.y = -jump_speed
		is_jump = false
	
	move_and_slide(vec,Vector2(0,-1))
