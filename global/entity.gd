extends Node

var list_id := {
	1:"wild_pig"
}
var list:= {
	"wild_pig":1
}

func get_id(name_:String) -> int:
	if name_ in list:
		return list[name_]
	return 0
func get_name_(id:int) -> String:
	if id in list_id:
		return list_id[id]
	return ""



#client entity node children
var entity_node_data := ["id","node_name","x","y","z","hp","node_parent"]
