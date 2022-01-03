extends Node
#合成表的类型标题顺序
var data = {
	
}

#合成表
#合成表 时代分类 总
var table_bigs = {}
#小合成表 不分类 总
var table_smalls = {}
#默认 
var default = {}
#工作台 
var craft_table = {}
#熔炉
var furnace = {

}
#锻造
var anvil = {}



##

func _ready() -> void:
	for age in data:
		for type in data[age]:
			for key in data[age][type]:
				table_smalls[key] = data[age][type][key]
#func _init() -> void:
#
#	var be = Function.read_file("res://config/composite/composite_small.json")
#	var json = JSON.parse(be).result
#	for key in data:
#		if !key in table_bigs:
#			table_bigs[key] = []
#			default[key] = {}
#			craft_table[key] = {}
##			furnace[key] = {}
#
#		for d in json[key]:
#			table_bigs[key].append(d.key)
#			table_smalls[d.key] = d.table
			
			
#	be = Function.read_file("res://config/composite/composite_big.json")
#	json = JSON.parse(be).result
#	for key in json:
#		json[key] = json[key][0]
#		for age in json[key]:
#			for item in json[key][age]:
#				if !item in self[key][age]:
#					self[key][age][item]=true
					
#	be = Function.read_file("res://config/composite/furnace.json")
#	json = JSON.parse(be).result
	
#	for key in json:
#		if !key in furnace:
#			furnace[key] = {}
#		for data in json[key]:
#			var name_ = data.key
#			var time = data.time
#			if !time:time = 1.0
#			furnace[key][name_] = {"table":data.table,"export":data.export,"time":time}

func get_table_big(type:String,age:String):
	return data[age][type]
#	var table_bigs = self[type]
#	var table_big = []
#	if "sub" in self[type][age]:
#		for data in self.table_bigs[age]:
#			if !data in table_bigs[age]:
#				table_big.append(data)
#	else:
#		for data in self.table_bigs[age]:
#			if data in table_bigs[age]:
#				table_big.append(data)
#	return table_big
func get_table_furnace(type:String):
	if type in furnace:
		return furnace[type]
	else:
		return {}
func get_table_small(name_:String):
	return table_smalls[name_]
#	var table_smalls_be = table_smalls[name_]
#	var table_small = []
#	for data in table_smalls_be:
#		if "age" in data:
#			if Config.ages_num[data.age] <= Overall.age_num:
#				table_small.append(data)
#		else:
#			table_small.append(data)
#
#	return table_small

