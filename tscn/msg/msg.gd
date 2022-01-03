extends Spatial
var free_time_max = 2
func _ready() -> void:
	set_process(false)
	hide()
	var viewport = $Viewport
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	var material = $msg1.material_override.duplicate()
	material.albedo_texture = viewport.get_texture()
	$msg1.material_override = material
	$msg2.material_override = material
	
	
	
	
func talk(text:String) -> void:
	$Viewport/Label.text = ""
	visible = true
	self.text = tr(text)
	i = 0
	free = false
	free_time = 0
	set_process(true)
	
	
	
func _show(text:String,cover:=true) -> void:
	if !cover:
		if visible:
			return
	$Viewport/Label.text = ""
	visible = true
	self.text = tr(text)
	i = 0
	free = false
	free_time = 0
	set_process(true)
	
func show(text:="",cover:=true) -> void:
	if !cover:
		if visible:
			return
	$Viewport/Label.text = ""
	.show()
	self.text = text
	i = 0
	free = false
	free_time = 0
	set_process(true)
	
var time = 0
var text = ""
var i = 0
var free = false
var free_time = 0
func _process(delta) ->void:
	if !free:
		time += delta
		if time >= 0.1:
			time = 0
			$Viewport/Label.text += text[i]
			i += 1
			if i >= text.length():
				free = true
	else:
		free_time += delta
		if free_time > free_time_max:
			free_time= 0 
			free = false
			set_process(false)
			hide()
