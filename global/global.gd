extends Node

var current_scene = null
var loader = null
var node = null
var node_free = null
var node_loading = null
#是否需要按任意键
var space := false
signal loading_end
signal change_scene
signal space_press


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	connect("loading_end",self,"_on_loading_end")
	set_process_input(false)
func _on_loading_end():
	if space:
		set_process_input(true)
	else:
		emit_signal("change_scene")
#	Input.set_mouse_mode (Input.MOUSE_MODE_HIDDEN)
	
func _input(event):
	if event.is_pressed():
		emit_signal("change_scene")
		self.emit_signal("space_press")
		set_process_input(false)
#无load_scene 直接加载 有load_scene 异步加载 在等待是加载path 无path不加载 
#node异步加载后进的父节点  node_free是过场动画要加载进的父节点,space 按任意键继续
#有node 一定要有node_free
func GoTo_Scene(path,load_scene=null,node=null,node_free=null,space:=false):
	self.space = space
	self.node = node
	self.node_free = node_free
	if load_scene:
		if path:
			call_deferred("GoTo_Scene_Deferred",path)
		loader = ResourceLoader.load_interactive(load_scene)
		set_process(true)
	else:
		call_deferred("GoTo_Scene_Deferred",path)

var time_max=0.5
var pro=0
var noise=null
func _process(delta):
	if loader == null:
		set_process(false)
		return
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max:
		var err = loader.poll()
		if err == ERR_FILE_EOF: # 加载完成
			#切换场景
			emit_signal("loading_end")
			var resource = loader.get_resource()
			loader = null
			if space:
				space=false
				yield(self,"space_press")
			
			
			if !node:
				current_scene.queue_free()
				current_scene = resource.instance()
				get_tree().get_root().add_child(current_scene)
				get_tree().set_current_scene( current_scene )
			else:
				node_free.queue_free()
				var tscn = resource.instance()
				tscn.position = Vector2(0,0)
				node.add_child(tscn)
			pro=0
			
			break
		elif err == OK:
			pro = float(loader.get_stage()) / loader.get_stage_count()*100
		else: # 加载错误
			loader = null
			break
func GoTo_Scene_err(path):
	current_scene.queue_free()
	var scene_be = ResourceLoader.load(path)
	current_scene = scene_be.instance()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene( current_scene )
	current_scene._on_show("server_err")
func GoTo_Scene_Deferred(path):
	if !node:
		current_scene.queue_free()
		var scene_be = ResourceLoader.load(path)
		current_scene = scene_be.instance()
		get_tree().get_root().add_child(current_scene)
		get_tree().set_current_scene( current_scene )
	else:
		var tscn = ResourceLoader.load(path).instance()
		tscn.position = Vector2(0,0)
		node_free.add_child(tscn)
		node_free = tscn
