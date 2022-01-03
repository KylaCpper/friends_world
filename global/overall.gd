extends Node
var arrow_pos_left := Vector2(0,0)
var arrow_angle_left := 0
var arrow_pos_right := Vector2(0,0)
var arrow_angle_right := Vector2(0,0)
var touch_right_index := -1
var press := false
var press_action := "mouse_left"
var phone := false 
#
var cg := true
var pause := false
var gui := false
var cmd := false
#
var cg_scene = 1
#
var terrain_main_node : terrain_main
var test_text
const msg_node_type = preload("res://tscn/ui/gui/msg.gd")
var msg_node:msg_node_type
const anvil_node_type = preload("res://tscn/ui/gui/anvil.gd")
var anvil_node : anvil_node_type
const state_gui_player_node_type = preload("res://tscn/ui/gui/state_gui/player.gd")
var state_gui_player_node :state_gui_player_node_type
const state_gui_node_type = preload("res://tscn/ui/gui/state_gui.gd")
var state_gui_node :state_gui_node_type
const buff_node_type = preload("res://tscn/ui/status/buff.gd")
var buff_node :buff_node_type
const gui_node_node_type = preload("res://tscn/ui/gui/gui_node.gd")
var gui_node_node :gui_node_node_type
const player_node_node_type = preload("res://scene/main/player_node.gd")
var player_node_node :player_node_node_type
const composite_node_type = preload("res://tscn/ui/gui/composite.gd")
var composite_node :composite_node_type
const composite_info_node_type = preload("res://tscn/ui/gui/composite_info.gd")
var composite_info_node :composite_info_node_type
const crack_node_type = preload("res://tscn/block/crack/crack.gd")
var crack_node :crack_node_type
const select_node_type = preload("res://tscn/block/select/select.gd")
var select_node :select_node_type
const terrain_node_node_type = preload("res://scene/main/terrain_node.gd")
var terrain_node_node :terrain_node_node_type
const msg_world_item_node_type = preload("res://tscn/ui/gui/msg_world_item.gd")
var msg_world_item_node :msg_world_item_node_type
var player_node :Player
const photograph_node_type = preload("res://tscn/ui/gui/photograph.gd")
var photograph_node :photograph_node_type
const bar_node_type = preload("res://tscn/ui/gui/bar.gd")
var bar_node :bar_node_type
const bag_node_type = preload("res://tscn/ui/gui/bag.gd")
var bag_node :bag_node_type
const msg_grid_item_node_type = preload("res://tscn//ui/msg_grid_item/msg_grid_item.gd")
var msg_grid_item_node :msg_grid_item_node_type
const msg_pickup_node_type = preload("res://tscn/ui/gui/msg_pickup.gd")
var msg_pickup_node :msg_pickup_node_type
const msg_sound_node_type = preload("res://tscn/ui/gui/msg_sound.gd")
var msg_sound_node :msg_sound_node_type

const entity_node_node_type = preload("res://scene/main/entity_node.gd")
var entity_node_node :entity_node_node_type
const chunks_node_node_type = preload("res://scene/main/chunks_node.gd")
var chunks_node_node :chunks_node_node_type
const pick_item_node_type = preload("res://tscn/ui/gui/pick_item.gd")
var pick_item_node :pick_item_node_type
const msg_big_node_type = preload("res://tscn/ui/msg_big/msg_big.gd")
var msg_big_node :msg_big_node_type
const bg_node_type = preload("res://tscn/ui/gui/bg.gd")
var bg_node :bg_node_type
const composite_table_node_type = preload("res://tscn/ui/gui/composite_table.gd")
var composite_table_node :composite_table_node_type
const audio_node_type = preload("res://tscn/audio/audio.gd")
var audio_node :audio_node_type
const hurt_node_type = preload("res://tscn/ui/hurt/hurt.gd")
var hurt_node : hurt_node_type
const cmd_node_type = preload("res://tscn/ui/cmd/cmd.gd")
var cmd_node : cmd_node_type
const center_node_type = preload("res://tscn/ui/gui/center.gd")
var center_node : center_node_type
const stone_furnace_node_type = preload("res://tscn/ui/gui/stone_furnace.gd")
var stone_furnace_node : stone_furnace_node_type
const stone_blast_furnace_node_type = preload("res://tscn/ui/gui/stone_blast_furnace.gd")
var stone_blast_furnace_node : stone_blast_furnace_node_type

