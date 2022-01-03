extends AnimatedSprite

func _ready() -> void:
	pass

func update_state(pro:float) -> void:
	if pro<10:
		hide()
	else:
		show()
		if pro<20:
			frame = 0
		else:
			if pro<40:
				frame = 1
			else:
				if pro<60:
					frame = 2
				else:
					if pro<80:
						frame = 3
					else:
						if pro<95:
							frame = 4
