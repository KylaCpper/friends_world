extends Node2D
class_name status_node
var status = Save.save_data.player.status

var offset = {
	
	"absorb":1.0,#加营养
	"deplete_time":1.0,#减营养需要的每帧时间
	"nutrition_absorb":1.0,
	"nutrition_deplete_time":1.0,
	"sub_hp":1.0,
}
func _ready() -> void:
	Overall.status_node = self
	set_hp(status.head,"head")
	set_hp(status.body,"body")
	set_hp(status.arm_left,"arm_left")
	set_hp(status.arm_right,"arm_right")
	set_hp(status.leg_left,"leg_left")
	set_hp(status.leg_right,"leg_right")
	set_hp(status.foot_left,"foot_left")
	set_hp(status.foot_right,"foot_right")
	set_health(status.health,0.0)
	set_satiety(status.satiety,0.0)
	set_thirst(status.thirst,0.0)
#	sub_health(3.0)

func add_hp(val:float,body:String) -> void:
	if val==0.0:return
	status[body] += val
	if status[body] > status[body+"_max"]:
		status[body] = status[body+"_max"]
	set_hp(status[body],body)
func add_hp_all(val:float) -> void:
	if val==0.0:return
	var body
	if val > 0.0:
		for d in ["head","body","arm_left","arm_right","leg_left","leg_right","foot_left","foot_right"]:
			add_hp(val,d)
	else:
		for d in ["head","body","arm_left","arm_right","leg_left","leg_right","foot_left","foot_right"]:
			sub_hp(val,d,false)
func sub_hp(val:float,body:String,is_self:bool) ->void:
	if val==0.0:return
	if Overall.op:return
	if Overall.hurt_node.dead:return
	var armor := false
	if !is_self:
#		if status[body] <= 0:
#			if body == "foot_left":
#				body = "leg_left"
#			elif body == "foot_right":
#				body = "leg_right"
		if Overall.state_gui_node.sub_armor(val,body):
			armor = true
	if armor:
		status[body] -= val*0.1
	else:
		status[body] -= val
		sub_health(val*0.1)
	check_limb_buff(body)
	set_hp(status[body],body)
	if status[body] <= 0:
		sub_health(abs(status[body]))
		status[body] = 0
		if body == "body" || body == "head":
			Overall.hurt_node.dead()
			return

	Overall.hurt_node.hurt(armor)
func check_limb_buff(body:String) -> void:
	if status[body] <= 0:
		if body == "arm_left":
			$buff.add_buff("arm_left_injuried")
		if body == "arm_right":
			$buff.add_buff("arm_right_injuried")
		if body == "leg_left":
			$buff.add_buff("leg_left_injuried")
		if body == "leg_right":
			$buff.add_buff("leg_right_injuried")
		if body == "foot_left":
			$buff.add_buff("foot_left_injuried")
		if body == "foot_right":
			$buff.add_buff("foot_right_injuried")
	if status[body] <= 1.0:
		if body == "body":
			$buff.add_buff("stomach_injuried")
			
	if status[body] > 0:
		if body == "arm_left":
			$buff.sub_buff("arm_left_injuried")
		if body == "arm_right":
			$buff.sub_buff("arm_right_injuried")
		if body == "leg_left":
			$buff.sub_buff("leg_left_injuried")
		if body == "leg_right":
			$buff.sub_buff("leg_right_injuried")
		if body == "foot_left":
			$buff.sub_buff("foot_left_injuried")
		if body == "foot_right":
			$buff.sub_buff("foot_right_injuried")
	if status[body] > 1.0:
		if body == "body":
			$buff.sub_buff("stomach_injuried")
var is_show_armor:=true
func change_armor() -> void:
	is_show_armor = !is_show_armor
	if is_show_armor:
		$hp/head/armor.show()
		$hp/arm_left/armor.show()
		$hp/arm_right/armor.show()
		$hp/body/armor.show()
		$hp/leg_left/armor.show()
		$hp/leg_right/armor.show()
		$hp/foot_left/armor.show()
		$hp/foot_right/armor.show()
	else:
		$hp/head/armor.hide()
		$hp/arm_left/armor.hide()
		$hp/arm_right/armor.hide()
		$hp/body/armor.hide()
		$hp/leg_left/armor.hide()
		$hp/leg_right/armor.hide()
		$hp/foot_left/armor.hide()
		$hp/foot_right/armor.hide()
