extends Node
var thread := Thread.new()
var set_data={
	"main":93,
	"sound":93,
	"music":93,
	"language":0,
	"full":false,
	
}
var save_data = {}
var world = {"map":{}}
var save_data_be = {
	"world_name":"",
	"save":false,
	"index":0,
	"time":"",
	"seed_num":1,
	"player":{
		"armor":[],
		"bar":[],
		"bag":[],
		"pos3":[0,0,0],
		"rot":[0,0,0],
		"status":{
			"health":10.0,
			"health_max":10.0,
			"head":3.0,
			"head_max":3.0,
			"body":4.0,
			"body_max":4.0,
			"arm_left":3.0,
			"arm_left_max":3.0,
			"arm_right":3.0,
			"arm_right_max":3.0,
			"leg_left":3.0,
			"leg_left_max":3.0,
			"leg_right":3.0,
			"leg_right_max":3.0,
			"foot_left":3.0,
			"foot_left_max":3.0,
			"foot_right":3.0,
			"foot_right_max":3.0,
			"satiety":10.0,
			"satiety_max":10.0,
			"thirst":10.0,
			"thirst_max":10.0,
			"protein":10.0,
			"protein_max":10.0,
			"phytonutrients":10.0,
			"phytonutrients_max":10.0,
			"ir":0.0,
		},
		"buff":{},
	},
	"players":{
	
	},
	
}
var player_be = {
	"armor":[],
	"bar":[],
	"bag":[],
	"pos3":[0,0,0],
	"rot":[0,0,0],
	"status":{
		"health":10.0,
		"health_max":10.0,
		"head":3.0,
		"head_max":3.0,
		"body":4.0,
		"body_max":4.0,
		"arm_left":3.0,
		"arm_left_max":3.0,
		"arm_right":3.0,
		"arm_right_max":3.0,
		"leg_left":3.0,
		"leg_left_max":3.0,
		"leg_right":3.0,
		"leg_right_max":3.0,
		"foot_left":3.0,
		"foot_left_max":3.0,
		"foot_right":3.0,
		"foot_right_max":3.0,
		"satiety":10.0,
		"satiety_max":10.0,
		"thirst":10.0,
		"thirst_max":10.0,
		"protein":10.0,
		"protein_max":10.0,
		"phytonutrients":10.0,
		"phytonutrients_max":10.0,
		"ir":0.0,
	},
	"buff":{},
}
var world_be = {
	
	"map":{},
	"box":{},
	#{node_name_id:[]}
	"entity":{},
	"other":{},
}

var save_data_list = {}
var folder := "save9"
var world_name = "world"
var world_name_index := 0 
func _ready() -> void:
	
	for i in range(9):
		save_data_be.player.bar.append({"name":"","num":0,"hp":0})
		player_be.bar.append({"name":"","num":0,"hp":0})
	for i in range(24):
		save_data_be.player.bag.append({"name":"","num":0,"hp":0})
		player_be.bag.append({"name":"","num":0,"hp":0})
	for i in range(5):
		save_data_be.player.armor.append({"name":"","num":0,"hp":0})
		player_be.armor.append({"name":"","num":0,"hp":0})
	#set 数据
	var data=Function.get_save("set.save")
	if data:
		check_set_data(data)
		set_data=data
	else:
		Function.set_save("set.save",set_data)
	
	TranslationServer.set_locale(Config.languages[set_data.language])
	Config.languages_index = set_data.language
	Config.set_language(Config.languages_index)
	OS.window_fullscreen = set_data.full
	set_sound()
	
#	if !Function.is_folder("user://save0"):
#		create_new_save()
#	read_save_list()
#	select_read_save(0)
var sync_time := 0.0
func _process(delta:float) -> void:
	if !Net.is_master() && Net.status_:
		sync_time += delta
		if sync_time >= 10.0:
			for id in Net.player_info:
				if Net.id != id:
					rpc_id(id,"sync_data",Net.my_info.name,save_data.player)
			sync_time = 0.0

	
remote func sync_data(player_name:String,data) -> void:
	save_data.players[player_name] = data




signal done
func _thread_function(folder_) -> void:
	Function.remove("user://"+folder_)
func _exit_tree():
	thread.wait_to_finish()
func read_save_list() -> void:
	save_data_list.clear()
	var index = 0 
	var folders = Function.get_dir("user://")
	if folders:
		for name_ in folders.folders:
			if name_== "." || name_ == ".." || name_ == "logs" || name_ == "start":
				pass
			else:
				if Function.is_file("user://"+name_+"/"+"save.save"):
					save_data_list[index]=Function.get_save(name_+"/"+"save.save","kylaCpp",true)
					index += 1
					
	world_name_index = get_new_index()
