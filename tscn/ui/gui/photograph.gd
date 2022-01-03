extends ViewportContainer
var textures = {
	
	
}
var done := false
# 1.5 2.5 1.5
# -50 45

#2,2.3,2
#-40,45,0
func _ready() -> void:
	$Viewport/camera.translation = Vector3(1.5,2.5,1.5)
	$Viewport/camera.rotation_degrees = Vector3(-50,45,0)
	Overall.photograph_node = self
	init_texture()
func set_texture(name_:String,obj) -> void:
	if name_ in textures:
		obj.texture = textures[name_]
		return
	else:
		if Block.is_in(name_):
			while 1:
				yield(get_tree().create_timer(1),"timeout")
				if done:
					if Function.is_obj(obj):
						obj.texture = textures[name_]
					return
func get_texture(name_:String):
	if name_ in textures:
		return textures[name_]
	return false
func init_texture() -> void:
	
	for key in Block.list:
		if key != 0:
			var name_ = Block.list[key]
			var block = Block.get(name_)
			if !block.model:
#				yield(VisualServer, "frame_post_draw")
				$Viewport/item/single._show(name_)
#				$Viewport/item/single.set_voxel_from_name(Vector3(0,0,0),name_)
#				$Viewport/item/single.update()
				$Viewport.update_worlds()
				$Viewport/item/model.hide()
				$Viewport/item/single.show()

			else:
#				yield(VisualServer, "frame_post_draw")
				$Viewport/item/model.mesh = block.model
				$Viewport/item/model.material_override = load("res://tscn/world/terrain"+str(block.material)+".tres")
				$Viewport/item/model.show()
				$Viewport/item/single.hide()
			yield(VisualServer, "frame_post_draw")

			var img = $Viewport.get_viewport().get_texture().get_data()
			img.lock()
			var tex = ImageTexture.new()
			tex.create_from_image(img,0)
			img.unlock()
			tex.set_size_override(Vector2(16,16))
			textures[name_] = tex
			block["img"] = tex

	hide()
	done = true
