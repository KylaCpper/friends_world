extends Node
func _ready() -> void:
	randomize()
	if(Engine.has_singleton("vibration")):
		vibration = Engine.get_singleton("Vibration")

func give_script(item):
	var script_name = item["script"]
	if script_name in Config.__script__:
		if Config.__script__[script_name]:
			item["script"] = Config.__script__[script_name]
			return
	
	item["script"] = load("res:/"+script_name).new()
	Config.__script__[item.key] = item["script"]
func is_str(data) -> bool:
	return typeof(data) == TYPE_STRING
func arr_vec(arr:Array) -> Vector3:
	return Vector3(arr[0],arr[1],arr[2])
func vec_arr(vec:Vector3) -> Array:
	return [int(vec.x),int(vec.y),int(vec.z)]
#	item["script"] = load("res://script/"+script_name+".gd").new()
#	Config.__script__[script_name] = item["script"]
# 1,0,0 1 left
# 0,0,-1 2 forward
# -1,0,0 3 right
# 0,0,1 4 back
# 0,1,0 5 up 
# 0,-1,0 6 down
func get_dire_from_dire_offset(dire_offset:Vector3) -> int:
	var x = int(dire_offset.x)
	var y = int(dire_offset.y)
	var z = int(dire_offset.z)
	var dire = 1
	if x != 0:
		if x == 1:
			dire = 1
		else:
			dire = 3
	if y != 0:
		if y == 1:
			dire = 5
		else:
			dire = 6
	if z != 0:
		if z == 1:
			dire = 4
		else:
			dire = 2
	return dire

#func clone(obj) ->void:
#	obj.set_material(obj.get_material().duplicate())
#func shader(obj) ->void:
#	obj.get_material().set_shader_param("stop",true)
func set_mouse(show:int) -> void:
	Input.set_mouse_mode(show)
func press_key(string:String) -> void:
	var ev = InputEventAction.new()
	ev.pressed = true
	ev.action = string
	Input.parse_input_event(ev)	
func release_key(string:String) -> void:
	var ev = InputEventAction.new()
	ev.pressed = false
	ev.action = string
	Input.parse_input_event(ev)

func is_obj(obj) -> bool:
	if !obj:
		return false
	var wr = weakref(obj)
	var data := true
	return wr.get_ref()

# 0 - 99 一百个数
func rand(_max:=100) -> int:
	var data :int = randi() % _max
	return data
func rand_1(_max:=100) -> int:
	var data :int = randi() % _max + 1
	return data
func msg_group(group:String,function:String,arg0:=null,arg1:=null) -> void:
	get_tree().call_group(group,function,arg0,arg1)
func ray(ray,pos):
	ray.cast_to=pos
	ray.force_raycast_update()
	if(ray.is_colliding()):
		var obj=ray.get_collider()
		if(obj.is_queued_for_deletion()):
			return false
		else:
			return obj
	else:
		return false

var vibration
func vibration(time) ->void:
	if vibration:
		vibration.vibrate(time)
func get_save(filename:String,pwd=null,var2:=false):
	var file := File.new()
	if(!file.file_exists("user://"+filename)):return null
	if(!pwd):
		file.open("user://"+filename, File.READ)
	else:
		file.open_encrypted_with_pass("user://"+filename, File.READ,pwd)
	if(!file):return null
	var data
	if var2:
		data = file.get_var()
	else:
		data = parse_json(file.get_as_text())
	file.close()
	if !data:return null
	return data
func set_save(filename:String,data,pwd=null,var2:=false) ->void:
	var file = File.new()
	if(!pwd):
		file.open("user://"+filename, File.WRITE)
	else:
		file.open_encrypted_with_pass("user://"+filename, File.WRITE,pwd)
	if(!file):return 
	if data:
		if var2:
			file.store_var(data)
		else:
			file.store_string(to_json(data))
	file.close()
func read_file(path:String,pwd=null,var2:=false):
	var file = File.new()
	if(!file.file_exists(path)):return null
	if(!pwd):
		file.open(path, File.READ)
	else:
		file.open_encrypted_with_pass(path, File.READ,pwd)
	if(!file):return null
	var data
	if var2:
		data = file.get_var()
	else:
		data =file.get_as_text()
	file.close()
	if !data:return null
	return data
func write_file(path:String,data,pwd=null,var2:=false) ->void:
	var file = File.new()
	if(!pwd):
		file.open(path, File.WRITE)
	else:
		file.open_encrypted_with_pass(path, File.WRITE,pwd)
	if(!file):return 
	if var2:
		file.store_var(data)
	else:
		file.store_string(data)
	file.close()
func get_dir(path:String):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var files=[]
		var folders=[]
		while (file_name != ""):
			if dir.current_is_dir():
				folders.append(file_name)
			else:
				files.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
		return {"files":files,"folders":folders}
	else:
		return null
func make_dir(path:String) -> void:
	var dir = Directory.new()
	dir.make_dir(path)
####
func rename(from,to) -> void:
	var dir = Directory.new()
	dir.rename(from,to)
func copy(from,to) -> void:
	var dir = Directory.new()
	dir.copy(from,to)
func remove(path) -> void:
	var dir := Directory.new()
	var data =[]
	_dir(dir,path,data)	
	var size = data.size()
	for i in range(size):
		var files = data[size-i-1]
		for file in files.files:
			dir.remove(file)
		for folder in files.folders:
			dir.remove(folder)
	dir.remove(path)
func _dir(dir,path,data):
	if dir.open(path) == OK:
		dir.list_dir_begin(true)
		var file_name = dir.get_next()
		var files=[]
		var folders=[]
		while (file_name != ""):
			if dir.current_is_dir():
				folders.append(path+"/"+file_name)
			else:
				files.append(path+"/"+file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
		data.append({"files":files,"folders":folders})
		for dat in folders:
			_dir(dir,dat,data)
	else:
		data.append({"files":[],"folders":[]})

func is_file(path) -> bool:
	var dir = Directory.new()
	if !dir.file_exists(path):
		return false
	else:
		return true
func is_folder(path) -> bool:
	var dir = Directory.new()
	return dir.dir_exists(path)
####
