extends Node
var params := PhysicsShapeQueryParameters.new()
var drop_block_tscn := preload("res://tscn/drop/drop.tscn")
var crack_client_tscn := preload("res://tscn/block/crack/crack_client.tscn")
func _ready():
	add_to_group("terrain_node")
	Overall.terrain_node_node = self
	CollisionGroup.collision($ray,"block_ray")
	
func check_crack() -> void:
	for id in Net.player_info:
		if id != Net.id:
			if !has_node(str(id)):
				var tscn = crack_client_tscn.instance()
				tscn.name = str(id)
				add_child(tscn)
func sync_crack(id:String,crack:Array) -> void:
	if has_node(id):
		var node = get_node(id)
		node.sync_state(crack)
func can_place(vec3:Vector3,ex:=0.5,ignore_liquid:=false) -> bool:
	params.collision_mask = CollisionGroup.CAN_PLACE
	if Overall.terrain_main_node.is_exist(vec3,ignore_liquid):return false
	var space_state = get_viewport().get_world().get_direct_space_state()
	params.transform = Transform(Basis(), vec3 + Vector3(ex,ex,ex))
	var shape = BoxShape.new()
	shape.extents = Vector3(ex, ex, ex)
	params.set_shape(shape)
	var hits = space_state.intersect_shape(params,4)
	return hits.size() == 0
func check_collider(vec3:Vector3,ex:Vector3,mask:=1,ignore_liquid:=false) -> bool:
	params.collision_mask = mask
	if Overall.terrain_main_node.is_exist(vec3,ignore_liquid):return false
	var space_state = get_viewport().get_world().get_direct_space_state()
	params.transform = Transform(Basis(), vec3 + ex)
	var shape = BoxShape.new()
	shape.extents = ex
	params.set_shape(shape)
	var hits = space_state.intersect_shape(params,4)
	return hits.size() != 0
func check_entity(vec3:Vector3,ex:Vector3,mask:=1):
	params.collision_mask = mask
	var space_state = get_viewport().get_world().get_direct_space_state()
	params.transform = Transform(Basis(), vec3 + ex)
	var shape = BoxShape.new()
	shape.extents = ex
	params.set_shape(shape)
	var hits = space_state.intersect_shape(params,4)
	if hits.size() != 0:
		return hits[0].collider
	return false
func check_in_liquid(vec3:Vector3) -> bool:
	return Overall.terrain_main_node.is_liquid(vec3)
func check_player(vec3:Vector3,ex3:Vector3):
	params.collision_mask = CollisionGroup.PICK_DROP
	var space_state = get_viewport().get_world().get_direct_space_state()
	params.transform = Transform(Basis(), vec3)
	var shape = BoxShape.new()
	shape.extents = ex3
	params.set_shape(shape)
	var hits = space_state.intersect_shape(params,1)
	if hits.size() != 0:
		return hits[0].collider
	return false
func get_around(vec3:Vector3,ex3:Vector3,mask:=1) -> Array:
	params.collision_mask = mask  
	var space_state = get_viewport().get_world().get_direct_space_state()
	params.transform = Transform(Basis(), vec3)
	var shape = BoxShape.new()
	shape.extents = ex3
	params.set_shape(shape)
	var hits = space_state.intersect_shape(params,32)
	return hits

#func is_collide_player(vec3:Vector3,ex:Vector3) -> bool:
#	params.collision_mask = CollisionGroup.LAYER.player
#	var space_state = get_viewport().get_world().get_direct_space_state()
#
#	params.transform = Transform(Basis(), vec3)
#	var shape = BoxShape.new()
#	shape.extents = ex
#	params.set_shape(shape)
#	var hits = space_state.intersect_shape(params,1)
#	return hits.size() != 0
func collide_player(vec3:Vector3,ex3:Vector3):
	params.collision_mask = CollisionGroup.LAYER.player
	var space_state = get_viewport().get_world().get_direct_space_state()
	params.transform = Transform(Basis(), vec3)
	var shape = BoxShape.new()
	shape.extents = ex3
	params.set_shape(shape)
	var hits = space_state.intersect_shape(params,1)
	if hits.size() != 0:
		return hits[0].collider
	return false

var drop_num := 0
func create_drops(block_world_pos3:Vector3,drops:Array) -> void:
	block_world_pos3 += Vector3(0.5-randf(),0.5-randf(),0.5-randf())
	for drop in drops:
		var success = create_drop(block_world_pos3,drop)
		if drop.stop && success:break


func create_drop(block_world_pos3:Vector3,drop:Dictionary) -> bool:
	block_world_pos3 += Vector3(0.5-randf(),0.5-randf(),0.5-randf())
#	print(drop.name)
	if "pro" in drop:
		if Function.rand()<drop.pro:
			if Net.is_master():
				c_d([block_world_pos3,drop])
			else:
				rpc_id(1,"c_d",[block_world_pos3,drop])
			return true
	else:
		if Net.is_master():
			c_d([block_world_pos3,drop])
		else:
			rpc_id(1,"c_d",[block_world_pos3,drop])
		return true
	return false
master func c_d(args:Array) -> void:
	var block_world_pos3 = args[0]
	var drop = args[1]
	var tscn = drop_block_tscn.instance()
	tscn.translation = block_world_pos3
	tscn.name_ = drop.name
	tscn.name = str(drop_num)
	tscn.num = drop.num
	rpc1_self("c_dc",[block_world_pos3,drop,drop_num])
	add_child(tscn)
	drop_num += 1
func c_dc(args:Array) -> bool:
	var block_world_pos3 = args[0]
	var drop = args[1]
	var drop_name = str(args[2])
	var tscn = drop_block_tscn.instance()
	tscn.translation = block_world_pos3
	tscn.name_ = drop.name
	tscn.name = drop_name
	tscn.num = drop.num
	add_child(tscn)
	return true


#func drop(block_world_pos3:Vector3,drop:Dictionary) -> void:
#	if drop.num > 0:
#		if Net.is_master():
#			c_d([block_world_pos3,drop])
#		else:
#			rpc_id(1,"c_d",[block_world_pos3,drop])

func drop_force(block_world_pos3:Vector3,drop:Dictionary,force:Vector3) -> void:
	if drop.num > 0:
#		block_world_pos3 += Vector3(0.5-randf(),0.5-randf(),0.5-randf())
		if Net.is_master():
			d_f([block_world_pos3,drop,force])
		else:
			rpc_id(1,"d_f",[block_world_pos3,drop,force])

master func d_f(args:Array) -> void:
	var block_world_pos3 = args[0]
	var drop = args[1]
	var force = args[2]
	var tscn = drop_block_tscn.instance()
	tscn.translation = block_world_pos3
	tscn.drop = true
	tscn.force_vec3 = force
	tscn.drop_type = 2
	tscn.name = str(drop_num)
	tscn.name_ = drop.name
	tscn.num = drop.num
	rpc1_self("d_fc",[block_world_pos3,drop,force,drop_num])
	add_child(tscn)
	drop_num += 1
	
func d_fc(args:Array) -> void:
	var block_world_pos3 = args[0]
	var drop = args[1]
	var force = args[2]
	var drop_name = str(args[3])
	var tscn = drop_block_tscn.instance()
	tscn.translation = block_world_pos3
	tscn.drop = true
	tscn.force_vec3 = force
	tscn.drop_type = 2
	tscn.name_ = drop.name
	tscn.name = drop_name
	tscn.num = drop.num
	add_child(tscn)







#
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
#

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