func sub_armor_ani(body:String,hp:float,hp_max:float) -> void:
	if hp <= 0.0:
		get_node("hp/"+body+"/armor").hide()
		get_node("hp/"+body+"/armor").modulate.a = 0.0
		return
	get_node("hp/"+body+"/armor").show()
	get_node("hp/"+body+"/armor").modulate.a = hp/hp_max
	
func add_health(val:float) -> void:
	if val==0.0:return
	if val < 0:
		sub_health(-val)
		return
	status.health += val
	set_health(status.health,val)
	if status.health > status.health_max:status.health = status.health_max
func sub_health(val:=1.0) ->void:
	if val==0.0:
		return
	if Overall.op:return
	status.health -= val
	set_health(status.health,-val)
	if status.health <=0.0:
		status.health == 0.0
	if status["health"] <= 0:
		status["health"] = 0
		Overall.hurt_node.dead()
		return
	Overall.hurt_node.hurt()
func add_satiety(val:float) -> void:
	if val==0.0:return
	if val < 0:
		sub_satiety(-val)
		return
	Overall.buff_node.sub_buff("hunger")
	val *= offset.absorb
	status.satiety += val
	set_satiety(status.satiety,val)
	if status.satiety > status.satiety_max:status.satiety = status.satiety_max
func sub_satiety(val:float) ->void:
	if val==0.0:
		Overall.buff_node.add_buff("hunger")
		return
	if Overall.op:return
	status.satiety -= val
	set_satiety(status.satiety,-val)
	if status.satiety <=0.0:
		status.satiety == 0.0
		Overall.buff_node.add_buff("hunger")
		
func add_thirst(val:float) -> void:
	if val==0.0:return
	if val < 0:
		sub_thirst(-val)
		return
	Overall.buff_node.sub_buff("thirst")
	val *= offset.absorb
	status.thirst += val
	set_thirst(status.thirst,val)
	if status.thirst > status.thirst_max:status.thirst = status.thirst_max
func sub_thirst(val:=1.0) ->void:
	if val==0.0:
		Overall.buff_node.add_buff("thirst")
		return
	if Overall.op:return
	status.thirst -= val
	set_thirst(status.thirst,-val)
	if status.thirst <=0.0:
		status.thirst == 0.0
		Overall.buff_node.add_buff("thirst")

func add_protein(val:float) -> void:
	if val==0.0:return
	if val < 0:
		sub_protein(-val)
		return
	val *= offset.nutrition_absorb
	$nutrition.add_protein(val)
func sub_protein(val:float) -> void:
	if val==0.0:return
	$nutrition.sub_protein(val)
func add_phytonutrients(val:float) -> void:
	if val==0.0:return
	if val < 0:
		sub_phytonutrients(-val)
		return
	val *= offset.nutrition_absorb
	$nutrition.add_phytonutrients(val)
func sub_phytonutrients(val:float) -> void:
	if val==0.0:return
	$nutrition.sub_phytonutrients(val)
func add_ir(val:float) -> void:
	if val==0.0:return
	if val > 0.0:
		if $buff.buff_list.diabetes_severe:
			Overall.player_node.hurt_hp(1.0,Vector3(0,0,0))
	$nutrition.add_ir(val)
func sub_ir(val:float) -> void:
	if val==0.0:return
	$nutrition.sub_ir(val)

var satiety_time := 0.0
var satiety_time_max := Config.SATIETY_TIME
var thirst_time := 0.0
var thirst_time_max := Config.THIRST_TIME
var sub_hp_time := 0.0
var sub_hp_time_max := 2.0
func add_time(key:String,val:float) -> void:
	self[key]+=val
func _process(delta:float) -> void:
	if Overall.op:return
	if Overall.cg:return
	satiety_time += delta*offset.deplete_time
	thirst_time += delta*offset.deplete_time
	if satiety_time > satiety_time_max:
		satiety_time = 0.0
		sub_satiety(1.0)

	if thirst_time > thirst_time_max:
		thirst_time = 0.0
		sub_thirst(1.0)
	sub_hp_time += delta
	if sub_hp_time > sub_hp_time_max:
		sub_hp_time = 0.0
		var sub_hp = 0.0
		for key in Overall.buff_node.buff_list:
			if Overall.buff_node.buff_list[key]:
				if Config.BUFF_LIST[key].sub_hp:
					sub_hp += Config.BUFF_LIST[key].sub_hp
		if sub_hp > 0.0:
