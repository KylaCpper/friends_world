extends TextureRect

var item = {"name":"","num":0,"hp":0}
var is_item := false
func _ready() -> void:
	Overall.pick_item_node = self
	hide()
func sub(num:int) -> void:
	item.num -= num
	$num.text = str(item.num)
	update()
func add(num:int,name_:String) -> int:
	var item_ = Item.get(name_)
	if item_:
		if !item.num + num > item_["max"]:
			item.num+=num
			num = 0
		else:
			num -= item_["max"] - item.num
			item.num = item_["max"]
		$num.text = str(item.num)
		update()
		return num
	return 0
func set_item(data=null) -> void:

	if !data:
		data = {"name":"","num":0,"hp":0}
	if data.num > 0:
		is_item=true
	else:
		is_item=false
	item = data
	if data.name:
		show()
		if Item.get(data.name).type == "block":
			Overall.photograph_node.set_texture(data.name,self)
		else:
			texture = Item.get(data.name).img
		$num.text = str(item.num)
		if data.hp > 0:
			$hp.max_value = Item.get_hp(data.name)
			$hp.value = data.hp
			$hp.show()
		else:
			$hp.hide()

	else:
		$hp.hide()
		hide()
func update() -> void:
	if item.num <= 0:
		item.name = ""
		item.num = 0
		item.hp = 0
	if item.name:
		show()
		if Item.get(item.name).type == "block":
			Overall.photograph_node.set_texture(item.name,self)
		else:
			texture = Item.get(item.name).img
		$num.text = str(item.num)
		if item.hp > 0:
			$hp.max_value = Item.get_hp(item.name)
			$hp.value = item.hp
			$hp.show()
		else:
			$hp.hide()

	else:
		$hp.hide()
		hide()
