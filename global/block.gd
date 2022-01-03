extends Node
var grid_list = {
	-1:"default",
	0:"default",1:"grass",2:"dirt",3:"stone",4:"wood",
	5:"wood_board",6:"grass_dirt",
}
var list = {}
var count = 3
var block_dire_list = {}#name : dire id
enum {TOOL_NO,TOOL_LOW,TOOL_OK} 

# dire = 0 无方向
# dire = 1 只能旋转方向  无上下方向
# dire = 2 可以全部旋转方向
# drop = {"name":"stone","num":1,"tool":"pick","pro":100,"lv":1}

var items = {}
var jump := 0
func _ready() -> void:
#	if Config.test:return
#	for path in Config.BLOCK_SCRIPT_LIST:
#		var json = JSON.parse(Function.read_file("res://config/"+path+"/block.json")).result
#		for key in json:
#			for data in json[key]:
#				items[data.key] = data

	var id = 0
	list[0] = "air"
#	var be = Function.read_file(Config.block_json)
	items = Config.data.block
	var order = Config.data.order 
	

	for name__ in order:
		if jump:
			jump-=1
			
			continue
		id+=1
		list[id] = name__
		var name_ = list[id]
		
		items[name_]["class"] = "block"
		items[name_]["type"] = "block"

		if !"id" in items[name_]:
			items[name_]["id"] = id

		if items[name_].aabb:
			items[name_].aabb = AABB(Vector3(items[name_].aabb[0],items[name_].aabb[1],items[name_].aabb[2]),Vector3(items[name_].aabb[3],items[name_].aabb[4],items[name_].aabb[5]))
		
		
		
		if items[name_].model:
			items[name_].model = load("res:/"+items[name_].model)
		items[name_]["tool"] = {}
		for type in items[name_].drop:
			if type != "hand" && type != "fall":
				if items[name_].drop[type].size() > 0:
					items[name_]["tool"][type]=items[name_].drop[type][0].lv
#		if items[name_].liquid:
#			if items[name_].liquid == "true":
#				items[name_].liquid = true
#			else:
#				items[name_].liquid = false
#		else:
#			items[name_].liquid = false
				
#		if items[name_].liquid:
#			if !items[name_].branch:
#				items[name_].branch=["","",name_,name_]

#		if !items[name_].name:
#			items[name_].name = name_


		#smash 0 默认计算，1 砸向非实体方块不会碎，2砸向任何必碎
		#被砸实体统一默认,透明统一碎
#		if !items[name_].smash:
#			items[name_].smash = 0
#			if !items[name_]["entity"]:
#				items[name_].smash = 2
#
#		if !items[name_].intensity:
#			if !items[name_]["entity"]:
#				items[name_].intensity = 0.5
#			else:
#				items[name_].intensity = 1.0
#		items[name_].intensity = float(items[name_].intensity)
		
#		if !items[name_].intensity_dig:
#			items[name_].intensity_dig = items[name_]["intensity"]
#		items[name_].intensity_dig = float(items[name_].intensity_dig)
#		items[name_].intensity_dig = float(items[name_].intensity_dig)
		
#		if !items[name_]["max"]:
#			Overall.give_num(items[name_])
#		items[name_]["max"] = int(items[name_]["max"])
		
#		if !items[name_]["tool"]:
#			if items[name_].drop:
#				items[name_]["tool"] = {}
#				if items[name_].drop.size()==0:
#					items[name_]["drop"] = {"hand":[]}
#					items[name_]["tool"] = {"hand":0}
#				else:
#					for key in items[name_].drop:
#						var lv = 9999
#						for data in items[name_].drop[key]:
#							if !"num" in data:data["num"] = 1
#							if !"stop" in data:data["stop"] = false
#							if !"lv" in data:data["lv"] = 0
#							if lv > data.lv:lv = data.lv
#						items[name_]["tool"][key] = lv
#			else:
#				items[name_]["drop"] = {"hand":[{"name":name_,"num":1,"lv":0,"stop":false}]}
#				items[name_]["tool"] = {"hand":0}
#		else:
#			if items[name_].drop:
#				for key in items[name_].drop:
#					var lv = 9999
#					for data in items[name_].drop[key]:
#						if !"num" in data:data["num"] = 1
#						if !"stop" in data:data["stop"] = false
#						if !"lv" in data:data["lv"] = 0
#						if lv > data.lv:lv = data.lv
#					items[name_]["tool"][key] = lv
#			else:
#				items[name_]["drop"] = {}
#				for key in items[name_]["tool"]:
#					items[name_]["drop"][key] = [{"name":name_,"num":1,"lv":items[name_]["tool"][key],"stop":false}]

		if items[name_].script:
			Function.give_script(items[name_])
		else:
			if items[name_].liquid:
				items[name_]["script"] = "/script/base/block/liquid.gd"
			else:
				items[name_]["script"] = "/script/base/block/base_block.gd"
			Function.give_script(items[name_])
# 在末尾增加可以改变方向方块id
		if items[name_].dire == 1:
			list[id+1] = name_
			list[id+2] = name_
			list[id+3] = name_
			if "customize_dire" in items[name_]:
				jump += 3
			id += 3
		if items[name_].dire == 2:
			list[id+1] = name_
			list[id+2] = name_
			list[id+3] = name_
			list[id+4] = name_
			list[id+5] = name_
			if "customize_dire" in items[name_]:
				jump += 5
			id += 5
		if items[name_].dire == 4:
			list[id+1] = name_
			if "customize_dire" in items[name_]:
				jump += 1
			id += 1
			
