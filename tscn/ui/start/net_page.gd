extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	$connect.connect("pressed",self,"_on_connect")
	$cancel.connect("pressed",self,"_on_cancel")
	$ip_line.text = "127.0.0.1"
	$port_line.text = "45536"

func _unhandled_input(event) -> void:
	if event.is_action_pressed("esc"):
		if $loading.visible:return
		if visible:
			hide()
			get_tree().set_input_as_handled()
			
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$blur._on_screen(window_size,diff_size)
	$blur.rect_position -= diff_size
	position += diff_size
	$loading._on_screen(window_size,diff_size)

func _on_connect() -> void:
	Overall.audio_node.play_ui("click")
	if !Net.status && !Net.connecting:
		var ip = $ip_line.text
		var port = $port_line.text
		var name_ = $name_line.text
		port = int(port)
		if ip && port&&name_:
			Net.my_info.name = name_
			$loading.show()
			Net.connect_server(ip,port)
func _on_cancel() -> void:
	Overall.audio_node.play_ui("click")
	hide()
func show() -> void:
	.show()
	$blur.set_val(1.0)
