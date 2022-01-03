extends VBoxContainer
var buff_tscn := preload("res://tscn/ui/status/buff.tscn")
var buffs = Save.save_data.player.buff
var buff_list = {

}
func _ready() -> void:
	Overall.buff_node = self
	for key in Config.BUFF_LIST:
		buff_list[key] = false
	for node in get_children():
		node.free()
	
	yield($"../","ready")
	for key in buffs:
		add_buff_ignore(key,buffs[key])
#	add_buff_ignore("malnutrition",998)
#	add_buff_ignore("diabetes_mild",998)
#	add_buff_ignore("diabetes_moderate",998)
#	add_buff_ignore("diabetes_severe",998)
#buff 重复不添加 
func add_buff(name_:String,time:=0.0) -> void:
	if !name_ in buffs:
		if time == 0.0:time = Config.BUFF_LIST[name_].time
		var tscn = buff_tscn.instance()
		tscn.name = name_
		tscn.get_node("text").text = Config.BUFF_LIST[name_].name
		tscn.get_node("info").text = Config.BUFF_LIST[name_].info
		if time == 999:
			tscn.get_node("time").text = ":--"
		else:
			tscn.get_node("time").text = ":"+str(time)
		tscn.get_node("texture").texture = Config.BUFF_LIST[name_].img
		buff_list[name_]=true
		add_child(tscn)
		sync_buff_pos()
		buffs[name_] = time
		Overall.player_node.check_buff()
	else:
		var node = get_node(name_)
		if time == 0.0:time = Config.BUFF_LIST[name_].time
		if time == 999:
			node.get_node("time").text = ":--"
		else:
			node.get_node("time").text = ":"+str(time)
func sub_buff(name_:String) -> void:
	if name_ in buffs:
		var be = get_node(name_)
		be.name = "order_free"
		be.queue_free()
		buff_list[name_]=false
		buffs.erase(name_)
		Overall.player_node.check_buff()
func clear_buff() -> void:
	for node in get_children():
		var buff_name = node.name
		node.name = "order_free"
		node.queue_free()
		buff_list[buff_name]=false
		buffs.erase(buff_name)
	Overall.player_node.check_buff()
#忽略buff中 存在
func add_buff_ignore(name_:String,time:=0.0) -> void:
	if !has_node(name_):
		if time == 0.0:time = Config.BUFF_LIST[name_].time
		var tscn = buff_tscn.instance()
		tscn.name = name_
		tscn.get_node("text").text = Config.BUFF_LIST[name_].name
		tscn.get_node("info").text = Config.BUFF_LIST[name_].info
		if time == 999:
			tscn.get_node("time").text = ":--"
		else:
			tscn.get_node("time").text = ":"+str(time)
		tscn.get_node("texture").texture = Config.BUFF_LIST[name_].img
		buff_list[name_]=true
		add_child(tscn)
		sync_buff_pos()
		buffs[name_] = time
		Overall.player_node.check_buff()
var time := 0.0
func _process(delta:float) -> void:
	time += delta
	if time >1.0:
		time = 0.0
		for key in buffs:
			if buffs[key] != 999:
				buffs[key] -= 1
				if buffs[key] == 999:buffs[key] =998
			var node = get_node(key)
			if buffs[key] == 999:
				node.get_node("time").text = ":--"
			else:
				node.get_node("time").text = ":"+str(buffs[key])
			
			if buffs[key] <=0:
				sub_buff(key)

func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	rect_position.x = window_size.x - Config.window_size.x + 778
	sync_buff_pos()
func sync_buff_pos() -> void:
	var num = get_child_count()
	var be = (Config.window_size_current.y - 216) - num*70
	if be > num*10:
		self["custom_constants/separation"] = 10
	else:
		self["custom_constants/separation"] = be/num