func check_dire(name_:String,dire:int) -> int:
	if items[name_].dire == 0:
		return 0
	if items[name_].dire == 1:
		if dire == 4 || dire == 5:
			return 0
		else:
			return dire
	if items[name_].dire == 2:
		return dire
	if items[name_].dire == 4:
		if dire == 4 || dire == 5:
			return 0
		else:
			if dire == 2:
				return 0
			if dire == 3:
				return 1
			return dire
		
	return 0

func get_name_from_id(id:int) -> String:
	if id in list:
		return list[id]
	return "default"
func get_id_from_name(name_:String) -> int:
	if name_ in items:
		return items[name_].id
	else:
		return 0
func get_dire(id:int,block=null) -> int:
	if !block:
		return id - Block.get(list[id]).id
	else:
		return id - block.id
func get_name_from_id_grid(id:int) -> String:
	return grid_list[id]
func get_global_id(name_:String,dire:int) -> int:
	var id = items[name_].id
	return id+dire

func is_in(name_:String) -> bool:
	if name_ == "air":return false
	if name_ in items:
		return true
	else:
		return false
func get(name_:String) -> Dictionary:
	if name_ in items:
		return items[name_]
	else:
		return {}
func id(name_:String) -> int:
	if name_ in items:
		return items[name_].id
	else:
		return 0
func is_generate_power_machine(name_:String) -> bool:
	if name_ == "water_wheel":
		return true
	return false
func is_use_power_machine(name_:String) -> bool:
	if name_ == "wood_blower":
		return true
	return false
func is_gear(name_:String) -> bool:
	if name_ == "wood_shaft":return true
	if name_ == "wood_gear_shaft":return true
	return false
func is_damage(block_name:String,tool_name:String) -> bool:
	if !Block.is_in(block_name):return true

	var tool_list = Block.get(block_name)["tool"]
	
	if Tool.is_in(tool_name):
		var tool_item = Tool.get(tool_name)
		if typeof(tool_item["tool"]) == TYPE_ARRAY:
			for tool_type in tool_item["tool"]:
				if tool_type in tool_list:
					if tool_item.lv>= tool_list[tool_type]:
						return true
		else:
			if tool_item["tool"] in tool_list:
				if tool_item.lv>= tool_list[tool_item["tool"]]:
					return true
				
	return "hand" in tool_list

func is_use_tool(block_name:String,tool_name:String) -> int:
	if !Tool.is_in(tool_name):return 0
	if !Block.is_in(block_name):return 0
	
	var tool_list_block = Block.get(block_name)["tool"]
	var tool_item = Tool.get(tool_name)
	#锤子 优先
	for tool_type in tool_item["tool"]:
		if tool_type == "hammer":
			if "hammer" in tool_list_block:
				if tool_item.lv>= tool_list_block.hammer:
					return TOOL_OK
				else:
					return TOOL_LOW
			elif "pickaxe" in tool_list_block:
				if tool_item.lv>= tool_list_block.pickaxe:
					return TOOL_OK
				else:
					return TOOL_LOW
					
					
	if typeof(tool_item["tool"]) == TYPE_ARRAY:
		for tool_type in tool_item["tool"]:
			if tool_type in tool_list_block:
				if tool_item.lv>= tool_list_block[tool_type]:
					return TOOL_OK
				else:
					return TOOL_LOW
	else:
		if tool_item["tool"] in tool_list_block:
			if tool_item.lv>= tool_list_block[tool_item["tool"]]:
				return TOOL_OK
			else:
				return TOOL_LOW

	return TOOL_NO
	

func get_speed(block_name:String,tool_name:String) -> float:
	if !Block.is_in(block_name):return 1.0

	var tool_list = Block.get(block_name)["tool"]

	if Tool.is_in(tool_name):
		var tool_item = Tool.get(tool_name)
#		if typeof(tool_item["tool"]) == TYPE_ARRAY:
#			var i = 0
#			for tool_type in tool_item["tool"]:
#				if tool_type in tool_list:
#					if tool_item.lv>= tool_list[tool_type]:
#						return tool_item.speed[i]
#					else:
#						return 1.0+(tool_item.speed[i]-1)/2
#				i+=1
#		else:
		var i := 0
		var index := -1
		#锤子 镐子优先
		for d in tool_item["tool"]:
			if d == "hammer":
				if "hammer" in tool_list:
					if tool_item.lv>= tool_list["hammer"]:
						return tool_item.speed[index]
					else:
						return 1+(tool_item.speed[index]-1)/2
				elif "pickaxe" in tool_list:
					if tool_item.lv>= tool_list["pickaxe"]:
						return tool_item.speed[index]
					else:
						return 1+(tool_item.speed[index]-1)/2
			i += 1

		i = 0
		for d in tool_item["tool"]:
			if d != "hammer":
				if d in tool_list:
					if tool_item.lv>= tool_list[d]:
						return tool_item.speed[i]
					else:
						return 1+(tool_item.speed[i]-1)/2
			i+=1
	return 1.0
		



func get_wear(name_:String) -> float:
	if !Block.is_in(name_):return 1.0
	if "wear" in items[name_]:
		return items[name_].wear*1.0
	else:
		return items[name_].intensity*1.0

func get_entity(name_:String) -> bool:
	return items[name_].entity