#			Overall.player_node.hurt_hp(sub_hp,Vector3(0,0,0))
			sub_health(sub_hp)
var green_color := Color("#b442bd69")
var yellow_color := Color("#b4b7c046")
var orange_color := Color("#b4c08d46")
var red_color := Color("#b4c04646")
var black_color := Color("#b4353535")
var black_color_frame := Color("#2e2e2e")
var white_color_frame := Color("#e1e1e1")
onready var pos2s := {
	"head":$hp/head.position,
	"body":$hp/body.position,
	"arm_left":$hp/arm_left.position,
	"arm_right":$hp/arm_right.position,
	"leg_left":$hp/leg_left.position,
	"leg_right":$hp/leg_right.position,
	"foot_left":$hp/foot_left.position,
	"foot_right":$hp/foot_right.position,
}
func set_hp(val:float,body:String) -> void:
	
	var tween = $hp/tween
	var sprite = get_node("hp/"+body)
	var pos2 = pos2s[body]
	var be = 1.0
	for i in 4:
		var offset = i*0.5
		
		tween.interpolate_property(sprite, "position",
				pos2, pos2+Vector2(be,be), 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,offset)
		tween.interpolate_property(sprite, "position",
				pos2+Vector2(be,be), pos2+Vector2(-be,-be), 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,0.1+offset)
		tween.interpolate_property(sprite, "position",
				pos2+Vector2(-be,-be), pos2+Vector2(-be,be), 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,0.2+offset)
		tween.interpolate_property(sprite, "position",
				pos2+Vector2(-be,be), pos2+Vector2(be,-be), 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,0.3+offset)
		tween.interpolate_property(sprite, "position",
				pos2+Vector2(be,-be), pos2, 0.1,
				Tween.TRANS_SINE , Tween.EASE_OUT,0.4+offset)
				
	tween.interpolate_property(sprite, "self_modulate",
			black_color_frame, white_color_frame, 0.1,
			Tween.TRANS_SINE , Tween.EASE_OUT,0)
	tween.interpolate_property(sprite, "self_modulate",
			white_color_frame, black_color_frame, 0.1,
			Tween.TRANS_SINE , Tween.EASE_OUT,0.1)
	tween.interpolate_property(sprite, "self_modulate",
			black_color_frame, white_color_frame, 0.1,
			Tween.TRANS_SINE , Tween.EASE_OUT,0.2)
	tween.interpolate_property(sprite, "self_modulate",
			white_color_frame, black_color_frame, 0.1,
			Tween.TRANS_SINE , Tween.EASE_OUT,0.3)
	tween.interpolate_property(sprite, "self_modulate",
			black_color_frame, white_color_frame, 0.1,
			Tween.TRANS_SINE , Tween.EASE_OUT,0.4)
	tween.interpolate_property(sprite, "self_modulate",
			white_color_frame, black_color_frame, 0.1,
			Tween.TRANS_SINE , Tween.EASE_OUT,0.5)
	tween.start()
	var sprite_c = get_node("hp/"+body+"/sprite")
	var hp = status[body]
	if body == "body":
		
		if hp > 0:
			sprite_c.modulate = red_color
			if hp > 1:
				sprite_c.modulate = orange_color
				if hp > 2:
					sprite_c.modulate = yellow_color
					if hp > 3:
						sprite_c.modulate = green_color

		else:
			sprite_c.modulate = black_color
	else:

		if hp > 0:
			sprite_c.modulate = red_color
			if hp > 1:
				sprite_c.modulate = orange_color
				if hp > 2:
					sprite_c.modulate = green_color

		else:
			sprite_c.modulate = black_color