#const status_node_type = preload("res://tscn/ui/status/status.tscn")
var status_node :status_node
const name_node_type = preload("res://tscn/ui/gui/name.gd")
var name_node : name_node_type
var op := false
var technology_expansion = []

var par_num := 0

func _ready() -> void:
	init()
	if OS.get_name() == "Android":
		phone = true
func init() -> void:
	if Overall.is_connected("_process",Item.get("water_wheel").script,"_process"):
		Overall.disconnect("_process",Item.get("water_wheel").script,"_process")
	Overall.cg = true
	Overall.cg_scene = 1
	pause = 0
	Net.init()
	
func item_clear(item:Dictionary) -> void:
	item.name = ""
	item.num = 0
	item.hp = 0
func hand_sub(key:String,val:=1) -> void:
	var hand = Overall.player_node.get_hand()
	item_sub(hand,key,val)
func item_sub(hand:Dictionary,key:String,val:=1) -> void:
	hand[key] -= val
	if hand[key]<=0:
		item_clear(hand)
	Overall.bar_node.update()
func hand_add(key:String,item:Dictionary,val:=1) -> void:
	var hand = Overall.player_node.get_hand()
	item_add(hand,key,item,val)
func item_add(hand:Dictionary,key:String,item:Dictionary,val:=1) -> void:
	hand[key] += val
	if key == "num":
		if hand[key] > item["max"]:
			hand[key] = item["max"]
	if key == "hp":
		if hand[key] > item["hp"]:
			hand[key] = item["hp"]
	Overall.bar_node.update()
func item_switch(item1:Dictionary,item2:Dictionary) -> void:
	var name_ = item2.name
	var num = item2.num
	var hp = item2.hp
	item2.name = item1.name
	item2.num = item1.name
	item2.hp = item1.hp
	item1.name = name_
	item1.num = num
	item1.hp = hp
func item_create() -> Dictionary:
	return {"name":"","num":0,"hp":0}
func give_num(item:Dictionary) -> void:
	if item.mass >= 0.1:
		item["max"] = 99
	if item.mass >= 0.2:
		item["max"] = 64
	if item.mass >= 0.5:
		item["max"] = 32
	if item.mass >= 1.1:
		item["max"] = 16
	if item.mass >= 2.3:
		item["max"] = 8
	if item.mass >= 4.7:
		item["max"] = 4
	if item.mass >= 9.5:
		item["max"] = 2
	if item.mass >= 19.1:
		item["max"] = 1
func rpc_item_script_udp(name_:String,func_name:String,args:Array) -> void:
	if !Net.status:return
	var item = Item.get(name_)
	if item:
		if item.script.has_method(func_name):
			for id in Net.player_info:
				if id != Net.id:
					rpc_unreliable_id(id,"c",name_,func_name,args)
func rpc_item_script(name_:String,func_name:String,args:Array) -> void:
	if !Net.status:return
	var item = Item.get(name_)
	if item:
		if item.script.has_method(func_name):
			for id in Net.player_info:
				if id != Net.id:
					rpc_id(id,"c",name_,func_name,args)
func rpc_item_script_master(name_:String,func_name:String,args:Array) -> void:
	if !Net.status:return
	var item = Item.get(name_)
	if item:
		if item.script.has_method(func_name):
			if Net.id == 1:
				item.script.call(func_name,args)
			else:
				rpc_id(1,"c",name_,func_name,args)
remote func c(name_:String,func_name:String,args:Array) -> void:
	var item = Item.get(name_)
	item.script.call(func_name,args)
signal _process(delta)
func _process(delta:float) -> void:
	emit_signal("_process",delta)
