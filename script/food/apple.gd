extends Base_Item
func _ready() -> void:
	pass

func _eated() -> bool:
	Overall.bar_node.add_item({"name":"apple_seed","num":1,"hp":0})
	return false
