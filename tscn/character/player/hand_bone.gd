extends BoneAttachment

func _ready() -> void:
	pass

func change_hand(name_:="") -> void:
	if name_:
		var obj = Item.get(name_)
		if obj.type=="block":
			if obj.model:
				$"../hand".show()
				$item.hide()
				$single.hide()
				$model.show()
				$"../hand_tool".hide()
				$"../arm".show()
				$model.mesh = obj.model
				$model.material_override = load("res://tscn/world/terrain"+str(obj.material)+".tres")
			else:
				$"../hand".show()
				$item.hide()
				$"../hand_tool".hide()
				$"../arm".show()
				$single._show(name_)
				$model.hide()
	
		elif obj.type=="tool":
			$"../hand".hide()
			$"../arm".hide()
			$single.hide()
			$item.hide()
			$model.hide()
			$"../hand_tool/tool".create(obj.img)
			$"../hand_tool".show()
			
		else:
			$"../arm".show()
			$"../hand".show()
			$single.hide()
			$model.hide()
			$"../hand_tool".hide()
			$item.create(obj.img)
			$item.show()
			
	else:
		$"../arm".show()
		$"../hand".show()
		$item.hide()
		$single.hide()
		$model.hide()
		$"../hand_tool".hide()

		
