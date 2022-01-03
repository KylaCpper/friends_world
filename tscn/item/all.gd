extends Spatial
var speed := 1.0
var mat := preload("res://tscn/item/all.tres")
export var process := true
func _ready():
	$item.mesh = null
	$model.mesh = null
	$single.hide()
	hide()
	set_process(process)
func set_speed(speed:float) -> void:
	self.speed = speed
	time_max = 10.0 / speed
	pro = 360.0 / time_max
func _show(name_:String) ->void:
	if name_:
		var item = Item.get(name_)
		show()
		if item.type == "block":
			if item.model:
				$item.mesh = null
				$item.hide()
				$single.hide()
				$model.mesh = item.model
				$model.show()
			else:
				$item.mesh = null
				$item.hide()
				$model.mesh = null
				$model.hide()
				$single._show(name_)
				
		else:
			$model.mesh = null
			$model.hide()
			$single.hide()
			$item.create(item.img)
			$item.show()
	else:
		$item.mesh = null
		$item.hide()
		$model.mesh = null
		$model.hide()
		$single.hide()
		hide()
var time := 0.0
var time_max := 10.0
var pro := 36.0
func _process(delta:float) -> void:
	time += delta
	if time > time_max:
		time = 0.0
	var rot = Vector3(0,time*pro,0)
	rotation_degrees = rot
#	$single.rotation_degrees = rot
#	$model.rotation_degrees = rot
#	$item.rotation_degrees = rot

