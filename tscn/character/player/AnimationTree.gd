extends AnimationTree
signal atk

func _ready() -> void:
	active = true
	process_mode = AnimationTree.ANIMATION_PROCESS_PHYSICS
func update_ani(state:String,jump_state:String) -> void:
#	ani_init()
	if state == "default":
		ani_init()
		self["parameters/walk/blend_amount"] = 0.0
	
	if state == "walk":
		self["parameters/walk_speed/scale"] = 1.2
		self["parameters/walk/blend_amount"] = 1.0
	
	
	if state == "walk_back":
		self["parameters/walk/blend_amount"] = 1.0
		self["parameters/walk_speed/scale"] = 0.7

	
	if state == "run":
		self["parameters/walk/blend_amount"] = 1.0
		self["parameters/walk_speed/scale"] = 2
		
	if jump_state == "jump":
		self["parameters/jump/blend_amount"] = 1.0

	if jump_state == "jump_walk":
		self["parameters/jump/blend_amount"] = 0.7
	if jump_state == "no_jump":
		self["parameters/jump/blend_amount"] = 0.0
		
		
	if state == "sit":
		ani_init()
		self["parameters/sit/blend_amount"] = 1.0

		
	if state == "keyboard":
		ani_init()
		self["parameters/keyboard/blend_amount"] = 1.0
		
		

		
	
func play(name_:String,active:=true) ->void:
	self["parameters/"+name_+"/active"] = active
var playing_his = ["",0.0]
func playing(name_:String,val:=0.0) ->void:
	playing_his[0] = name_
	playing_his[1] = val
	self["parameters/"+name_+"/blend_amount"] = val
	
func play_event(speed:float) ->void:
	if self["parameters/eating/blend_amount"] != 0.0:return
	self["parameters/event_speed/scale"] = speed
	self["parameters/event/active"] = true
func play_atk(speed:float) -> void:
	if self["parameters/eating/blend_amount"] != 0.0:return
	if !self["parameters/atk/active"]:
		self["parameters/atk_speed/scale"] = speed
		self["parameters/atk/active"] = true
func ani_init() -> void:
	self["parameters/walk/blend_amount"] = 0.0
	self["parameters/walk_speed/scale"] = 1.2
	
	self["parameters/jump/blend_amount"] = 0.0
	
	self["parameters/keyboard/blend_amount"] = 0.0
	self["parameters/sit/blend_amount"] = 0.0
