extends GuiGrid
var name_ := ""
var grid_tscn := preload("res://tscn/ui/composite_info/grid.tscn")
var par_tscn := preload("res://tscn/ui/composite_info/Particles2D.tscn")
var result_obj = {"name":"","num":0,"hp":0}
var export_obj = {"name":"","num":0,"hp":0}
var page := 0

func _init() -> void:
	grid = 2
	
#	gird_path = "bg/grid/bar"
var pro_time := 0.1

func _ready() -> void:
	Overall.composite_info_node = self
	hide()
	$export/make_num.hide()
	check_rect()
	connect("visibility_changed",self,"_on_visible")
	$export/Button.connect("pressed",self,"_on_export_press")
	$export/pro.value = 0.0
	$next.connect("pressed",self,"_on_next")
	$back.connect("pressed",self,"_on_back")
	set_process(false)
func _on_next() -> void:
	var composites = Composite.get_table_small(name_)
	var size = composites.size()
	$back.show()
	if page+2 >= size:
		$next.hide()
	if page+1 < size:
		page += 1
	update()
func _on_back() -> void:
	var composites = Composite.get_table_small(name_)
	var size = composites.size()
	if size>1:
		$next.show()
		
	if page-1 <= 0:
		$back.hide()
	if page > 0:
		page -= 1
	update()
func set_name(name__:String) -> void:
	if name_ != name__:
		page = 0
	name_ = name__
	var composites = Composite.get_table_small(name_)
	if composites.size()>1:
		$next.show()
	else:
		$next.hide()
	$back.hide()
	if name_:
		show()
	else:
		hide()
	pro = 0.0
	update()
	Overall.composite_node.update_change()
func hide() -> void:
#	clear()
#	pro = 0.0
	.hide()
func update() -> void:
	clear()
	if name_:
		var composites = Composite.get_table_small(name_)
		var composite = composites[page]
		yield(get_tree(),"idle_frame")
		if Item.get(composite.name).type == "block":
			Overall.photograph_node.set_texture(composite.name,$result/texture)
		else:
			$result/texture.texture = Item.get(composite.name).img
		$result/num.text = str(composite.num)
		pro_time = get_make_time(composite)
		result_obj.num = composite.num
		result_obj.name = composite.name
		var hp = Item.get_hp(name_)
		result_obj.hp = hp
		for name__ in composite.table:
			hp = Item.get_hp(name__)
			list.append({"name":name__,"num":composite.table[name__],"hp":hp})
			var tscn = grid_tscn.instance()
			tscn.name = "bar"+str(grid)
			$grid.add_child(tscn)
			grid +=1
		for i in range(grid):
			own_rects.append(get_node(gird_path+str(i)))
		check_rect()
		update_export()
			
		
	.update()
func update_export() -> void:
	var items_conform = get_conform()
	for i in grid:
		get_node("grid/bar"+str(i)+"/bg2").show()
		get_node("grid/bar"+str(i)+"/num").modulate = Config.COLCOR2
		get_node("grid/bar"+str(i)+"/num2").modulate = Config.COLCOR2
		$result/bg2.show()
		$result/num.modulate = Config.COLCOR2
		for name__ in items_conform:
			if list[i].name == name__:
				get_node("grid/bar"+str(i)+"/bg2").hide()
				get_node("grid/bar"+str(i)+"/num").modulate = Config.COLCOR
				get_node("grid/bar"+str(i)+"/num2").modulate = Config.COLCOR
				$result/bg2.hide()
				$result/num.modulate = Config.COLCOR
func get_make_time(composite) -> float:
	if "time" in composite:
		return composite.time
	else:
		return Config.COMPOSITE_TIME
func _on_visible() -> void:
	if visible:
		if !name_:
			hide()
	
#	else:
#		set_name("")
onready var rect_size = {
	"result":$result.rect_position.y-70,
	"export":$export.rect_position.y-70,
}
func check_rect() -> void:
	var num = grid
	if num%2:num +=1
	num /=2
	$bg.rect_size.y = 176 + 70 * num
	$result.rect_position.y = rect_size.result + 70 * num
	$export.rect_position.y = rect_size.export + 70 * num
func clear() -> void:
	for obj in $grid.get_children():
		obj.queue_free()
	set_process(false)
	make_frequency = 0
	show_make_num()
	clear_export()
	grid = 0
	list = []
	own_rects = []
func clear_export() -> void:
	$export/pro.value = 0.0
	$export/texture.texture = null
	$export/num.text = ""
	if export_obj.name:
		Overall.bar_node.add_item(export_obj)
		Overall.item_clear(export_obj)
func _on_mouse_right(index:int) -> void:
	pass
func _on_mouse_left(index:int) -> void:
	pass
func _on_mouse_left_move() -> void:
	pass
