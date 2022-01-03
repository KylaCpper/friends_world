extends Node

#顶点
var vertexes := {}
#邻接表
var adj := {}
var inv_adj := {}
#

var use_power_machine :={}
var generate_power_machine :={}


func _ready() -> void:
	pass
var vecs = [
	[
		Vector3(0,1,0),Vector3(0,-1,0),
		Vector3(1,0,0),Vector3(-1,0,0),
		Vector3(0,0,1),Vector3(0,0,-1),
	],
	[
		Vector3(0,1,0),Vector3(0,-1,0),
		Vector3(1,0,0),Vector3(-1,0,0),
	],
	[
		Vector3(0,1,0),Vector3(0,-1,0),
		Vector3(0,0,1),Vector3(0,0,-1),
	],
	[
		Vector3(1,0,0),Vector3(-1,0,0),
		Vector3(0,0,1),Vector3(0,0,-1),
	],
	[
		Vector3(0,1,0),Vector3(0,-1,0),
	],
	[
		Vector3(1,0,0),Vector3(-1,0,0),
	],
	[
		Vector3(0,0,1),Vector3(0,0,-1),
	],
]
# 1 3 2
# 2 4 3
# 3 1 4
func is_connect(vec) -> bool:
	var map := {}
	return is_connect_c(vec,map)
func is_connect_c(vec,map) -> bool:
	if vec in inv_adj:
		for v in inv_adj[vec]:
			if !(v in map):
				map[v]=0
				var type = inv_adj[vec][v]
				if type == 2:return true
				if is_connect_c(v,map):return true
		return false
	return false
#0 gear 1 power 2 generate
#dire 0 all 1 +-x+-y 2 +-z+-y 3 +-x+-z 4 +-y 5 +-x 6 +-z
func add_vertex(vec,type,dire_type:=0,dire:=0) -> void:
	if vec in vertexes:return
	vertexes[vec]=type
	adj[vec]={}
	if dire_type == 1:
		if dire == 1:
			dire_type = 2
		if dire == 3:
			dire_type = 2
	if dire_type == 2:
		if dire == 1:
			dire_type = 1
		if dire == 3:
			dire_type = 1
	if dire_type == 5:
		if dire == 1:
			dire_type = 6
		if dire == 3:
			dire_type = 6
	if dire_type == 6:
		if dire == 1:
			dire_type = 5
		if dire == 3:
			dire_type = 5
	for offset in vecs[dire_type]:
		var p = vec+offset
		if p in vertexes:
			add_adj(vec,p)
func add_vertex_update(vec,type,dire_type:=0,dire:=0) -> void:
	if vec in vertexes:return
	vertexes[vec]=type
	adj[vec]={}
	var be := 0
	if dire_type == 1:
		if dire == 1:
			dire_type = 2
		if dire == 3:
			dire_type = 2
	if dire_type == 2:
		if dire == 1:
			dire_type = 1
		if dire == 3:
			dire_type = 1
	if dire_type == 5:
		if dire == 1:
			dire_type = 6
		if dire == 3:
			dire_type = 6
	if dire_type == 6:
		if dire == 1:
			dire_type = 5
		if dire == 3:
			dire_type = 5
	for offset in vecs[dire_type]:
		var p = vec+offset
		if p in vertexes:
			be += 1
			add_adj(vec,p)
	if be >0:
		update(vec)

func add_adj(vec,p) -> void:
	if vertexes[vec] == 0 && vertexes[p] == 0:
		adj[vec][p] = vertexes[p]
		adj[p][vec] = vertexes[vec]
		if !vec in inv_adj:inv_adj[vec] = {}
		if !p in inv_adj:inv_adj[p] = {}
		inv_adj[vec][p] = vertexes[p]
		inv_adj[p][vec] = vertexes[vec]
	elif vertexes[vec] == 1 && vertexes[p] == 0:
		adj[p][vec] = vertexes[vec]
		if !vec in inv_adj:inv_adj[vec] = {}
		inv_adj[vec][p] = vertexes[p]
	elif vertexes[vec] == 2 && vertexes[p] == 0:
		adj[vec][p] = vertexes[p]
		if !p in inv_adj:inv_adj[p] = {}
		inv_adj[p][vec] = vertexes[vec]
	elif vertexes[vec] == 0 && vertexes[p] == 1:
		adj[vec][p] = vertexes[p]
		if !p in inv_adj:inv_adj[p] = {}
		inv_adj[p][vec] = vertexes[vec]
	elif vertexes[vec] == 0 && vertexes[p] == 2:
		adj[p][vec] = vertexes[vec]
		if !vec in inv_adj:inv_adj[vec] = {}
		inv_adj[vec][p] = vertexes[p]
func del_adj(vec,p) -> void:
	if p in inv_adj:
		inv_adj[p].erase(vec)
	if vec in inv_adj:
		inv_adj[vec].erase(p)
	if p in adj:
		adj[p].erase(vec)
	if vec in adj:
		adj[vec].erase(p)

func update(vec) -> void:
	var map := {
		"1":{},
		"2":{}
	}
	
	update_c(vec,map)
	for v in map["1"]:
		for vv in map["2"]:
			if !(v in use_power_machine):use_power_machine[v]={}
			var n = Overall.terrain_main_node.get_name_(vv)
			var script = Item.get(n).script
			use_power_machine[v][vv]=script.get_energy()
	for v in map["2"]:
		for vv in map["1"]:
			if !(v in generate_power_machine):generate_power_machine[v]={}
			generate_power_machine[v][vv]=1
	

func update_c(vec,map) -> void:
	for v in adj[vec]:
		if !(v in map):
			map[v]=0
			var type = adj[vec][v]
			if type != 0:
				if type == 1:
					map["1"][v]=1
				elif type == 2:
					map["2"][v]=2
			update_c(v,map)
func update_all() ->void:
	use_power_machine.clear()
	generate_power_machine.clear()
	var map := {
		"1":{},
		"2":{}
	}
	for vec in adj:
		update_c(vec,map)
	for v in map["1"]:
		for vv in map["2"]:
			use_power_machine[v][vv]=2
	for v in map["2"]:
		for vv in map["1"]:
			generate_power_machine[v][vv]=1



func del_vertex_update(vec) -> void:
	if vec in vertexes:
#		if vertexes[vec] == 0:
#			adj[vec]={}
			var be := 0
			for offset in vecs[0]:
				var p = vec+offset
				if p in vertexes:
					be += 1
					del_adj(vec,p)
			vertexes.erase(vec)
			if be > 0:
				update_all()
#		else:
#			var type = vertexes[vec]
#			if type == 1:
#				for v in use_power_machine[vec]:
#					generate_power_machine[v].erase(vec)
#				use_power_machine[vec].clear()
#			if type == 2:
#				for v in generate_power_machine[vec]:
#					use_power_machine[v].erase(vec)
#				generate_power_machine[vec].clear()
#
#			vertexes.erase(vec)
			
