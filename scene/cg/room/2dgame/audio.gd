extends Node2D


func play(name_:String) -> void:
	if name_ == "grass_dirt":name_ = "grass"
	if name_ == "leaves":name_ = "leaf"
	get_node("block/"+name_).play()