func select_read_save(index:int) -> void:
	folder = "save"+str(save_data_list[index].index)
	var save = Function.get_save(folder+"/"+"save.save","kylaCpp",true)
	if save:
#		check_save_data(save,folder+"/"+"save.save")
		save_data = save
	else:
		change_save_data_be(save_data_list[index].index)
		Function.set_save(folder+"/"+"save.save",save_data_be,"kylaCpp",true)
	
	#read world
	save = Function.get_save(folder+"/world/world.world","kylaCpp",true)
	if save:
		world = save
		if !"map" in world:world["map"]={}
		if !"box" in world:world["box"]={}
		if !"entity" in world:world["entity"]={}
#		check_save_world_data(save,folder+"/world/world.world")
##		world = save
#		world["map"] = {}
#		for key in save["map"]:
#			var key_ = str2var(key)
#			world["map"][key_] = {}
#			for key1 in save["map"][key]:
#				var key_1 = str2var(key1)
#				world["map"][key_][key_1] = {}
#				for key2 in save["map"][key][key1]:
#					var key_2 = str2var(key2)
#					world["map"][key_][key_1][key_2] = save["map"][key][key1][key2]
#		world["box"] = {}
#
#		for key in save["box"]:
#
#			var key_ = str2var(key)
#			world["box"][key_] = {}
#			for key1 in save["box"][key]:
#				var key_1 = str2var(key1)
#				world["box"][key_][key_1] = {}
#				for key2 in save["box"][key][key1]:
#					var key_2 = str2var(key2)
#					world["box"][key_][key_1][key_2] = save["box"][key][key1][key2]
#
#		world["entity"] = {}
#		for key in save["entity"]:
#			world["entity"][key] = save["entity"][key]
#		world["other"] = save["other"]
#
#		save_data.player.status.health = 10.0
#		save_data.player.status.health_max = 10.0
#		save_data.player.status.head = 3.0
#		save_data.player.status.head_max = 3.0
#		save_data.player.status.body = 4.0
#		save_data.player.status.body_max = 4.0
#		save_data.player.status.arm_left = 3.0
#		save_data.player.status.arm_left_max = 3.0
#		save_data.player.status.arm_right = 3.0
#		save_data.player.status.arm_right_max = 3.0
#		save_data.player.status.leg_left = 3.0
#		save_data.player.status.leg_left_max = 3.0
#		save_data.player.status.leg_right = 3.0
#		save_data.player.status.leg_right_max = 3.0
#		save_data.player.status.foot_left = 3.0
#		save_data.player.status.foot_left_max = 3.0
#		save_data.player.status.foot_right = 3.0
#		save_data.player.status.foot_right_max = 3.0
##		if save_data.player.armor.size()==4:
##			save_data.player.armor.append({"name":"","num":0,"hp":0})
##		for key in save["other"]:
##			world["other"][str2var(key)] = save["other"][key]
	else:
		Function.set_save(folder+"/world/world.world",world_be,"kylaCpp",true)
	Terrain.map = world.map
	Terrain.map_queue = world.map
	
	
	if "seed_num" in save_data:
		Terrain.seed_num = save_data.seed_num
		Terrain.init()
	
	for data in save_data.player.bar:
		if !Item.is_in(data.name):
			data.name = ""
			data.num = 0
			data.hp = 0
#########
func create_new_save() -> void:
	var folder_ = get_new_folder_name()
	Function.make_dir("user://"+folder_)
	Function.make_dir("user://"+folder_+"/world")
	Function.set_save(folder_+"/save.save",save_data_be,"kylaCpp",true)
	Function.set_save(folder_+"/world/world.world",world_be,"kylaCpp",true)
	read_save_list()
	
func delete_save(index:int) -> void:
	yield(get_tree(),"idle_frame")
	var folder_ = "save"+str(save_data_list[index].index)
	thread.start(self, "_thread_function",folder_)
	thread.wait_to_finish()
	emit_signal("done")
func get_new_index(index:=0) -> int:
	var folder_ = "save"+str(index)
	if !Function.is_folder("user://"+folder_):
		return index
	else:
		index += 1
		return get_new_index(index)
func get_new_folder_name(index:=0) -> String:
	var folder_ = "save"+str(index)
	if !Function.is_folder("user://"+folder_):
		change_save_data_be(index)
		return folder_
	else:
		index += 1
		return get_new_folder_name(index)
