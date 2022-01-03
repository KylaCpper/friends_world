extends Spatial
var time := 0.0
var list ={
	"player_move_sound":"walk_time",
	"hurt_block_sound":"hurt_block_time",
	"hit_sound":"hit_time",
	"wave_sound":"wave_time",
	"fall_sound":"fall_time",
	"hurt_sound":"hurt_time",
}
func _ready() -> void:
	pass

func walk(name_:="stone") -> void:
	if name_!="air":
		if $"../".run:
			check_msg_sound("run_sound")
		else:
			check_msg_sound("move_sound")
	if has_node("walk/"+name_):
		get_node("walk/"+name_).play()
func hurt_block(name_:="stone") -> void:
	check_msg_sound("hurt_block_sound")
	if has_node("hurt_block/"+name_):
		get_node("hurt_block/"+name_).play()
func hit(name_:="hit") -> void:
	check_msg_sound("hit_sound")
	if has_node("hit/"+name_):
		get_node("hit/"+name_).play()
func wave() -> void:
	check_msg_sound("wave_sound")
	$wave.play(0.4)
func fall() -> void:
	check_msg_sound("fall_sound")
func hurt() -> void:
	check_msg_sound("hurt_sound")
func eat() -> void:
	check_msg_sound("eat_sound")
func check_msg_sound(name_:String) -> void:
	if Overall.player_node.translation.distance_to($"../".translation) > 10:return
	if time >= 1.0:
		time = 0.0
		Overall.msg_sound_node.add_msg(name_)
func _process(delta:float) -> void:
	time += delta
	
