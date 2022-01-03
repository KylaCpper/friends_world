extends Spatial
var chunk := Vector3()
var name_ 
var dire := 3
export var par := false
export var pos3 := Vector3(-1,-1,-1)
var single0 := preload("res://tscn/chunk/single/single0.tres")
var single1 := preload("res://tscn/chunk/single/single1.tres")
var single2 := preload("res://tscn/chunk/single/single2.tres")
var single3 := preload("res://tscn/chunk/single/single3.tres")
var single4 := preload("res://tscn/chunk/single/single4.tres")
func _ready() -> void:
	translation=pos3
func _show(name_:String,dire:=3) -> void:
	self.dire = dire
	var block = Block.get(name_)
	if block:
		self.name_ = name_
		show()
		if "material" in block:
			$single.material_override = self["single"+str(block.material)]
		else:
			$single.material_override = single0
		$single.update()
	else:
		hide()
func hide() -> void:
	.hide()
	$single.mesh = null
func update() -> void:
	show()
	$single.update()
