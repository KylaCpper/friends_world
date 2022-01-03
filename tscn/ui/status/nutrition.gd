extends Node2D
var status = Save.save_data.player.status
onready var offset = $"../".offset
func _ready() -> void:
	set_val("protein",status.protein,0.0)
	set_val("phytonutrients",status.phytonutrients,0.0)
	set_val("ir",status.ir,0.0)
#	$protein/hint.connect("mouse_entered",self,"_on_enter",["protein_ui"])
#	$protein/hint.connect("mouse_entered",self,"_on_enter",["protein_ui"])
#	$protein/hint.connect("mouse_entered",self,"_on_enter",["protein_ui"])
#
#func _on_enter(name_:String) -> void:
#	pass
var protein_time := 0.0
var protein_time_max := Config.PROTEIN_TIME
var phytonutrients_time := 0.0
var phytonutrients_time_max := Config.PHYTONUTRIENTS_TIME
var ir_time := 0.0
var ir_time_max := Config.IR_TIME
func _process(delta:float) -> void:
	if Overall.op:return
	if Overall.cg:return
	protein_time += delta*offset.nutrition_deplete_time
	phytonutrients_time += delta*offset.nutrition_deplete_time
	ir_time += delta
	if protein_time > protein_time_max:
		protein_time = 0.0
		sub_protein(1.0)
			

	if phytonutrients_time > phytonutrients_time_max:
		phytonutrients_time = 0.0
		sub_phytonutrients(1.0)
			
	if ir_time > ir_time_max:
		ir_time = 0.0
		sub_ir(1.0)
		

func add_protein(val:float) -> void:
	status.protein += val
	if status.protein > status.protein_max:status.protein = status.protein_max
	if status.protein > 1.0 && status.phytonutrients > 1.0:Overall.buff_node.sub_buff("malnutrition")
	set_val("protein",status.protein,val)
func sub_protein(val:float) -> void:
	status.protein -= val
	if status.protein < 0:status.protein = 0.0
	if status.protein<=1.0 || status.phytonutrients<=1.0:Overall.buff_node.add_buff("malnutrition")
	set_val("protein",status.protein,-val)
	
func add_phytonutrients(val:float) -> void:
	status.phytonutrients += val
	if status.phytonutrients > status.phytonutrients_max:status.phytonutrients = status.phytonutrients_max
	if status.protein > 1.0 && status.phytonutrients > 1.0:Overall.buff_node.sub_buff("malnutrition")
	set_val("phytonutrients",status.phytonutrients,val)
func sub_phytonutrients(val:float) -> void:
	status.phytonutrients -= val
	if status.phytonutrients < 0:status.phytonutrients = 0.0
	if status.protein<=1.0 || status.phytonutrients<=1.0:Overall.buff_node.add_buff("malnutrition")
	set_val("phytonutrients",status.phytonutrients,-val)
	
func add_ir(val:float) -> void:
	status.ir += val
	if status.ir > 15:status.ir = 15
	check_ir()
	set_val("ir",status.ir,val)
	
func sub_ir(val:float) -> void:
	status.ir -= val
	check_ir()
	if status.ir < 0.0: status.ir = 0.0
	set_val("ir",status.ir,-val)
func check_ir() -> void:
	if status.ir >= 8.0 && status.ir < 9.0:
		Overall.buff_node.sub_buff("diabetes_moderate")
		Overall.buff_node.sub_buff("diabetes_severe")
		Overall.buff_node.add_buff("diabetes_mild")
	if status.ir >= 9.0 && status.ir < 10.0:
		Overall.buff_node.sub_buff("diabetes_mild")
		Overall.buff_node.sub_buff("diabetes_severe")
		Overall.buff_node.add_buff("diabetes_moderate")
	if status.ir >= 10.0:
		Overall.buff_node.sub_buff("diabetes_mild")
		Overall.buff_node.sub_buff("diabetes_moderate")
		Overall.buff_node.add_buff("diabetes_severe")
	if status.ir < 5.0:
		Overall.buff_node.sub_buff("diabetes_mild")
		Overall.buff_node.sub_buff("diabetes_moderate")
		Overall.buff_node.sub_buff("diabetes_severe")
func set_val(key:String,val:float,sub:float) -> void:
	var tween = get_node(key+"/Tween")
	var pos2 = get_node(key+"/Sprite").rect_position
	var sprite = get_node(key+"/Sprite")
	var node = get_node(key)
	
	sub *= -1
	var be = 1+sub*1
	var time = 0.5+sub*0.2
	var num = ceil(sub/4)
	var alpha =  0.8-sub*0.2
	if alpha <0.0:alpha = 0.0
	tween.interpolate_property(node, "value",
			val+sub, val, time,
			Tween.TRANS_SINE , Tween.EASE_OUT)
	
	for i in num:
		var offset = i*0.5
		tween.interpolate_property(sprite, "rect_position",
				pos2, pos2+Vector2(be,be), 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,offset)
		tween.interpolate_property(sprite, "rect_position",
				pos2+Vector2(be,be), pos2+Vector2(-be,-be), 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,0.1+offset)
		tween.interpolate_property(sprite, "rect_position",
				pos2+Vector2(-be,-be), pos2+Vector2(-be,be), 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,0.2+offset)
		tween.interpolate_property(sprite, "rect_position",
				pos2+Vector2(-be,be), pos2+Vector2(be,-be), 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,0.3+offset)
		tween.interpolate_property(sprite, "rect_position",
				pos2+Vector2(be,-be), pos2, 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,0.4+offset)
			
	tween.interpolate_property(node, "modulate",
			Color(1,1,1,1), Color(1,1,1,alpha), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT)
	tween.interpolate_property(node, "modulate",
			Color(1,1,1,alpha), Color(1,1,1,1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.1)
	tween.interpolate_property(node, "modulate",
			Color(1,1,1,1), Color(1,1,1,alpha+0.1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.2)
	tween.interpolate_property(node, "modulate",
			Color(1,1,1,alpha+0.1), Color(1,1,1,1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.3)
	tween.start()
func set_satiety_max(val:float) -> void:
	$satiety.max_value = val
	status.satiety_max = val
func set_thirst_max(val:float) -> void:
	$thirst.max_value = val
	status.thirst_max = val

func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
#	position += diff_size
#	position.x = Config.window_size.x - window_size.x
	position.x = window_size.x - Config.window_size.x
	
