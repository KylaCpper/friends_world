extends Node


var items = {}





func _ready() -> void:
	if Config.test:return
#	for path in Config.TOOL_SCRIPT_LIST:
#		var json = JSON.parse(Function.read_file("res://config/"+path+"/tool.json")).result
#		for key in json:
#			for data in json[key]:
#				items[data.key] = data
	items = Config.data.tool
	for key in items:
		items[key]["class"] = "tool"
		items[key]["type"] = "tool"
		
		
		Item.list[items[key].name] = key
		items[key].img = load("res:/"+items[key].img)
		var texture = items[key].img
		var itex = ImageTexture.new()
		itex.create_from_image(texture.get_data(),Texture.FLAG_CONVERT_TO_LINEAR)

		if "tool" in items[key]:
			if typeof(items[key]["tool"]) == TYPE_ARRAY:
				var _tool = []
				var _speed = []
				for d in items[key]["tool"]:
					_tool.append(d[0])
					_speed.append(d[1])
				items[key]["tool"] = _tool
				items[key]["speed"] = _speed
			else:
				items[key]["tool"] = [items[key]["tool"]]
				items[key]["speed"] = [items[key]["speed"]]
		else:
			items[key]["tool"] = ["",0.0]
		if items[key].script:
			Function.give_script(items[key])
		else:
			items[key]["script"] = "/script/base/tool/base_tool.gd"
			Function.give_script(items[key])

func is_in(name_:String) -> bool:
	if name_ in items:
		return true
	else:
		return false
func get(name_:String):
	return items[name_]

func get_tool(block_name:String,tool_name:String) -> String:
	if !Block.is_in(block_name):return "hand"
	if !Tool.is_in(tool_name):return "hand"
	var tool_list_block = Block.get(block_name)["tool"]
	var tool_item = Tool.get(tool_name)
	
	if typeof(tool_item["tool"]) == TYPE_ARRAY:
		#锤子 镐子优先
		for tool_type in tool_item["tool"]:
			if tool_type == "hammer":
				if "hammer" in tool_list_block:
					return "hammer"
				elif "pickaxe" in tool_list_block:
					return "pickaxe"
			
		for tool_type in tool_item["tool"]:
			if tool_type in tool_list_block:
				return tool_type
	else:
		if tool_item["tool"] in tool_list_block:
			return tool_item["tool"]


	return "hand"
func get_atk(tool_name:String) -> float:
	if !Tool.is_in(tool_name):return 1.0
	var tool_item = Tool.get(tool_name)
	if !"atk" in tool_item:tool_item.atk=1.0
	return tool_item.atk
