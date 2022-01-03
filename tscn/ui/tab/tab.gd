extends Node2D
var wifi1 := preload("res://assets/img/ui/tab/wifi1.png")
var wifi2 := preload("res://assets/img/ui/tab/wifi2.png")
var wifi3 := preload("res://assets/img/ui/tab/wifi3.png")
var wifi4 := preload("res://assets/img/ui/tab/wifi4.png")
func _ready() -> void:
	for node in $vbox.get_children():
		node.queue_free()
	hide()

func _unhandled_input(event:InputEvent) -> void:
	if !Net.status:return
	
	if event.is_action_pressed("tab"):
		show()
			
	if event.is_action_released("tab"):
		hide()

var text_tscn := preload("res://tscn/ui/tab/text.tscn")

func show() -> void:
	.show()
	for id in Net.player_info:
		var name_ = Net.player_info[id].name
		var delty = Net.player_info[id].delty
		if !has_node("vbox/"+name_):
			var tscn = text_tscn.instance()
			tscn.name = name_
			tscn.text = name_
			wifi(tscn,delty)
			
			tscn.get_node("delty").text = str(delty)
			$vbox.add_child(tscn)
		else:
			get_node("vbox/"+name_+"/delty").text = str(delty)
			wifi(get_node("vbox/"+name_),delty)
	
func wifi(tscn,delty:float) -> void:
	tscn.get_node("wifi").texture = wifi1
	tscn.get_node("delty").modulate = Color("#a1f17d")
	if delty > 80:
		tscn.get_node("wifi").texture = wifi2
		tscn.get_node("delty").modulate = Color("#f3db81")
	if delty > 180:
		tscn.get_node("wifi").texture = wifi3
		tscn.get_node("delty").modulate = Color("#efb665")
	if delty > 300:
		tscn.get_node("wifi").texture = wifi4
		tscn.get_node("delty").modulate = Color("#f05c5c")

func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	position+= diff_size
	
