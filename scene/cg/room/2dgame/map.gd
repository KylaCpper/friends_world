extends TileMap

var select_pos2 = Vector2()
func _ready() -> void:
	pass
var damage_pos2 = Vector2()
var damage_time = 0
var list_index = {
	"0":"grass",
	"2":"grass_dirt",
	"1":"dirt",
	"3":"leaves",
	"5":"wood",
	"4":"stone",
}
var intensity = {
	"0":1.5,
	"2":1.5,
	"1":1.5,
	"3":3,
	"5":1,
	"4":0.8,
}
var num = 0
var num_max = 6
var drop_tscn = preload("res://scene/cg/room/2dgame/drop.tscn")
func _input(event) -> void:
	if event is InputEventMouseMotion:
		var size = $"/root".get_viewport().size
		var pos2 = event.position

		pos2.x /= size.x/600
		pos2.y /= size.y/400

		if pos2.distance_to($"../player".position) > 80.0:
			pos2 /= 16
			pos2.x = ceil(pos2.x) -1
			pos2.y = ceil(pos2.y) -1
			var pos2_ = pos2 * 16
			pos2_ += Vector2(8,8)
			if get_cellv(pos2) != -1:
				$"../select".show()
				$"../select".modulate = Color(255,0,0)
				$"../select".position = pos2_
			else:
				$"../select".hide()
			select_pos2 = Vector2(-32,-32)
			return
		pos2 /= 16
		pos2.x = ceil(pos2.x) -1
		pos2.y = ceil(pos2.y) -1
		var pos2_ = pos2 * 16
		pos2_ += Vector2(8,8)
		$"../select".show()
		$"../select".modulate = Color(255,255,255)
		$"../select".position = pos2_
		select_pos2 = pos2

func get_block(pos2:Vector2) -> String:
	pos2 /= 16
	pos2.x = ceil(pos2.x) -1
	pos2.y = ceil(pos2.y) -1
	if get_cellv(pos2) != -1:
		return list_index[str(get_cellv(pos2))]
	else:
		return ""
var time := 0.0
var time_max := 0.2
func _process(delta) -> void:
	if !$"../".start:return
	if Input.is_action_pressed("mouse_left"):
		if get_cellv(select_pos2) != -1:
			if damage_pos2 == select_pos2:
				time+=delta
				if time > time_max:
					time = 0.0
					$"../audio".play(list_index[str(get_cellv(select_pos2))])
				damage_time+=2*intensity[str(get_cellv(select_pos2))]
				$"../crack".show()
				$"../crack".position = select_pos2*16 + Vector2(8,8)
				$"../crack".update_state(damage_time)
			else:
				damage_time = 0
				damage_pos2 = select_pos2
				$"../crack".show()
				$"../crack".position = select_pos2*16 + Vector2(8,8)
				$"../crack".update_state(damage_time)
			if damage_time > 100:
				damage_time = 0
				var id = get_cellv(select_pos2)
				set_cellv(select_pos2,-1)
				var tscn = drop_tscn.instance()
				tscn.name_ = list_index[str(id)]
				$"../".add_child(tscn)
				tscn.position = select_pos2*16 + Vector2(8,8)
				$"../crack".hide()
				num+=1
				if num >num_max:
					$"../".end()
				if get_cellv(select_pos2) != -1:
					$"../audio".play(list_index[str(get_cellv(select_pos2))])
		else:
			$"../crack".hide()
func place(id:int) -> bool:
	if get_cellv(select_pos2) == -1:
		set_cellv(select_pos2,id)
		return true
	else:
		return false
