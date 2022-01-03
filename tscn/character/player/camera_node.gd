extends Spatial
var camera_current = "camera_f"
var camera_self = false
var camera_fov_speed := 1
var mouse_speed := 0.1
var mouse_up_max := 65
var mouse_down_max := 65
var mouse_up_max_first_person := 89
var mouse_down_max_first_person := 89
var camera_for_min := 50
var camera_for_max := 100
#
var place_allow := true
var event_allow := true



var hurt_block_name := "air"
var hurt_block_global_vec3 := Vector3()

var length_f = 3.5
var length_t = 8.6

var hurt_block_particles_small := preload("res://tscn/particle/block/hurt_small.tscn")

onready var camera_t_vec3 = $camera_t.translation
onready var camera_self_vec3 = $camera_self.translation
signal place(world_vec3)
func _ready() -> void:
	$camera_f/ray.add_exception($"../")
	$camera_t/ray.add_exception($"../")

	$"../place_cd".connect("timeout",self,"_on_place_cd_timeout")
	$"../event_cd".connect("timeout",self,"_on_event_cd_timeout")

	$"../".connect("hit",self,"_on_hit")
	
	change_camera("camera_f")
var obj_select = null
var debris_tscn := preload("res://tscn/particle/block/debris.tscn")
func _unhandled_input(event) -> void:
	if Overall.gui:return
	if !$"../".control:return
	var ray = get_node(camera_current+"/ray")
	ray.force_raycast_update()
	var is_select := false
	if ray.is_colliding():
		var obj = ray.get_collider()
		if obj.has_method("_select"):
			is_select = true
			if obj != obj_select:
				if obj_select:
					if is_instance_valid(obj_select):
						obj_select._unselect()
				obj_select = obj
				obj_select._select()
	if !is_select:
		if obj_select:
			if is_instance_valid(obj_select):
				obj_select._unselect()
			obj_select = null
#	if event.is_action_pressed("x"):
#		var debris = debris_tscn.instance()
#		var hand = Overall.player_node.get_hand()
#		debris.name_ = hand.name
#		debris.translation = $camera_f.global_transform.origin
##		debris.set_velocity(Vector3(Function.rand(20)-10,Function.rand(10),Function.rand(20)-10))
#		debris.set_velocity((randf()*2+1.0)*($camera_f/pos3.global_transform.origin - debris.translation))
#		Overall.terrain_node_node.add_child(debris)
	if event.is_action_pressed("f"):
		if time > 0.3:
			time = 0.0
			if event_allow:
				event_allow = false
				$"../event_cd".start()
				if ray.is_colliding():
					var obj = ray.get_collider()
					if obj.has_method("_event"):
						obj._event(ray.get_collision_point()-ray.get_collision_normal())


	if event.is_action_pressed("mouse_right"):
		place_allow = true
		event_allow = true
	if event.is_action_pressed("f5"):
		if camera_current == "camera_t":
			camera_current = "camera_f"
			$"../".camera_current = camera_current
		else:
			camera_current = "camera_t"
			$"../".camera_current = camera_current
		change_camera(camera_current)
	if event.is_action_pressed("f6"):
		camera_self = !camera_self
		if camera_self:
			$camera_self.current = false
			$camera_self.current = true
			$"../player/Skeleton".show()
			$camera_f/hand.hide()
			$camera_f/hand/Armature/Skeleton/arm.hide()
		else:
			$camera_self.current = false
			$"../player/Skeleton".hide()
			$camera_f/hand.show()
			$camera_f/hand/Armature/Skeleton/arm.show()
			change_camera(camera_current)
	
	if Overall.phone:
