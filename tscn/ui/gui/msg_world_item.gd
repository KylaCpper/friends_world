extends Panel
var name_ := ""
func _ready() -> void:
	Overall.msg_world_item_node = self
	hide()

func update(name__ := "") -> void:
	if name__ == "air":return
	if (name_ == name__) && (visible == true) :return
	name_ = name__
	if name_:
		var item = Item.get(name_)
		if item:
			$name.show()
			$name_c.hide()
			if item.type == "block":
				$ViewportContainer/Viewport/ani.stop()
				if name_:
					show()
					$name.text = item.name
					if !item.model:
						$ViewportContainer/Viewport/item/single.show()
						$ViewportContainer/Viewport/item/model.hide()
						$ViewportContainer/Viewport/item/sprite3d.hide()
						$ViewportContainer/Viewport/item/single._show(name_)
						
					else:
						$ViewportContainer/Viewport/item/single.hide()
						$ViewportContainer/Viewport/item/model.show()
						$ViewportContainer/Viewport/item/sprite3d.hide()
						$ViewportContainer/Viewport/item/model.mesh = item.model
						$ViewportContainer/Viewport/item/model.material_override = load("res://tscn/world/terrain"+str(item.material)+".tres")
						
					$ViewportContainer/Viewport/ani.play("start")
				else:
					hide()
					$ViewportContainer/Viewport/ani.stop()
			else:
				show()
				$name.text = item.name
				$ViewportContainer/Viewport/ani.play("start")
				$ViewportContainer/Viewport/item/single.hide()
				$ViewportContainer/Viewport/item/model.hide()
				$ViewportContainer/Viewport/item/sprite3d.show()
				$ViewportContainer/Viewport/item/sprite3d.create(item.img)
		else:
			if name_:
				show()
				$name_c.show()
				$name_c.text = name_
				$name.hide()
				$ViewportContainer/Viewport/item/single.hide()
				$ViewportContainer/Viewport/item/model.hide()
				$ViewportContainer/Viewport/item/sprite3d.hide()
	else:
		hide()
		$ViewportContainer/Viewport/ani.stop()

func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	rect_position.x = window_size.x/2 -rect_size.x/2
