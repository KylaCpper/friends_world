extends Node

var damage_block_time := 0.0
var place_block_time := 0.0
var fall_time := 0.0
var list ={
	"damage_block_sound":"damage_block_time",
	"place_block_sound":"place_block_time",
	"fall_block_sound":"fall_time",
}
var damage_list = {
	
}
var walk_list = {
	
}
func damage(name_:String,pos3:Vector3) -> void:
	
	check_msg_sound("damage_block_sound",pos3)
	if name_ in damage_list:
		var tscn = damage_list[name_].instance()
		tscn.translation = pos3
		Overall.terrain_node_node.add_child(tscn)
func fall(name_:String,pos3:Vector3) -> void:
	
	check_msg_sound("fall_block_sound",pos3)
	if name_ in damage_list:
		var tscn = damage_list[name_].instance()
		tscn.translation = pos3
		Overall.terrain_node_node.add_child(tscn)
func place(name_:String,pos3:Vector3) -> void:
	
	check_msg_sound("place_block_sound",pos3)
	if name_ in damage_list:
		var tscn = damage_list[name_].instance()
		tscn.translation = pos3
		Overall.terrain_node_node.add_child(tscn)
func check_msg_sound(name_:String,pos3:Vector3) -> void:
	if pos3.distance_to(Overall.player_node.translation) < 7:
		if self[list[name_]] >= 1.0:
			self[list[name_]] = 0.0
			Overall.msg_sound_node.add_msg(name_)
func _process(delta:float) -> void:
	damage_block_time += delta
	place_block_time += delta
	fall_time += delta




var talk_list = {
	"player":1,
	"boss":0.9,
	"npc":1.1,
}
func _ready() -> void:
	Overall.audio_node = self
func talk(play:=true,name_:="player") -> void:
#	translation = Overall.player_node.translation+Vector3(0,3,3)
	$talk.pitch_scale = talk_list[name_]
	if play:
		$talk.play(rand_range(0,3))
	else:
		$talk.stop()
		$talk.playing = false
		
func play(name_:String,time:=0.0) -> void:
	get_node(name_).play(time)
func stop(name_:String) -> void:
	get_node(name_).stop()

func play_ui(name_:String,time:=0.0) -> void:
	get_node("ui/"+name_).play(time)