#		if event is InputEventScreenTouch && !Overall.gui:
#			if Overall.touch_right_index == event.index:
			if Overall.press:
				var _up_max_
				var _down_max_
				if camera_current == "camera_t":
					_up_max_ = mouse_up_max
					_down_max_ = mouse_down_max
				else:
					_up_max_ = mouse_up_max_first_person
					_down_max_ = mouse_down_max_first_person
				var camera_rot = rotation_degrees
				var relative = event.relative
				rotate_x(deg2rad(relative.y * mouse_speed))
				$"../".rotate_y(deg2rad(relative.x * mouse_speed * -1))
				if rotation_degrees.x<-_up_max_||rotation_degrees.x>_down_max_:
					rotation_degrees = camera_rot
				$camera_t_help.translation = camera_t_vec3
				$camera_self_help.translation = camera_self_vec3
				
				if camera_self:
					update_camera_self_vec()
				elif camera_current == "camera_t":
					update_camera_t_vec()
	else:
		if event is InputEventMouseMotion && !Overall.gui:
			var _up_max_
			var _down_max_
			if camera_current == "camera_t":
				_up_max_ = mouse_up_max
				_down_max_ = mouse_down_max
			else:
				_up_max_ = mouse_up_max_first_person
				_down_max_ = mouse_down_max_first_person
			var camera_rot = rotation_degrees
			rotate_x(deg2rad(event.relative.y * mouse_speed))
			$"../".rotate_y(deg2rad(event.relative.x * mouse_speed * -1))
			if rotation_degrees.x<-_up_max_||rotation_degrees.x>_down_max_:
				rotation_degrees = camera_rot
			$camera_t_help.translation = camera_t_vec3
			$camera_self_help.translation = camera_self_vec3
			
			if camera_self:
				update_camera_self_vec()
			elif camera_current == "camera_t":
				update_camera_t_vec()
			

		
		
