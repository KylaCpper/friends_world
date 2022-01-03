extends Panel
var name_ = ""

func _ready() -> void:
	Overall.msg_grid_item_node = self
	hide()
func set_item(grid_item="") -> void:
	if grid_item:
		var name_ = grid_item.name
		if self.name_ == name_:
			return
		self.name_ = name_
		if !name_:
			hide()
			return
		show()
		$hp.hide()
		$hp_bg.hide()
		var item = Item.get(name_)
		if !item:
			hide()
			return
		if item.type == "block":
			$text.text = item.name
			$info.text = item.info
		else:
			$text.text = item.name
			$info.text = item.info
			if "hp" in item:
				if item.hp > 0:
					$hp.show()
					$hp_bg.show()
					$hp.text = str(grid_item.hp)+"  /  "+str(item.hp)
	else:
		self.name_ = ""
		hide()
	
