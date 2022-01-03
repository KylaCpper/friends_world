extends Object
class_name Graph

#顶点
var vertexes := {}
#邻接表
var adj := {}

var use_power_machine :={}
var generate_power_machine :={}
var gear :={}

func _ready() -> void:
	pass
var vecs = [
	Vector3(0,1,0),Vector3(0,-1,0),
	Vector3(1,0,0),Vector3(-1,0,0),
	Vector3(0,0,1),Vector3(0,0,-1),
]



#0 gear 1 power 2 generate
func add_vertex(vec,type) -> void:
	if vec in vertexes:return
	vertexes[vec]=type
	adj[vec]={}
	for offset in vecs:
		var p = vec+offset
		if p in vertexes:
			add_adj(vec,p)
func add_vertex_update(vec,type) -> void:
	if vec in vertexes:return
	vertexes[vec]=type
	adj[vec]={}
	var be := 0
	for offset in vecs:
		var p = vec+offset
		if p in vertexes:
			be += 1
			add_adj(vec,p)
				
	if be >= 2:
		update(vec)
func add_adj(vec,p) -> void:
	if vertexes[vec] == 0:
		adj[p][vec] = vertexes[vec]
	else:
		#自己不是电线
		adj[p][vec] = vertexes[vec]
		pass
	if vertexes[p] == 0:
		adj[vec][p] = vertexes[p]
	else:
		#别人不是电线
		adj[vec][p] = vertexes[p]
		pass
func del_adj(vec,p) -> void:
	if vertexes[vec] == 0:
		adj[p].erase(vec)
	else:
		#自己不是电线
		adj[p].erase(vec)
		pass
	if vertexes[p] == 0:
		adj[vec].erase(p)
	else:
		#别人不是电线
		adj[vec].erase(p)
		pass
func update(vec) -> void:
	var map := {
		"1":{},
		"2":{}
	}

	update_c(vec,map)
	for v in map["1"]:
		for vv in map["2"]:
			use_power_machine[v][vv]=1
	for v in map["2"]:
		for vv in map["1"]:
			generate_power_machine[v][vv]=2
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
			use_power_machine[v][vv]=1
	for v in map["2"]:
		for vv in map["1"]:
			generate_power_machine[v][vv]=2
func update_all_c(vec,map) -> void:
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


func delete(vec) -> void:
	if vec in vertexes:
#		if vertexes[vec] == 0:
			vertexes.erase(vec)
#			adj[vec]={}
			var be := 0
			for offset in vecs:
				var p = vec+offset
				if p in vertexes:
					be += 1
					del_adj(vec,p)
			if be >= 1:
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
			