#	if event.is_action_pressed("mouse_down"):
#		if camera.fov<camera_for_max:
#			camera.fov+=camera_fov_speed
#
#	if event.is_action_pressed("mouse_up"):
#		if camera.fov>camera_for_min:
#			camera.fov-=camera_fov_speed
func update_camera_t_vec() -> void:
	if Overall.cg:return
	for i in range(10,4,-1):
		var vec3 = $camera_t_help.get_global_transform().origin
		if Overall.terrain_node_node.can_place(vec3,0.1):
			break
		else:
			$camera_t_help.translation = camera_t_vec3*i*0.1
		
	$camera_t/Tween.interpolate_property($camera_t, "translation",
		$camera_t.translation, $camera_t_help.translation, 0.3,
		Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	$camera_t/Tween.start()
func update_camera_self_vec() -> void:
	if Overall.cg:return
	for i in range(10,4,-1):
		var vec3 = $camera_self_help.get_global_transform().origin
		if Overall.terrain_node_node.can_place(vec3,0.1):
			break
		else:
			$camera_self_help.translation = camera_self_vec3*i*0.1
	$camera_self/Tween.interpolate_property($camera_self, "translation",
		$camera_self.translation, $camera_self_help.translation, 0.3,
		Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	$camera_self/Tween.start()
func update_camera() -> void:
	get_node(camera_current).current = false
	get_node(camera_current).current = true
func change_camera(mode:String) -> void:
	camera_self = false
	camera_current = mode
	if camera_current == "camera_f":
		$camera_t.current=false
		$camera_f.current=true
		$"../player/Skeleton".hide()
		$camera_f/hand.show()
	else:
		$camera_t.current=true
		$camera_f.current=false
		$"../player/Skeleton".show()
		$camera_f/hand.hide()

	rotation_degrees.x=0
var time := 0.0
var mouse_left_interval := 0.0
var is_atk_ani := true
func _process(delta:float) -> void:
	mouse_left_interval += delta
	if mouse_left_interval > 0.7:
		is_atking = false
	time += delta
	if Overall.gui:
		cancel_food()
		return
	if !$"../".control:return
	if Input.is_action_pressed("mouse_right"):
		mouse_right_event(delta)
		$camera_f/hand.play_event($"../".hand_speed_offset)
		if !eating:
			$"../AnimationTree".play_event($"../".hand_speed_offset)
	else:
		cancel_food()
	if Input.is_action_pressed("mouse_left"):
		mouse_left_interval = 0.0
		is_atking = true
		$camera_f/hand.play_atk($"../".hand_speed_offset)
		if !eating:
			$"../AnimationTree".play_atk($"../".hand_speed_offset)
			Overall.player_node_node.rpc1("play_atk",$"../".hand_speed_offset)
			Overall.state_gui_player_node.play_atk($"../".hand_speed_offset)
	if is_atking:
		mouse_left_event(delta)
	else:
		hurt_block_time = 0
		Overall.crack_node.update_state(0)
	update_look_object_to_msg_world_item()
var hurt_obj = null
func mouse_left_event(delta:float) -> void:
	is_atk_ani = true
	if Overall.cg:return
	var ray = get_node(camera_current+"/ray")
	ray.force_raycast_update()
	var vec3 = null
	var obj = null
	if ray.is_colliding():
		obj = ray.get_collider() 
		vec3 = ray.get_collision_point()-ray.get_collision_normal()/2
	

	
	var pos3 = Overall.terrain_main_node.check(CollisionGroup.IGNORE_LIQUID)
	var be = check_dis(pos3,vec3)
	if be:
		if be != 1:
#			if Function.is_obj(obj):
#				if obj.has_method("_mouse_left"):
#					if obj._mouse_left(vec3):
#						hurt_block_name = "air"
#						hurt_obj = obj
#						is_atk_ani = false
#						return
			hurt_obj = null
			if pos3:
				be = 1
		if be == 1:
			hurt_obj = null
			var pos3_block = Overall.terrain_main_node.get_global_block_pos3(pos3)
			hurt_block(delta,pos3_block)
			is_atk_ani = false
			return
			if Overall.terrain_main_node._mouse_left(pos3):
				hurt_block_name = "air"

				return
			else:
				hurt_block(delta,pos3_block)
				is_atk_ani = false
				return
	clear_crach()

var food_time := 0.0
#var food_time_max := 1.0
var eating := false
func playing_eat() -> void:
	Overall.player_node_node.rpc0("playing_eat")
	$"../".eat_audio()
	$camera_f/hand.play_eat(true)
	for i in range(1,11):
		yield(get_tree(),"idle_frame")
		if eating:
			Overall.player_node.playing("eating",i/10.0)
		else:
			return

func mouse_right_event(delta:float) -> void:
	
	if Overall.cg:return
	var ray = get_node(camera_current+"/ray")
	ray.force_raycast_update()
	var bar_key = Overall.player_node.bar[Overall.player_node.bar_index].name
	var item = Item.get(bar_key)
	
	var pos3 = Overall.terrain_main_node.check(CollisionGroup.IGNORE_LIQUID)

	if item:
		if item.food:
			if item.food[0] >0:
				var food := true
				if item["type"] != "block":
					if pos3: 
						if item.script.has_method("_event"):
							cancel_food()
							food = false
				else:
					if pos3:
						if Overall.terrain_main_node.has_event(pos3):
							food = false
							cancel_food()
				if food:
					if !eating:
						playing_eat()
					eating = true
					food_time += delta
					if food_time > item.food[0]:
						food_time = 0.0
						eat_food(item)
				else:
					cancel_food()
			else:
				cancel_food()
		else:
			cancel_food()
	else:
		cancel_food()
#	if event_allow:
#		event_allow = false
#		$"../event_cd".start()
#		if item:
#			if item["type"] != "block":
#				var is_air := true
#				if pos3: 
#					is_air = false
#				else:
#					pos3=Vector3(0,0,0)
#
#				if item.script.has_method("_event"):
#					if item.script._event(pos3,bar_key,is_air):
#						return
#	var vec3 = null
#	if ray.is_colliding():
#		vec3 = ray.get_collision_point()-ray.get_collision_normal()/2
#	var be = check_dis(pos3,vec3)
#	if be:
#		if be == 1:
#			var shift = Input.is_action_pressed("shift")
#			var is_event = false
#			if !shift:
#				if Overall.terrain_main_node._event(pos3):
#					return
#			var pos3_previous = Overall.terrain_main_node.get_previous_position(CollisionGroup.IGNORE_LIQUID)
#			if pos3_previous:
#				if item:
#					if item.type == "block":
#						place_block(pos3_previous)
#		if be == 2:
#			if ray.is_colliding():
#				var obj = ray.get_collider()
#				if obj.has_method("_event"):
#					if obj._event(vec3):
#						return
#				place_block(vec3)
func _event() -> void:
	if Overall.cg:return
	var vec3 = null
	var ray = get_node(camera_current+"/ray")
	ray.force_raycast_update()
	var bar_key = Overall.player_node.bar[Overall.player_node.bar_index].name
	var item = Item.get(bar_key)
	var pos3 = Overall.terrain_main_node.check(CollisionGroup.IGNORE_LIQUID)
	if ray.is_colliding():
		vec3 = ray.get_collision_point()-ray.get_collision_normal()/2
	var be = check_dis(pos3,vec3)
	if be:
		if be == 1:
			var shift = Input.is_action_pressed("shift")
			var is_event = false
			if !shift:
				if Overall.terrain_main_node._event(pos3):
					return
			var pos3_previous = Overall.terrain_main_node.get_previous_position(CollisionGroup.IGNORE_LIQUID)
			if pos3_previous:
				if item:
					if item.type == "block":
						place_block(pos3_previous)
		if be == 2:
			if ray.is_colliding():
				var obj = ray.get_collider()
				if obj.has_method("_event"):
					if obj._event(vec3):
						return
				place_block(vec3)
				
	
	

	if item:
		if item["type"] != "block":
			var is_air := true
			if pos3: 
				is_air = false
			else:
				pos3=Vector3(0,0,0)
			
			if item.script.has_method("_event"):
				if item.script._event(pos3,bar_key,is_air):
					return


func place_block(vec3:Vector3) -> void:
	if place_allow:
		cancel_food()
		place_allow = false
		emit_signal("place",vec3)
		$"../place_cd".start()
func _on_place_cd_timeout() -> void:
	place_allow = true
func _on_event_cd_timeout() -> void:
	event_allow = true

var hurt_block_time := 0.0
var hurt_block_time_from_particles := 0.0
var hurt_block_time_from_particles_max := 0.3
var speed := 1.0
func set_block_speed(hand_name:="") -> void:
	speed = Block.get_speed(hurt_block_name,hand_name)

func hurt_block(delta:float,pos3:Vector3) -> void:
	if Overall.gui:return
	Overall.status_node.satiety_time+=delta
	Overall.status_node.thirst_time+=delta
#	var ray = get_node(camera_current+"/ray")
#	var vec = ray.get_collision_point()
	var obj = Overall.terrain_main_node
	var name_ = obj.get_name_(pos3)
	var block = Block.get(name_)
	if block:
		if !block.liquid:
			if hurt_block_global_vec3 == pos3:
				hurt_block_time += delta*speed*Overall.player_node.hand_speed_offset
				if Overall.op:
					hurt_block_time *= 10
				hurt_block_time_from_particles += delta
				if hurt_block_time_from_particles >= hurt_block_time_from_particles_max:
					hurt_block_time_from_particles = 0
			else:
				hurt_block_global_vec3 = pos3
				hurt_block_name = obj.get_name_(pos3)
				set_block_speed($"../".bar[$"../".bar_index].name)
				clear_crach()
		else:
			hurt_block_name = "air"
		if hurt_block_name == "air":
			clear_crach()
			hurt_block_global_vec3 = pos3
			return
		Overall.status_node.satiety_time+=delta
		Overall.status_node.thirst_time+=delta
	else:
		hurt_block_name = "air"

var is_atking := false
func _on_hit() -> void:
	if Overall.cg:return
	is_atking = false
	var ray = get_node(camera_current+"/ray")
	ray.force_raycast_update()
	var vec3 = null
	var obj = null
	if ray.is_colliding():
		obj = ray.get_collider() 
		vec3 = ray.get_collision_point()-ray.get_collision_normal()/2
	

	
	var pos3 = Overall.terrain_main_node.check(CollisionGroup.IGNORE_LIQUID)
	var be = check_dis(pos3,vec3)
	if be:
		if be != 1:
			if Function.is_obj(obj):
				if obj.has_method("_mouse_left"):
					if obj._mouse_left(vec3):
						hurt_block_name = "air"
						hurt_obj = obj
						is_atk_ani = false
						return
			hurt_obj = null
			if pos3:
				be = 1
		if be == 1:
			hurt_obj = null
			var pos3_block = Overall.terrain_main_node.get_global_block_pos3(pos3)
			if Overall.terrain_main_node._mouse_left(pos3):
				hurt_block_name = "air"
				return
			else:
				pass
	else:
		hurt_block_name = "air"
		hurt_block_global_vec3 = Vector3()
	if hurt_block_name != "air":
		var block = Block.get(hurt_block_name)
		if block:
			$"../".hurt_block_audio(hurt_block_name)
			create_particles_small(hurt_block_global_vec3)
			if hurt_block_time>block.intensity_dig:
		#			$"../".damage_block_audio(name_)
				damage_block(hurt_block_global_vec3)
			else:
				if hurt_block_time>0:
					Overall.crack_node.sync_pos3(hurt_block_name,hurt_block_global_vec3)
					Overall.crack_node.update_state(hurt_block_time/block.intensity_dig*100)
			return

	if is_atk_ani:
		$"../audio_player".wave()
		Overall.player_node_node.rpc0_udp("wave_audio")
	
func damage_block(pos3:Vector3) -> void:
	if Overall.terrain_main_node.damage(pos3):
		block_damage_drop(hurt_block_global_vec3)
	clear_crach()
func update_look_object_to_msg_world_item() -> void:
	if Overall.cg:return
	var ray = get_node(camera_current+"/ray")
	var key = ""
	var vec3 = null
	if ray.is_colliding():
		var obj = ray.get_collider()
		if Function.is_obj(obj):
			var vec = ray.get_collision_point()-ray.get_collision_normal()/2
			if obj.has_method("get_name_"):
				key = obj.get_name_(vec)
				if obj.has_method("get_global_block_pos3"):
					vec3 = obj.get_global_block_pos3(vec)
	var origin = Overall.player_node.get_camera().get_global_transform().origin
	var forward = Overall.player_node.get_camera().get_global_transform().basis.xform(Vector3(0,0,-1))
	var pos3 = Overall.terrain_main_node.check(CollisionGroup.IGNORE_LIQUID)
	var be = check_dis(pos3,vec3)
	if be:
		if be == 1:
			var pos3_ = Overall.terrain_main_node.get_global_block_pos3(pos3)
			pos3 = pos3_
			key = Overall.terrain_main_node.get_name_(pos3)
		if be == 2:
			pos3 = vec3
	if key&&pos3:
		Overall.select_node.update(key,pos3)
	else:
		Overall.select_node.update("",Vector3(0,0,0))
	Overall.msg_world_item_node.update(key)
func clear_crach() -> void:
	hurt_block_time = 0
	hurt_block_time_from_particles = 0
	Overall.crack_node.update_state(0)

func create_particles_small(pos3_collison:Vector3) -> void:
	Overall.player_node_node.rpc2("create_particles_small",pos3_collison,hurt_block_name)
	for i in range(5):
		var debris = debris_tscn.instance()
		var hand = Overall.player_node.get_hand()
		debris.name_ = hurt_block_name
		debris._scale(0.7)
		debris.translation = pos3_collison+Vector3(randf()-0.5,0.51,randf()-0.5)
		var dire_offset = Vector3((randf()-0.5)*4,1.0,(randf()-0.5)*4)
		debris.set_velocity(dire_offset)
		Overall.terrain_node_node.add_child(debris)
#func create_particles_big(block_world_pos3:Vector3) -> void:
#	var tscn = hurt_block_particles_big.instance()
#	tscn.translation = block_world_pos3
#	tscn.name_ = hurt_block_name
#	Overall.terrain_node_node.add_child(tscn)



func block_damage_drop(block_world_pos3:Vector3) -> void:
	var hand_item = $"../".bar[$"../".bar_index]
	var drop_list = Block.get(hurt_block_name).drop
	var is_use_tool_data = Block.is_use_tool(hurt_block_name,hand_item.name)
	if is_use_tool_data != Block.TOOL_NO:
		var sub_hp = Block.get_wear(hurt_block_name)
		if is_use_tool_data == Block.TOOL_OK:
			var tool_type = Tool.get_tool(hurt_block_name,hand_item.name)
			for drop in drop_list[tool_type]:
				if drop.lv <= Tool.get(hand_item.name).lv:
					var success = Overall.terrain_node_node.create_drop(block_world_pos3,drop)
					if drop.stop && success:break

		if is_use_tool_data == Block.TOOL_LOW:
			sub_hp *= 2
			if "hand" in drop_list:
				if "tool_low" in drop_list:
					for drop in drop_list["tool_low"]:
						var success = Overall.terrain_node_node.create_drop(block_world_pos3,drop)
						if drop.stop && success:break
				else:
					for drop in drop_list["hand"]:
						var success = Overall.terrain_node_node.create_drop(block_world_pos3,drop)
						if drop.stop && success:break
			else:
				if "tool_low" in drop_list:
					for drop in drop_list["tool_low"]:
						var success = Overall.terrain_node_node.create_drop(block_world_pos3,drop)
						if drop.stop && success:break
			
		if hand_item.hp > 0:
			hand_item.hp -= sub_hp
			if hand_item.hp <= 0:
				var tool_item = Item.get(hand_item.name)
				Overall.item_clear(hand_item)
				if create_damage(tool_item):
					Overall.bar_node.select()
			
			Overall.bar_node.update()
	else:
		if "hand" in drop_list:
			for drop in drop_list["hand"]:
				var success = Overall.terrain_node_node.create_drop(block_world_pos3,drop)
				if drop.stop && success:break

func create_damage(tool_item) -> bool:
	var i = 0
	if "damage" in tool_item:
		for drop in tool_item["damage"]:
			if "pro" in drop:
				if Function.rand()<drop.pro:
					if i==0:
						Overall.bar_node.change_item(drop.name,drop.num)
					else:
						Overall.bar_node.add_item({"name":drop.name,"num":drop.num,"hp":0})
			else:
				if i ==0:
					Overall.bar_node.change_item(drop.name,drop.num)
				else:
					Overall.bar_node.add_item({"name":drop.name,"num":drop.num,"hp":0})
			if drop.stop:
				return true
			i+=1
	return false
var eat_food_history := [
	"","",""
]
func eat_food(item:Dictionary) -> void:
	Overall.bar_node.sub_num(Overall.player_node.bar_index,1)
	var key = Overall.player_node.bar[Overall.player_node.bar_index].name
	var pro := 1.0
	var num = 0
	if eat_food_history[0] == key:
		pro *= 0.8
		num +=1
	if eat_food_history[1] == key:
		if eat_food_history[0] == key:
			pro *= 0.8
		else:
			pro *= 0.9
		num +=1
	if eat_food_history[2] == key:
		if eat_food_history[1] == key:
			pro *= 0.8
		else:
			pro *= 0.9
		num +=1
	if num ==1:
		Overall.msg_node.add_msg(tr("eat1"))
	if num == 2:
		Overall.msg_node.add_msg(tr("eat2"))
	if num == 3:
		Overall.msg_node.add_msg(tr("eat3"))
	eat_food_history.remove(eat_food_history.size()-1)
	eat_food_history.push_front(key)
	if item.key in Config.__script__:
		if Config.__script__[item.key].has_method("_eated"):
			if Config.__script__[item.key]._eated():return
	
	if item.food[1]:
		Overall.status_node.add_satiety(float(item.food[1] * pro))
	if item.food[2]:
		Overall.status_node.add_thirst(float(item.food[2]))
	if item.food[4]:
		Overall.status_node.add_protein(float(item.food[4] * pro))
	if item.food[3]:
		Overall.status_node.add_phytonutrients(float(item.food[3] * pro))
	if item.food[5]:
		Overall.status_node.add_ir(float(item.food[5]))
	if item.food[6]:
		if item.food[6]<0:
			Overall.player_node.hurt_hp(float(item.food[6]),Vector3(0,0,0))
		else:
			Overall.status_node.add_health(float(item.food[6]))
	
func cancel_food() -> void:
	if eating:
		$camera_f/hand.play_eat(false)
		Overall.player_node.playing("eating",0.0)
	eating = false
	food_time = 0.0

func check_dis(pos31,pos32) -> int:
	if pos31 && pos32:
		if Overall.player_node.translation.distance_to(pos31) < Overall.player_node.translation.distance_to(pos32):
			return 1
		else:
			return 2
	else:
		if pos31:
			return 1
		elif pos32:
			return 2
		return 0