func _on_mouse_left_restore() -> void:
	pass
func _on_mouse_entered(index:int) -> void:
	for i in range(grid):
		if index == i:
			get_node(gird_path+str(i)+"/bg").show()
		else:
			get_node(gird_path+str(i)+"/bg").hide()
	Overall.msg_grid_item_node.set_item(list[index])
	
func _on_export_press() -> void:
	if !export_obj.name:
		if make():
			var tscn = par_tscn.instance()
			$export/Button/pos2.add_child(tscn)
			$export/AnimationPlayer.play("start")
	else:
		if export_obj.name == result_obj.name:
			if (export_obj.num + result_obj.num) <= Item.get_max(result_obj.name):
				if make():
					var tscn = par_tscn.instance()
					$export/Button/pos2.add_child(tscn)
					$export/AnimationPlayer.play("start")
func get_conform() -> Array:
	var sub_list = []
	var composites = Composite.get_table_small(name_)
	var composite = composites[page]
	for name_ in composite.table:
		sub_list.append({"name":name_,"num":composite.table[name_],"hp":Item.get_hp(name_)})
	return Overall.bag_node.is_items_arr(sub_list)
func is_make() -> bool:
	var sub_list = []
	var composites = Composite.get_table_small(name_)
	var composite = composites[page]
	for name_ in composite.table:
		sub_list.append({"name":name_,"num":composite.table[name_],"hp":Item.get_hp(name_)})
	if Overall.bag_node.is_items(sub_list):
		return true
	else:
		return false
var make_frequency := 0
func make() -> bool:
	if pro > 0.0 && pro < 100.0:
		make_frequency += 1
		show_make_num()
		return false
	if is_make():
		pro = 0.0
		set_process(true)
		return true
	else:
		make_frequency = 0
		show_make_num()
		return false
func show_make_num() -> void:
	if make_frequency > 0:
		$export/make_num.text = "x"+str(make_frequency+1)
		$export/make_num.show()
	else:
		$export/make_num.text = "x0"
		$export/make_num.hide()
func maked() -> bool:
	var sub_list = []
	var composites = Composite.get_table_small(name_)
	var composite = composites[page]
	for name_ in composite.table:
		sub_list.append({"name":name_,"num":composite.table[name_],"hp":Item.get_hp(name_)})
	if Overall.bag_node.sub_items(sub_list):
		update_export()
		Overall.composite_node.update_change()
		return true
	else:
		return false
var pro := 0.0
func _process(delta:float) -> void:
	pro += delta*100/pro_time
	$export/pro.value = pro
	if !$export/AnimationPlayer.is_playing():
		var tscn = par_tscn.instance()
		$export/Button/pos2.add_child(tscn)
		$export/AnimationPlayer.play("start")
	if pro >= 100.0:
		set_process(false)
		$export/pro.value = 0.0
		if maked():
			if !export_obj.name:
				export_obj = result_obj.duplicate()
			else:
				if export_obj.name == result_obj.name:
					if (export_obj.num + result_obj.num) <= Item.get_max(result_obj.name):
						export_obj.num += result_obj.num
			if Item.get(export_obj.name).type == "block":
				Overall.photograph_node.set_texture(export_obj.name,$export/texture)
			else:
				$export/texture.texture = Item.get(export_obj.name).img
			$export/num.text = str(export_obj.num)
		if make_frequency > 0:
			make_frequency -= 1
			show_make_num()
			make()
#	return false
func input_mouse(event:InputEvent,control) -> void:
	if control.mouse:
		var pos = event.position
		if $result.get_global_rect().has_point(pos):
			$result/bg.show()
			Overall.msg_grid_item_node.set_item(result_obj)
		else:
			$result/bg.hide()
			
			if Overall.msg_grid_item_node.name_ == result_obj.name:
				Overall.msg_grid_item_node.set_item()
		if $export.get_global_rect().has_point(pos):
			$export/bg.show()
			Overall.msg_grid_item_node.set_item(export_obj)
		else:
			$export/bg.hide()
			if Overall.msg_grid_item_node.name_ == export_obj.name:
				Overall.msg_grid_item_node.set_item()

		if control.mouse_button:
			if control.mouse_left:
				if $export.get_global_rect().has_point(pos):
					if !Overall.pick_item_node.is_item:
						Overall.pick_item_node.set_item(export_obj.duplicate())
						Overall.item_clear(export_obj)
						$export/texture.texture = null
						$export/num.text = ""
					else:
						if Overall.pick_item_node.item.name == export_obj.name && Overall.pick_item_node.item.hp==0:
							if Overall.pick_item_node.add(export_obj.num,export_obj.name) == 0:
								Overall.item_clear(export_obj)
								$export/texture.texture = null
								$export/num.text = ""


func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	position += diff_size
