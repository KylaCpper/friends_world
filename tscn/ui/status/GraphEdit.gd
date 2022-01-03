extends GraphEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$GraphNode.set_slot(0,true,0,Color(1,1,1,1),true,0,Color(1,1,1,1))
	$GraphNode.set_slot(1,true,0,Color(1,1,1,1),true,0,Color(1,1,1,1))
	$GraphNode2.set_slot(0,true,0,Color(1,1,1,1),true,0,Color(1,1,1,1))
	$GraphNode2.set_slot(1,true,0,Color(1,1,1,1),true,0,Color(1,1,1,1))
	connect_node("GraphNode", 0, "GraphNode2", 1)
	connect_node("GraphNode", 1, "GraphNode2", 0)
