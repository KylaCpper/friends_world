extends RigidBody2D

var move_speed := 20
var free := false
var name_ = "grass"
var textures = {
	"grass":preload("res://assets/img/2dgame/room/grass.png"),
	"grass_dirt":preload("res://assets/img/2dgame/room/grass_dirt.png"),
	"dirt":preload("res://assets/img/2dgame/room/dirt.png"),
	"leaves":preload("res://assets/img/2dgame/room/leaves.png"),
	"wood":preload("res://assets/img/2dgame/room/wood.png"),
	"stone":preload("res://assets/img/2dgame/room/stone.png"),
	
}
func _ready() -> void:
	set_process(false)
	$sprite.texture = textures[name_]
	linear_velocity = Vector2(0,-5)
	$"../player/area".connect("body_entered",self,"_on_enter_area")
	$"../player/pick".connect("body_entered",self,"_on_enter_pick")
	$Timer.start()
	$Timer.connect("timeout",self,"_on_timeout")

func _on_timeout() -> void:
	if !free:
		queue_free()
func _on_enter_area(obj) -> void:
	if obj == self:
		set_process(true)
func _on_enter_pick(obj) -> void:
	if obj == self:
		free = true
		$"../bar".add_item(name_,1)
		queue_free()

#func _process(delta) -> void:
#	var vec2 = position.direction_to($"../player".position)*(move_speed/position.distance_to($"../player".position))
##	if linear_velocity.y < 20:
#	vec2.y += 0.2
#
#	linear_velocity += vec2
