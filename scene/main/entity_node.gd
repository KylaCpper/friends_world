extends Node
var wild_pig = preload("res://tscn/animal/land/wild_pig/wild_pig.tscn")
var wild_pig_client = preload("res://tscn/animal/land/wild_pig/wild_pig_client.tscn")
var done := false
var _node_ := Node.new()
func _ready() -> void:
	Overall.entity_node_node = self
	if !"entity" in Save.world:Save.world["entity"]={}
	
	if Net.is_master():
		for key in Save.world.entity:
			var data = Save.world.entity[key]
			add_entity_from_data(Entity.get_name_(data[0]),Vector3(data[2],data[3],data[4]),data[5],data[6])
	else:
		var list = Entity.entity_node_data
		for data in list:
			add_client_entity_from_server(data[0],data[1],Vector3(data[2],data[3],data[4]),data[5],data[6])
	done = true
var node_name_id = 0
func add_entity_from_data(name_:String,vec3:Vector3,hp:float,parent_name:String) -> void:
	var tscn = self[name_].instance()
	tscn.translation = vec3
	tscn.name = str(node_name_id)
	tscn.hp = hp
	node_name_id += 1
	if has_node(parent_name):
		get_node(parent_name).add_child(tscn)
	else:
		var p = _node_.duplicate()
		p.name = parent_name
		add_child(p)
		p.add_child(tscn)
func add_entity(name_:String,vec3:Vector3) -> void:
	if Net.status:
		if Net.id ==1:
			add_entity_server([name_,vec3])
		else:
			rpc_id(1,"add_entity_server",[name_,vec3])
	else:
		var parent_name = str(int(vec3.x/16))+","+str(int(vec3.z/16))
		if has_node(parent_name):
			if get_node(parent_name).get_child_count() >= 16:
				return
		var tscn = self[name_].instance()
		tscn.translation = vec3
		tscn.name = str(node_name_id)
		Save.world.entity[node_name_id] = [Entity.get_id(name_),node_name_id,vec3.x,vec3.y,vec3.z,tscn.hp,parent_name]
		node_name_id += 1
		if has_node(parent_name):
			get_node(parent_name).add_child(tscn)
		else:
			var p = _node_.duplicate()
			p.name = parent_name
			add_child(p)
			p.add_child(tscn)
func delete_entity(node_name_id_:int) -> void:
	if Net.status:
		if Net.id ==1:
			delete_entity_server(node_name_id_)
		else:
			rpc_id(1,"delete_entity_server",node_name_id_)
	else:
		Save.world.entity.erase(node_name_id_)

master func delete_entity_server(node_name_id_:int) -> void:
	rpc1_self("delete_entity_client",node_name_id_)
	Save.world.entity.erase(node_name_id_)
	
puppet func delete_entity_client(node_name_id_:int) -> void:
	if has_node(str(node_name_id_)):
		get_node(str(node_name_id_)).queue_free()
master func add_entity_server(args:Array) -> void:
	var name_ = args[0]
	var vec3 = args[1]
	var parent_name = str(int(vec3.x/16))+","+str(int(vec3.z/16))
	if has_node(parent_name):
		if get_node(parent_name).get_child_count() >= 16:
			return
	var tscn = self[name_].instance()
	tscn.translation = vec3
	tscn.name = str(node_name_id)
	Save.world.entity[node_name_id] = [Entity.get_id(name_),node_name_id,vec3.x,vec3.y,vec3.z,tscn.hp,parent_name]
	node_name_id += 1
	if has_node(parent_name):
		get_node(parent_name).add_child(tscn)
	else:
		var p = _node_.duplicate()
		p.name = parent_name
		add_child(_node_)
		p.add_child(tscn)
	rpc1_self("add_entity_client",[name_,vec3,tscn.name])
puppet func add_entity_client(args:Array) -> void:
	var name_ = args[0]
	var vec3 = args[1]
	var node_name = args[2]
	var tscn = self[name_+"_client"].instance()
	tscn.translation = vec3
	tscn.name = node_name
	var parent_name = str(int(vec3.x/16))+","+str(int(vec3.z/16))
	if has_node(parent_name):
		get_node(parent_name).add_child(tscn)
	else:
		var p = _node_.duplicate()
		p.name = parent_name
		add_child(_node_)
		p.add_child(tscn)

func add_client_entity_from_server(id:int,node_name_id_:int,vec3:Vector3,hp:float,parent_name:String) -> void:
	var name_ = Entity.get_name_(id)
	var tscn = self[name_+"_client"].instance()
	tscn.translation = vec3
	tscn.name = str(node_name_id_)
	tscn.hp = hp
	if has_node(parent_name):
		get_node(parent_name).add_child(tscn)
	else:
		var p = _node_.duplicate()
		p.name = parent_name
		add_child(p)
		p.add_child(tscn)

func get_entitys_list() -> Array:
	var list = []
	for node_p in get_children():
		for node in node_p.get_children():
			var vec3 = node.translation
			list.append([node.id,int(node.name),vec3.x,vec3.y,vec3.z,node.hp,node_p.name])
	return list

func save_data() -> void:
	Save.world.entity={}
	for nodes in get_children():
		for node in nodes.get_children():
			var vec3 = node.translation
			Save.world.entity[int(node.name)] = [node.id,int(node.name),vec3.x,vec3.y,vec3.z,node.hp,str(int(vec3.x/16))+","+str(int(vec3.z/16))]
##########################################
func rpc0(node_name:String,func_name:String,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r0",[node_name,func_name])
			else:
				r0([node_name,func_name])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r0",[node_name,func_name])
func rpc0_udp(node_name:String,func_name:String,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r0",[node_name,func_name])
			else:
				r0([node_name,func_name])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r0",[node_name,func_name])

remote func r0(args:Array) -> void:
	var node_name = args[0]
	var func_name = args[1]
	if has_node(node_name):
		get_node(node_name).call(func_name)
	

func rpc1(node_name:String,func_name:String,args0,sync_:=false) -> void:
	if !Net.status:return
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r1",[node_name,func_name,args0])
			else:
				r1([node_name,func_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r1",[node_name,func_name,args0])
func rpc1_udp(node_name:String,func_name:String,args0,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r1",[node_name,func_name,args0])
			else:
				r1([node_name,func_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r1",[node_name,func_name,args0])
remote func r1(args:Array) -> void:
	var node_name = args[0]
	var func_name = args[1]
	var args0 = args[2]
	if has_node(node_name):
		get_node(node_name).call(func_name,args0)
##############################################
func rpc1_self(func_name:String,args0,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r1s",[func_name,args0])
			else:
				r1s([func_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"r1s",[func_name,args0])
func rpc1_udp_self(func_name:String,args0,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r1s",[func_name,args0])
			else:
				r1s([func_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"r1s",[func_name,args0])
remote func r1s(args:Array) -> void:
	var func_name = args[0]
	var args0 = args[1]
	call(func_name,args0)
	
	
func rset1(node_name:String,var_name:String,args0,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"rs",[node_name,var_name,args0])
			else:
				rs([node_name,var_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_id(id,"rs",[node_name,var_name,args0])
func rset1_udp(node_name:String,var_name:String,args0,sync_:=false) -> void:
	if sync_:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"rs",[node_name,var_name,args0])
			else:
				rs([node_name,var_name,args0])
	else:
		for id in Net.player_info:
			if id != Net.id:
				rpc_unreliable_id(id,"rs",[node_name,var_name,args0])
remote func rs(args:Array) -> void:
	var node_name = args[0]
	var var_name = args[1]
	var data = args[2]
	if has_node(node_name):
		get_node(node_name)[var_name]=data
