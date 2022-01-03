extends ViewportContainer

var sec := 0

func _ready() -> void:
	Overall.name_node = self
	hide()

func set_tex(text:String,obj:Sprite3D) -> void:
	show()
	sec += 1
	var sec_ = sec
	for i in range(sec_):
		yield(get_tree().create_timer(0.5),"timeout")
	
	$viewport/name/text.text = text
	$viewport.update_worlds()
	yield(VisualServer, "frame_post_draw")
	
	var img = $viewport.get_viewport().get_texture().get_data()
	var tex = ImageTexture.new()
	tex.create_from_image(img,4)
	sec -= 1
	if sec == 0:
		hide()
	obj.texture = tex
	
#	tex.set_size_override(Vector2(16,16))