func change_save_data_be(index:int):
#	save_data_be.world_name=world_name+str(world_index)
	save_data_be.index = index
	var date := OS.get_datetime()
	var time := OS.get_time()
	save_data_be.time = str(date.year)+"/"+str(date.month)+"/"+str(date.day)+"-"+str(time.hour)+":"+str(time.minute)+":"+str(time.second)
#########

#设置声音
func set_sound() -> void:
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), 6.0)
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sound"), 6.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0.78*set_data.main-78+6)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), 0.78*set_data.music-78+6)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sound"), 0.78*set_data.sound-78+6)

##保存
func save_set() -> void:
	Function.set_save("set.save",set_data)
func save_save() -> void:
	if !Net.is_master():return
	Function.set_save(folder+"/save.save",save_data,"kylaCpp",true)
	save_world()
func save_world() -> void:
	Overall.entity_node_node.save_data()
	Function.set_save(folder+"/world/world.world",world,"kylaCpp",true)
#	Function.set_save("save0/world/world1.world",world)
#检查set 数据
func check_set_data(data):
	var save = false
	for key in set_data:
		if !key in data:
			data[key]=set_data[key]
			save = true
	if save:
		Function.set_save("set.save",data)
#检查save 数据
func check_save_data(data,path_name):
	var save = false
	var d = save_data_be.duplicate(true)
	for key in d:
		if !key in data:
			data[key]=d[key]
			save = true
		if typeof(d[key]) == TYPE_DICTIONARY:
			for key1 in d[key]:
				if !key1 in data[key]:
					data[key][key1]=d[key][key1]
					save = true
#	if !"xxx" in data.player.status:
#		save = true
#		data.player["status"]["xxx"] = 10.0
	if save:
		Function.set_save(path_name,data,"kylaCpp",true)
func check_save_world_data(data,path_name):
	var save = false
	for key in world_be:
		if !key in data:
			data[key] = world_be[key]
			save = true
	if save:
		Function.set_save(path_name,data,"kylaCpp",true)

func new_player(name_:String) -> void:
	if !name_ in save_data.players:
		var p = player_be.duplicate(true)
		save_data.players[name_] = {}
		var save = false
		for key in p:
			if !key in save_data.players[name_]:
				save_data.players[name_][key]=p[key]
				save = true
			if typeof(p[key]) == TYPE_DICTIONARY:
				for key1 in p[key]:
					if !key1 in save_data.players[name_][key]:
						save_data.players[name_][key][key1]=p[key][key1]
						save = true
#		if save:
#			save_save()

func check_data(data:Dictionary) -> void:
	return
	data.save = bool(data.save)
	data.index = int(data.index)
	data.seed_num = int(data.seed_num)
	for kk in range(1):
		data.player.pos3 = str2var(data.player.pos3)
		
#		data.player.armor = str2var(data.player.armor)
#		data.player.bar = str2var(data.player.bar)
#		data.player.bag = str2var(data.player.bag)
#		data.player.pos3 = str2var(data.player.pos3)
#		data.player.rot = str2var(data.player.rot)
#		data.player.status = str2var(data.player.status)
#		data.player.buff = str2var(data.player.buff)
	
	for kk in data.players:
		var p = data.players[kk]
#		for d in p.armor:
#			d.hp = float(d.hp)
#		for d in p.bar:
#			d.hp = float(d.hp)
#		for d in p.bag:
#			d.hp = float(d.hp)
#		var d = p.pos3
#		d[0] = float(d[0])
#		d[1] = float(d[1])
#		d[2] = float(d[2])
#		d = p.rot
#		d[0] = float(d[0])
#		d[1] = float(d[1])
#		d[2] = float(d[2])
#		for key in p.status:
#			p.status[key] = float(p.status[key])
#		for key in p.buff:
#			p.buff[key] = int(p.buff[key])

func check_world(data:Dictionary) -> void:
	for key1 in data.map:
		for key2 in data.map[key1]:
			for key3 in data.map[key1][key2]:
				data.map[key1][key2][key3] = int(data.map[key1][key2][key3])
	
func check_player(data:Dictionary) -> void:
	var p = data
	
	for d in p.armor:
		d.hp = float(d.hp)
	for d in p.bar:
		d.hp = float(d.hp)
	for d in p.bag:
		d.hp = float(d.hp)
	var d = p.pos3
	d[0] = float(d[0])
	d[1] = float(d[1])
	d[2] = float(d[2])
	d = p.rot
	d[0] = float(d[0])
	d[1] = float(d[1])
	d[2] = float(d[2])
	for key in p.status:
		p.status[key] = float(p.status[key])
	for key in p.buff:
		p.buff[key] = int(p.buff[key])
