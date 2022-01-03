extends Node2D
var is_show := false
var is_slash := false 
var text_his = ""
func _ready() -> void:
#	add_to_group("cmd")
	Overall.cmd_node = self
	$edit.text = ""
	$text.text = ""
	hide()
	$edit.connect("text_entered",self,"_on_enter")
func _on_enter(data:String) -> void:
	text_his = $edit.text
	hide_delty()
	var text = $edit.text
	$edit.text = ""
	if text != "":
		if text[0] == "/":
			cmd(text.substr(1))
		else:
			talk(text)

func _unhandled_input(event) -> void:
	if Overall.cg:return
	if Overall.msg_big_node.visible:return
	if event.is_action_pressed("mouse_left"):
		if is_show:
			hide_delty()
	if event.is_action_pressed("ui_up"):
		$edit.text = ""
		$edit.append_at_cursor(text_his)
	if event.is_action_pressed("enter"):
		if is_show:
			hide_delty()
		else:
			is_slash = false
			is_show = true
			$ani.play("show")
			$edit.text = ""
			$edit.grab_focus()
			Overall.player_node.control = false
			Overall.cmd = true
			Overall.gui_node_node.check_ui()
	if event.is_action_pressed("slash"):
		if !is_show:
			is_slash = true
			is_show = true
			$ani.play("show")
			$edit.text = ""
			$edit.grab_focus()
			$edit.append_at_cursor("/")
			Overall.player_node.control = false
			Overall.cmd = true
			Overall.gui_node_node.check_ui()
			
func cmd(text_:String) -> void:
	var text = text_.split(" ")
	var count = text.size()
	if count >= 1:
		if text[0] == "getpos":
			$text.text += "pos3: "+str(Overall.player_node.translation)+"\n"
		if text[0] == "get":
			if count <= 1:return
			var num = 1
			if count >= 3:
				num = int(text[2])
			Overall.bar_node.change_item(text[1],num)
			if Item.is_in(text[1]):
				$text.text += tr("give_ui") + " " +str(text[1]) + " "+str(num) + "\n"
		if text[0] == "pos":
			if count >= 2:
				Overall.player_node.translation.x = float(text[1])
				$text.text += tr("pos_ui") +" x:"+ str(float(text[1]))
			if count >= 3:
				Overall.player_node.translation.y = float(text[2])
				$text.text += " y:"+ str(float(text[2]))
			if count >= 4:
				Overall.player_node.translation.z = float(text[3])
				$text.text += " z:"+ str(float(text[3]))
			if count >= 2:$text.text += "\n"
			
		if text[0] == "move":
			if count >= 2:
				Overall.player_node.translation.x += float(text[1])
				$text.text += tr("move_ui") +" x:"+ str(float(text[1]))
			if count >= 3:
				Overall.player_node.translation.y += float(text[2])
				$text.text += " y:"+ str(float(text[2]))
			if count >= 4:
				Overall.player_node.translation.z += float(text[3])
				$text.text += " z:"+ str(float(text[3]))
			if count >= 2:$text.text += "\n"
		if text[0] == "op":
			if count == 1:
				Overall.op = !Overall.op
				if Overall.op:
					$text.text += tr("open_op")+"\n"
				else:
					$text.text += tr("close_op")+"\n"
			if count > 1:
				var num = text[1]
				if num == "1":
					Overall.op = true
				if num == "0":
					Overall.op = false
				if Overall.op:
					$text.text += tr("open_op")+"\n"
				else:
					$text.text += tr("close_op")+"\n"
		if text[0] == "add_entity":
			if count > 1:
				var entity = text[1]
				var pos3 = Overall.player_node.get_look_pos(30)
				if pos3:
					if Entity.get_id(entity):
						Overall.entity_node_node.add_entity(entity,pos3)
						$text.text += tr("add_entity")+" "+tr(entity)+"\n"
					else:
						$text.text += tr("invalid_entity")+"\n"
				else:
					$text.text += tr("invalid_pos")+"\n"
func talk(text:String) -> void:
	Overall.player_node.talk(text)
	add_text(text)
func add_text(text:String) -> void:
	if !Overall.cmd: $ani.play("hide")
	$text.text += text + "\n"

func show() -> void:
	if !is_show:
		is_show = true
		$ani.play("show")
		Overall.player_node.control = false
func hide_delty() -> void:
	if is_show:
		is_show = false
		$edit.release_focus()
		$ani.play("hide")
		Overall.player_node.control = true
		Overall.cmd = false
		Overall.gui_node_node.check_ui()
func _on_screen(window_size:Vector2,diff_size:Vector2) -> void:
	$bg.rect_size.x = window_size.x
	$bg.rect_size.y = window_size.y/3
	$bg.rect_position.x = 0
	$bg.rect_position.y = window_size.y-$bg.rect_size.y
	
	$text.rect_size.x = window_size.x - 24
	$text.rect_size.y = $bg.rect_size.y - $edit.rect_size.y
	$text.rect_position.x = 12
	$text.rect_position.y = $bg.rect_position.y + 12
	
	$edit.rect_size.x = window_size.x
	$edit.rect_position.x = 0
	$edit.rect_position.y = window_size.y-$edit.rect_size.y
