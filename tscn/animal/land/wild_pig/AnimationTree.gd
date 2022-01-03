extends AnimationTree
func _ready() -> void:
	active = true
	process_mode = AnimationTree.ANIMATION_PROCESS_IDLE
	
func update_ani(state:String) -> void:
	if state == "default":
		pass

	if state == "dead":
		pass
			
	if state == "eat_start":
		self["parameters/eat_start/active"] = true
		yield(get_tree().create_timer(0.3),"timeout")
		self["parameters/eating/blend_amount"] = 1.0
		
	if state == "eating":
		yield(get_tree().create_timer(0.3),"timeout")
		self["parameters/eating/blend_amount"] = 1.0
	
	if state == "eat_end":
		self["parameters/eat_end/active"] = true
		yield(get_tree().create_timer(0.3),"timeout")
		self["parameters/eating/blend_amount"] = 0.0
	
	
	
func play(name_:String,active:=true) ->void:
	self["parameters/"+name_+"/active"] = active

func walk(num:float) -> void:
	self["parameters/run/blend_amount"] = 0.0
	self["parameters/walk/blend_amount"] = num
	

func run(num:float) -> void:
	self["parameters/walk/blend_amount"] = 0.0
	self["parameters/run/blend_amount"] = num


func dead() -> void:
	for i in range(11):
		yield(get_tree(),"idle_frame")
		yield(get_tree(),"idle_frame")
		yield(get_tree(),"idle_frame")
		self["parameters/dead/blend_amount"] = i*0.1
	
func ani_init() -> void:
	
	self["parameters/walk/blend_amount"] = 0.0
	self["parameters/run/blend_amount"] = 0.0
	
	self["parameters/dead/blend_amount"] = 0.0
	self["parameters/eating/blend_amount"] = 0.0
