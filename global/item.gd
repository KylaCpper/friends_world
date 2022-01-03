extends Node


var items = {}
var list = {}
func _ready() -> void:
	if Config.test:return
#	for path in Config.ITEM_SCRIPT_LIST:
#		var json = JSON.parse(Function.read_file("res://config/"+path+"/item.json")).result
#		for key in json:
#			for data in json[key]:
#				items[data.key] = data

	items = Config.data.item
	for key in items:
		items[key]["class"] = "item"
		items[key]["type"] = "item"
		items[key].crop = false
		if items[key].plant:
			if items[key].plant.size()==2:
				items[key].crop = true
		
		list[items[key].name] = key
		items[key].img = load("res:/"+items[key].img)
		var texture = items[key].img
		var itex = ImageTexture.new()
		itex.create_from_image(texture.get_data(),Texture.FLAG_CONVERT_TO_LINEAR)
#		if !items[key].mass:
#			items[key]["mass"] = 0.1

#		if !items[key]["max"]:
#			Overall.give_num(items[key])

		if items[key].script:
			Function.give_script(items[key])
		else:
			items[key]["script"] = "/script/base/item/base_item.gd"
			Function.give_script(items[key])
func get(name_:String):
	if !name_:return null
	if Block.is_in(name_):
		return Block.get(name_)
	if Tool.is_in(name_):
		return Tool.get(name_)
	if name_ in items:
		return items[name_]
	else:
		return null


func is_in(name_:String) -> bool:
	if Block.is_in(name_):
		return true
	if Tool.is_in(name_):
		return true
	if name_ in items:
		return true
	return false
		
func get_hp(name_:String) -> float:
	var obj = self.get(name_)
	if "hp" in obj:
			return obj.hp*1.0
	else:
		return 0.0

func get_max(key:String) -> int:
	var item = self.get(key)
	return item["max"]
func get_key(name_:="") -> String:
	if name_ in list:
		return list[name_]
	return ""