func set_health(val:float,sub:float) -> void:
	var tween = $health/Tween
	var pos2 = $health/Sprite.rect_position
	var sprite = $health/Sprite
	sub *= -1
	var be = 1+sub*1
	var time = 0.5+sub*0.2
	var num = ceil(sub/4)
	var alpha =  0.8-sub*0.2
	if alpha <0.0:alpha = 0.0
	tween.interpolate_property($health, "value",
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

	tween.interpolate_property($hp, "modulate",
			Color(1,1,1,1), Color(1,1,1,alpha), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT)
	tween.interpolate_property($hp, "modulate",
			Color(1,1,1,alpha), Color(1,1,1,1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.1)
	tween.interpolate_property($hp, "modulate",
			Color(1,1,1,1), Color(1,1,1,alpha+0.1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.2)
	tween.interpolate_property($hp, "modulate",
			Color(1,1,1,alpha+0.1), Color(1,1,1,1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.3)
	tween.start()

func set_satiety(val:float,sub:float) -> void:
	var tween = $satiety/Tween
	var pos2 = $satiety/Sprite.rect_position
	var sprite = $satiety/Sprite
	sub *= -1
	var be = 1+sub*1
	var time = 0.5+sub*0.2
	var num = ceil(sub/4)
	var alpha =  0.8-sub*0.2
	if alpha <0.0:alpha = 0.0
	tween.interpolate_property($satiety, "value",
			val+sub, val, 0.5,
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
	tween.interpolate_property($satiety, "modulate",
			Color(1,1,1,1), Color(1,1,1,alpha), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT)
	tween.interpolate_property($satiety, "modulate",
			Color(1,1,1,alpha), Color(1,1,1,1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.1)
	tween.interpolate_property($satiety, "modulate",
			Color(1,1,1,1), Color(1,1,1,alpha+0.1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.2)
	tween.interpolate_property($satiety, "modulate",
			Color(1,1,1,alpha+0.1), Color(1,1,1,1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.3)
	tween.start()
func set_thirst(val:float,sub:float) -> void:
#	$thirst.value = val
	var tween = $thirst/Tween
	var pos2 = $thirst/Sprite.rect_position
	var sprite = $thirst/Sprite
	sub *= -1
	var be = 1+sub*1
	var time = 0.5+sub*0.2
	var num = ceil(sub/4)
	var alpha =  0.8-sub*0.2
	if alpha <0.0:alpha = 0.0
	tween.interpolate_property($thirst, "value",
			val+sub, val, 0.5,
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
	tween.interpolate_property($thirst, "modulate",
			Color(1,1,1,1), Color(1,1,1,alpha), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT)
	tween.interpolate_property($thirst, "modulate",
			Color(1,1,1,alpha), Color(1,1,1,1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.1)
	tween.interpolate_property($thirst, "modulate",
			Color(1,1,1,1), Color(1,1,1,alpha+0.1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.2)
	tween.interpolate_property($thirst, "modulate",
			Color(1,1,1,alpha+0.1), Color(1,1,1,1), 0.1,
			Tween.TRANS_LINEAR , Tween.EASE_OUT,0.3)
	tween.start()
func set_health_max(val:float) -> void:
	$health.max_value = val
	status.health_max = val
func set_satiety_max(val:float) -> void:
	$satiety.max_value = val
	status.satiety_max = val
func set_thirst_max(val:float) -> void:
	$thirst.max_value = val
	status.thirst_max = val
func _on_new_life() -> void:
	status.health = status.health_max
	status.satiety = status.satiety_max
	status.thirst = status.thirst_max
	status.protein = status.protein_max
	status.phytonutrients = status.phytonutrients_max
	status.ir = 0.0
	add_hp(status.head_max,"head")
	add_hp(status.body_max,"body")
	add_hp(status.arm_left_max,"arm_left")
	add_hp(status.arm_right_max,"arm_right")
	add_hp(status.leg_left_max,"leg_left")
	add_hp(status.leg_right_max,"leg_right")
	add_hp(status.foot_left_max,"foot_left")
	add_hp(status.foot_right_max,"foot_right")
	set_health(status.health,0.0)
	set_satiety(status.satiety,0.0)
	set_thirst(status.thirst,0.0)
	$nutrition.set_val("protein",status.protein,0.0)
	$nutrition.set_val("phytonutrients",status.phytonutrients,0.0)
	$nutrition.set_val("ir",status.ir,0.0)
	$buff.clear_buff()
	

func _unhandled_input(event:InputEvent) -> void:
	if event.is_action_pressed("c"):
		$nutrition.visible = !$nutrition.visible
		$buff.visible = $nutrition.visible


func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
#	position.x += diff_size.x
#	position.y = window_size.y-Config.window_size.y

	$health.rect_position.y = window_size.y-35 - 90
	$satiety.rect_position.y = window_size.y-35 - 45
	$thirst.rect_position.y = window_size.y-35

	$nutrition._on_screen(window_size,diff_size)
	$buff._on_screen(window_size,diff_size)
	
