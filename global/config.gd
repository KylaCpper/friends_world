extends Node
var languages := ["en","zh"]
var languages_local := ["english","中文"]
var languages_index := 0
#default 方块
var tile_size := 16
var block_png := "res://assets/img/block/block.png"
var block_json := "res://assets/img/block/block_order.json"
var atlas_size := 5
# ying yang
const SATIETY_TIME := 150.0
const THIRST_TIME := 150.0
const PROTEIN_TIME := 180.0
const PHYTONUTRIENTS_TIME := 100.0
const IR_TIME := 200.0
var data := {}
# buff time
#move absorb deplete_time atk hand_speed nutrition_absorb nutrition_deplete_time sub_hp
var BUFF_LIST := {
	"malnutrition":{"time":999,"move":0.8,"img":preload("res://assets/img/ui/status/buff/malnutrition.png")},
	"diabetes_mild":{"time":999,"deplete_time":1.2,"img":preload("res://assets/img/ui/status/buff/diabetes_mild.png")},
	"diabetes_moderate":{"time":999,"deplete_time":1.35,"img":preload("res://assets/img/ui/status/buff/diabetes_moderate.png")},
	"diabetes_severe":{"time":999,"deplete_time":1.5,"img":preload("res://assets/img/ui/status/buff/diabetes_severe.png")},
	
	"stomach_injuried":{"time":999,"move":0.8,"absorb":0.5,"deplete_time":1.5,"sub_hp":0.2,"img":preload("res://assets/img/ui/status/buff/stomach_injuried.png")},
	"arm_left_injuried":{"time":999,"sub_hp":0.1,"img":preload("res://assets/img/ui/status/buff/arm_left_injuried.png")},
	"arm_right_injuried":{"time":999,"sub_hp":0.1,"hand_speed":0.7,"img":preload("res://assets/img/ui/status/buff/arm_right_injuried.png")},
	"leg_left_injuried":{"time":999,"sub_hp":0.1,"move":0.8,"img":preload("res://assets/img/ui/status/buff/leg_injuried.png")},
	"leg_right_injuried":{"time":999,"sub_hp":0.1,"move":0.8,"img":preload("res://assets/img/ui/status/buff/leg_injuried.png")},
	"foot_left_injuried":{"time":999,"sub_hp":0.1,"move":0.9,"img":preload("res://assets/img/ui/status/buff/foot_injuried.png")},
	"foot_right_injuried":{"time":999,"sub_hp":0.1,"move":0.9,"img":preload("res://assets/img/ui/status/buff/foot_injuried.png")},
	
}
#


var gravity := 9.8
#
const ADAPTATION := true
#
var view_dis := 200
#
const ITEM_PATH := "res://assets/img/item/"
const MODEL_PATH := "res://assets/model/"
#
const COMPOSITE_TIME := 0.5
#
const PRESS_TIME := 0.2
const RELEASE_TIME := 0.15
#
const VEC_ORDER := [
	Vector3(1,0,0),Vector3(-1,0,0),
	Vector3(0,0,1),Vector3(0,0,-1),
	Vector3(0,1,0),
	Vector3(1,1,0),Vector3(-1,1,0),
	Vector3(0,-1,0),
	Vector3(0,1,1),Vector3(0,1,-1),
	Vector3(1,-1,0),Vector3(-1,-1,0),
	Vector3(0,-1,1),Vector3(0,-1,-1),
]
const VEC_ORDER2 := [
	Vector3(0,1,0),Vector3(0,-1,0),
	Vector3(1,0,0),Vector3(-1,0,0),
	Vector3(0,0,1),Vector3(0,0,-1),
]
const VEC_ORDER3 := [
	Vector3(0,-1,0),
	Vector3(1,0,0),Vector3(-1,0,0),
	Vector3(0,0,1),Vector3(0,0,-1),
]
const VEC_ORDER4 := [
	Vector3(0,0,-1),Vector3(1,0,0),Vector3(0,0,1),Vector3(-1,0,0)
]
const DIRE_ORDER := [
	"VEC_ORDER_DOWN",
	"VEC_ORDER_LEFT1","VEC_ORDER_LEFT2","VEC_ORDER_LEFT3","VEC_ORDER_LEFT4",
	"VEC_ORDER_RIGHT1","VEC_ORDER_RIGHT2","VEC_ORDER_RIGHT3","VEC_ORDER_RIGHT4",
	"VEC_ORDER_FORWARD1","VEC_ORDER_FORWARD2","VEC_ORDER_FORWARD3","VEC_ORDER_FORWARD4",
	"VEC_ORDER_BACK1","VEC_ORDER_BACK2","VEC_ORDER_BACK3","VEC_ORDER_BACK4",
	"VEC_ORDER_LEFT1_FORWARD1","VEC_ORDER_LEFT2_FORWARD1","VEC_ORDER_LEFT2_FORWARD2","VEC_ORDER_LEFT3_FORWARD1",
	"VEC_ORDER_FORWARD1_LEFT1","VEC_ORDER_FORWARD2_LEFT1","VEC_ORDER_FORWARD2_LEFT2","VEC_ORDER_FORWARD3_LEFT1",
	"VEC_ORDER_RIGHT1_FORWARD1","VEC_ORDER_RIGHT2_FORWARD1","VEC_ORDER_RIGHT2_FORWARD2","VEC_ORDER_RIGHT3_FORWARD1",
	"VEC_ORDER_FORWARD1_RIGHT1","VEC_ORDER_FORWARD2_RIGHT1","VEC_ORDER_FORWARD2_RIGHT2","VEC_ORDER_FORWARD3_RIGHT1",
	"VEC_ORDER_LEFT1_BACK1","VEC_ORDER_LEFT2_BACK1","VEC_ORDER_LEFT2_BACK2","VEC_ORDER_LEFT3_BACK1",
	"VEC_ORDER_BACK1_LEFT1","VEC_ORDER_BACK2_LEFT1","VEC_ORDER_BACK2_LEFT2","VEC_ORDER_BACK3_LEFT1",
	"VEC_ORDER_RIGHT1_BACK1","VEC_ORDER_RIGHT2_BACK1","VEC_ORDER_RIGHT2_BACK2","VEC_ORDER_RIGHT3_BACK1",
	"VEC_ORDER_BACK1_RIGHT1","VEC_ORDER_BACK2_RIGHT1","VEC_ORDER_BACK2_RIGHT2","VEC_ORDER_BACK3_RIGHT1"
	
]
const VEC_ORDER_LEFT1 := [Vector3(-1,0,0),Vector3(-1,-1,0),Vector3(-1,-2,0),Vector3(-1,-3,0),Vector3(-1,-4,0),Vector3(-1,-5,0)]
const VEC_ORDER_LEFT2 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-2,-1,0),Vector3(-2,-2,0),Vector3(-2,-3,0),Vector3(-2,-4,0),Vector3(-2,-5,0),Vector3(-2,-6,0)]
const VEC_ORDER_LEFT3 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-3,0,0),Vector3(-3,-1,0),Vector3(-3,-2,0),Vector3(-3,-3,0),Vector3(-3,-4,0),Vector3(-3,-5,0),Vector3(-3,-6,0),Vector3(-3,-7,0)]
const VEC_ORDER_LEFT4 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-3,0,0),Vector3(-4,0,0),Vector3(-4,-1,0),Vector3(-4,-2,0),Vector3(-4,-3,0),Vector3(-4,-4,0),Vector3(-4,-5,0),Vector3(-4,-6,0),Vector3(-4,-7,0),Vector3(-4,-8,0)]

const VEC_ORDER_RIGHT1 := [Vector3(1,0,0),Vector3(1,-1,0),Vector3(1,-2,0),Vector3(1,-3,0),Vector3(1,-4,0),Vector3(1,-5,0)]
const VEC_ORDER_RIGHT2 := [Vector3(1,0,0),Vector3(2,0,0),Vector3(2,-1,0),Vector3(2,-2,0),Vector3(2,-3,0),Vector3(2,-4,0),Vector3(2,-5,0),Vector3(2,-6,0)]
const VEC_ORDER_RIGHT3 := [Vector3(1,0,0),Vector3(2,0,0),Vector3(3,0,0),Vector3(3,-1,0),Vector3(3,-2,0),Vector3(3,-3,0),Vector3(3,-4,0),Vector3(3,-5,0),Vector3(3,-6,0),Vector3(3,-7,0)]
const VEC_ORDER_RIGHT4 := [Vector3(1,0,0),Vector3(2,0,0),Vector3(3,0,0),Vector3(4,0,0),Vector3(4,-1,0),Vector3(4,-2,0),Vector3(4,-3,0),Vector3(4,-4,0),Vector3(4,-5,0),Vector3(4,-6,0),Vector3(4,-7,0),Vector3(4,-8,0)]

const VEC_ORDER_FORWARD1 := [Vector3(0,0,1),Vector3(0,-1,1),Vector3(0,-2,1),Vector3(0,-3,1),Vector3(0,-4,1),Vector3(0,-5,1)]
const VEC_ORDER_FORWARD2 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(0,-1,2),Vector3(0,-2,2),Vector3(0,-3,2),Vector3(0,-4,2),Vector3(0,-5,2),Vector3(0,-6,2)]
const VEC_ORDER_FORWARD3 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(0,0,3),Vector3(0,-1,3),Vector3(0,-2,3),Vector3(0,-3,3),Vector3(0,-4,3),Vector3(0,-5,3),Vector3(0,-6,3),Vector3(0,-7,3)]
const VEC_ORDER_FORWARD4 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(0,0,3),Vector3(0,0,4),Vector3(0,-1,4),Vector3(0,-2,4),Vector3(0,-3,4),Vector3(0,-4,4),Vector3(0,-5,4),Vector3(0,-6,4),Vector3(0,-7,4),Vector3(0,-8,4)]

const VEC_ORDER_BACK1 := [Vector3(0,0,-1),Vector3(0,-1,-1),Vector3(0,-2,-1),Vector3(0,-3,-1),Vector3(0,-4,-1),Vector3(0,-5,-1)]
const VEC_ORDER_BACK2 := [Vector3(0,0,-1),Vector3(0,0,-2),Vector3(0,-1,-2),Vector3(0,-2,-2),Vector3(0,-3,-2),Vector3(0,-4,-2),Vector3(0,-5,-2),Vector3(0,-6,-2)]
const VEC_ORDER_BACK3 := [Vector3(0,0,-1),Vector3(0,0,-2),Vector3(0,0,-3),Vector3(0,-1,-3),Vector3(0,-2,-3),Vector3(0,-3,-3),Vector3(0,-4,-3),Vector3(0,-5,-3),Vector3(0,-6,-3),Vector3(0,-7,-3)]
const VEC_ORDER_BACK4 := [Vector3(0,0,-1),Vector3(0,0,-2),Vector3(0,0,-3),Vector3(0,0,-4),Vector3(0,-1,-4),Vector3(0,-2,-4),Vector3(0,-3,-4),Vector3(0,-4,-4),Vector3(0,-5,-4),Vector3(0,-6,-4),Vector3(0,-7,-4),Vector3(0,-8,-4)]

const VEC_ORDER_LEFT1_FORWARD1 := [Vector3(-1,0,0),Vector3(-1,0,1),Vector3(-1,-1,1),Vector3(-1,-2,1),Vector3(-1,-3,1),Vector3(-1,-4,1),Vector3(-1,-5,1),Vector3(-1,-6,1)]
const VEC_ORDER_LEFT2_FORWARD1 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-2,0,1),Vector3(-2,-1,1),Vector3(-2,-2,1),Vector3(-2,-3,1),Vector3(-2,-4,1),Vector3(-2,-5,1),Vector3(-2,-6,1),Vector3(-2,-7,1)]
const VEC_ORDER_LEFT3_FORWARD1 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-3,0,0),Vector3(-3,0,1),Vector3(-3,-1,1),Vector3(-3,-2,1),Vector3(-3,-3,1),Vector3(-3,-4,1),Vector3(-3,-5,1),Vector3(-3,-6,1),Vector3(-3,-7,1),Vector3(-3,-8,1)]
const VEC_ORDER_LEFT2_FORWARD2 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-2,0,1),Vector3(-2,0,2),Vector3(-2,-1,2),Vector3(-2,-2,2),Vector3(-2,-3,2),Vector3(-2,-4,2),Vector3(-2,-5,2),Vector3(-2,-6,2),Vector3(-2,-7,2),Vector3(-2,-8,2)]
#const VEC_ORDER_LEFT3_FORWARD1 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-3,0,0),Vector3(-3,0,1),Vector3(-3,-1,1),Vector3(-3,-2,1),Vector3(-3,-3,1),Vector3(-3,-4,1),Vector3(-3,-5,1),Vector3(-3,-6,1),Vector3(-3,-7,1),Vector3(-3,-8,1)]

const VEC_ORDER_FORWARD1_LEFT1 := [Vector3(0,0,1),Vector3(-1,0,1),Vector3(-1,-1,1),Vector3(-1,-2,1),Vector3(-1,-3,1),Vector3(-1,-4,1),Vector3(-1,-5,1),Vector3(-1,-6,1)]
const VEC_ORDER_FORWARD2_LEFT1 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(-1,0,2),Vector3(-1,-1,2),Vector3(-1,-2,2),Vector3(-1,-3,2),Vector3(-1,-4,2),Vector3(-1,-5,2),Vector3(-1,-6,2),Vector3(-1,-7,2)]
const VEC_ORDER_FORWARD3_LEFT1 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(0,0,3),Vector3(-1,0,3),Vector3(-1,-1,3),Vector3(-1,-2,3),Vector3(-1,-3,3),Vector3(-1,-4,3),Vector3(-1,-5,3),Vector3(-1,-6,3),Vector3(-1,-7,3),Vector3(-1,-8,3)]
const VEC_ORDER_FORWARD2_LEFT2 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(-1,0,2),Vector3(-2,0,2),Vector3(-2,-1,2),Vector3(-2,-2,2),Vector3(-2,-3,2),Vector3(-2,-4,2),Vector3(-2,-5,2),Vector3(-2,-6,2),Vector3(-2,-7,2),Vector3(-2,-8,2)]
#const VEC_ORDER_FORWARD3_LEFT1 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(0,0,3),Vector3(-1,0,3),Vector3(-1,-1,3),Vector3(-1,-2,3),Vector3(-1,-3,3),Vector3(-1,-4,3),Vector3(-1,-5,3),Vector3(-1,-6,3),Vector3(-1,-7,3),Vector3(-1,-8,3)]

const VEC_ORDER_RIGHT1_FORWARD1 := [Vector3(1,0,0),Vector3(1,0,1),Vector3(1,-1,1),Vector3(1,-2,1),Vector3(1,-3,1),Vector3(1,-4,1),Vector3(1,-5,1),Vector3(1,-6,1)]
const VEC_ORDER_RIGHT2_FORWARD1 := [Vector3(1,0,0),Vector3(2,0,0),Vector3(2,0,1),Vector3(2,-1,1),Vector3(2,-2,1),Vector3(2,-3,1),Vector3(2,-4,1),Vector3(2,-5,1),Vector3(2,-6,1),Vector3(2,-7,1)]
const VEC_ORDER_RIGHT3_FORWARD1 := [Vector3(1,0,0),Vector3(2,0,0),Vector3(3,0,0),Vector3(3,0,1),Vector3(3,-1,1),Vector3(3,-2,1),Vector3(3,-3,1),Vector3(3,-4,1),Vector3(3,-5,1),Vector3(3,-6,1),Vector3(3,-7,1),Vector3(3,-8,1)]
const VEC_ORDER_RIGHT2_FORWARD2 := [Vector3(1,0,0),Vector3(2,0,0),Vector3(2,0,1),Vector3(2,0,2),Vector3(2,-1,2),Vector3(2,-2,2),Vector3(2,-3,2),Vector3(2,-4,2),Vector3(2,-5,2),Vector3(2,-6,2),Vector3(2,-7,2),Vector3(2,-8,2)]

const VEC_ORDER_FORWARD1_RIGHT1 := [Vector3(0,0,1),Vector3(1,0,1),Vector3(1,-1,1),Vector3(1,-2,1),Vector3(1,-3,1),Vector3(1,-4,1),Vector3(1,-5,1),Vector3(1,-6,1)]
const VEC_ORDER_FORWARD2_RIGHT1 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(1,0,2),Vector3(1,-1,2),Vector3(1,-2,2),Vector3(1,-3,2),Vector3(1,-4,2),Vector3(1,-5,2),Vector3(1,-6,2),Vector3(1,-7,2)]
const VEC_ORDER_FORWARD3_RIGHT1 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(0,0,3),Vector3(1,0,3),Vector3(1,-1,3),Vector3(1,-2,3),Vector3(1,-3,3),Vector3(1,-4,3),Vector3(1,-5,3),Vector3(1,-6,3),Vector3(1,-7,3),Vector3(1,-8,3)]
const VEC_ORDER_FORWARD2_RIGHT2 := [Vector3(0,0,1),Vector3(0,0,2),Vector3(1,0,2),Vector3(2,0,2),Vector3(2,-1,2),Vector3(2,-2,2),Vector3(2,-3,2),Vector3(2,-4,2),Vector3(2,-5,2),Vector3(2,-6,2),Vector3(2,-7,2),Vector3(2,-8,2)]

const VEC_ORDER_LEFT1_BACK1 := [Vector3(-1,0,0),Vector3(-1,0,-1),Vector3(-1,-1,-1),Vector3(-1,-2,-1),Vector3(-1,-3,-1),Vector3(-1,-4,-1),Vector3(-1,-5,-1),Vector3(-1,-6,-1)]
const VEC_ORDER_LEFT2_BACK1 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-2,0,-1),Vector3(-2,-1,-1),Vector3(-2,-2,-1),Vector3(-2,-3,-1),Vector3(-2,-4,-1),Vector3(-2,-5,-1),Vector3(-2,-6,-1),Vector3(-2,-7,-1)]
const VEC_ORDER_LEFT3_BACK1 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-3,0,0),Vector3(-3,0,-1),Vector3(-3,-1,-1),Vector3(-3,-2,-1),Vector3(-3,-3,-1),Vector3(-3,-4,-1),Vector3(-3,-5,-1),Vector3(-3,-6,-1),Vector3(-3,-7,-1),Vector3(-3,-8,-1)]
const VEC_ORDER_LEFT2_BACK2 := [Vector3(-1,0,0),Vector3(-2,0,0),Vector3(-2,0,-1),Vector3(-2,0,-2),Vector3(-2,-1,-2),Vector3(-2,-2,-2),Vector3(-2,-3,-2),Vector3(-2,-4,-2),Vector3(-2,-5,-2),Vector3(-2,-6,-2),Vector3(-2,-7,-2),Vector3(-2,-8,-2)]

const VEC_ORDER_BACK1_LEFT1 := [Vector3(0,0,-1),Vector3(-1,0,-1),Vector3(-1,-1,-1),Vector3(-1,-2,-1),Vector3(-1,-3,-1),Vector3(-1,-4,-1),Vector3(-1,-5,-1),Vector3(-1,-6,-1)]
const VEC_ORDER_BACK2_LEFT1 := [Vector3(0,0,-1),Vector3(0,0,-2),Vector3(-1,0,-2),Vector3(-1,-1,-2),Vector3(-1,-2,-2),Vector3(-1,-3,-2),Vector3(-1,-4,-2),Vector3(-1,-5,-2),Vector3(-1,-6,-2),Vector3(-1,-7,-2)]
const VEC_ORDER_BACK3_LEFT1 := [Vector3(0,0,-1),Vector3(0,0,-2),Vector3(0,0,-3),Vector3(-1,0,-3),Vector3(-1,-1,-3),Vector3(-1,-2,-3),Vector3(-1,-3,-3),Vector3(-1,-4,-3),Vector3(-1,-5,-3),Vector3(-1,-6,-3),Vector3(-1,-7,-3),Vector3(-1,-8,-3)]
const VEC_ORDER_BACK2_LEFT2 := [Vector3(0,0,-1),Vector3(0,0,-2),Vector3(-1,0,-2),Vector3(-2,0,-2),Vector3(-2,-1,-2),Vector3(-2,-2,-2),Vector3(-2,-3,-2),Vector3(-2,-4,-2),Vector3(-2,-5,-2),Vector3(-2,-6,-2),Vector3(-2,-7,-2),Vector3(-2,-8,-2)]

const VEC_ORDER_RIGHT1_BACK1 := [Vector3(1,0,0),Vector3(1,0,-1),Vector3(1,-1,-1),Vector3(1,-2,-1),Vector3(1,-3,-1),Vector3(1,-4,-1),Vector3(1,-5,-1),Vector3(1,-6,-1)]
const VEC_ORDER_RIGHT2_BACK1 := [Vector3(1,0,0),Vector3(2,0,0),Vector3(2,0,-1),Vector3(2,-1,-1),Vector3(2,-2,-1),Vector3(2,-3,-1),Vector3(2,-4,-1),Vector3(2,-5,-1),Vector3(2,-6,-1),Vector3(2,-7,-1)]
const VEC_ORDER_RIGHT3_BACK1 := [Vector3(1,0,0),Vector3(2,0,0),Vector3(3,0,0),Vector3(3,0,-1),Vector3(3,-1,-1),Vector3(3,-2,-1),Vector3(3,-3,-1),Vector3(3,-4,-1),Vector3(3,-5,-1),Vector3(3,-6,-1),Vector3(3,-7,-1),Vector3(3,-8,-1)]
const VEC_ORDER_RIGHT2_BACK2 := [Vector3(1,0,0),Vector3(2,0,0),Vector3(2,0,-1),Vector3(2,0,-2),Vector3(2,-1,-2),Vector3(2,-2,-2),Vector3(2,-3,-2),Vector3(2,-4,-2),Vector3(2,-5,-2),Vector3(2,-6,-2),Vector3(2,-7,-2),Vector3(2,-8,-2)]

const VEC_ORDER_BACK1_RIGHT1 := [Vector3(0,0,-1),Vector3(1,0,-1),Vector3(1,-1,-1),Vector3(1,-2,-1),Vector3(1,-3,-1),Vector3(1,-4,-1),Vector3(1,-5,-1),Vector3(1,-6,-1)]
const VEC_ORDER_BACK2_RIGHT1 := [Vector3(0,0,-1),Vector3(0,0,-2),Vector3(1,0,-2),Vector3(1,-1,-2),Vector3(1,-2,-2),Vector3(1,-3,-2),Vector3(1,-4,-2),Vector3(1,-5,-2),Vector3(1,-6,-2),Vector3(1,-7,-2)]
const VEC_ORDER_BACK3_RIGHT1 := [Vector3(0,0,-1),Vector3(0,0,-2),Vector3(0,0,-3),Vector3(1,0,-3),Vector3(1,-1,-3),Vector3(1,-2,-3),Vector3(1,-3,-3),Vector3(1,-4,-3),Vector3(1,-5,-3),Vector3(1,-6,-3),Vector3(1,-7,-3),Vector3(1,-8,-3)]
const VEC_ORDER_BACK2_RIGHT2 := [Vector3(0,0,-1),Vector3(0,0,-2),Vector3(1,0,-2),Vector3(2,0,-2),Vector3(2,-1,-2),Vector3(2,-2,-2),Vector3(2,-3,-2),Vector3(2,-4,-2),Vector3(2,-5,-2),Vector3(2,-6,-2),Vector3(2,-7,-2),Vector3(2,-8,-2)]

const VEC_ORDER_DOWN:= [Vector3(0,-1,0)]
#
const COLCOR := Color(1,1,1)
const COLCOR2 := Color(1,0.58,0.58)
#每个时代的物品list
const BLOCK_SCRIPT_LIST := [
#	"default",
#	"wood_age",
#	"stone_age"
]
const ITEM_SCRIPT_LIST := [
#	"default",
#	"wood_age",
#	"stone_age",
#	"copper_age"
]
const TOOL_SCRIPT_LIST := [
#	"default",
#	"wood_age",
#	"stone_age"
]
#合成相关 时代
var AGES := {
#	"build_block":[preload("res://assets/img/ui/composite/type/build_block.png"),preload("res://assets/img/ui/composite/type/build_block_disable.png")],
#	"material":[preload("res://assets/img/ui/composite/type/material.png"),preload("res://assets/img/ui/composite/type/material_disable.png")],
#	"wood_age":[preload("res://assets/img/ui/composite/type/wood_age.png"),preload("res://assets/img/ui/composite/type/wood_age_disable.png")],
#	"stone_age":[preload("res://assets/img/ui/composite/type/stone_age.png"),preload("res://assets/img/ui/composite/type/stone_age_disable.png")],
#	"copper_age":[preload("res://assets/img/ui/composite/type/copper_age.png"),preload("res://assets/img/ui/composite/type/copper_age_disable.png")],
#	"nuclear_energy":[preload("res://assets/img/ui/composite/type/nuclear_energy.png"),preload("res://assets/img/ui/composite/type/nuclear_energy_disable.png")]
}



var window_size := Vector2(1024,600)
var window_size_current := Vector2(1024,600)

var __script__ := {}

var grow := preload("res://assets/other/grow.tres")
var blocks_img := {}
var blocks_uv := {}
var block_img :Image
var block_tex :ImageTexture
var m0 := preload("res://tscn/world/terrain0.tres")
var m1 := preload("res://tscn/world/terrain1.tres")
var m2 := preload("res://tscn/world/terrain2.tres")
var m3 := preload("res://tscn/world/terrain3.tres")
var m4 := preload("res://tscn/world/terrain4.tres")
var m5 := preload("res://tscn/world/terrain5.tres")
var m6 := preload("res://tscn/world/terrain6.tres")
var m7 := preload("res://tscn/world/terrain7.tres")
var AGES_ORDER := []
var test := false
func _ready() -> void:
#	if test:return
	block_img = Image.new()
	data = str2var(Function.read_file("res://config/data.mod"))
	AGES = data.age
	BUFF_LIST = data.buff
	
	Composite.furnace = data.furnace
	Composite.anvil = data.anvil
#	print(load("res://assets/img/block/block.png").get_data())
	Composite.data = data.composite
	for key in AGES:
		var d = AGES[key]
		d["name_zh"] = d.name
		d["info_zh"] = d.info
		d.img = load("res:/"+d.img)
		AGES_ORDER.append("")
	for key in AGES:
		AGES_ORDER[AGES[key].index]=key
	for key in BUFF_LIST:
		var d = BUFF_LIST[key]
		d["name_zh"] = d.name
		d["info_zh"] = d.info
		d["img"] = load("res:/"+d.img)
	for key in data.block:
		var d = data.block[key]
		d["name_zh"] = d.name
		d["info_zh"] = d.info
		d.tick = int(d.tick)
		for path in d.uv:
			if !path:
				pass
			else:
				if !path in blocks_img:
					blocks_img[path] = load("res:/"+path)
	for key in data.item:
		var d = data.item[key]
		d["name_zh"] = d.name
		d["info_zh"] = d.info
	for key in data.tool:
		var d = data.tool[key]
		d["name_zh"] = d.name
		d["info_zh"] = d.info
	var atlas = ceil(sqrt(blocks_img.size()))
	block_img.create(atlas*16,atlas*16,false,5)
	var x = 0
	var y = 0
	for key in blocks_img:
		var d = blocks_img[key]
		block_img.blit_rect(d.get_data(), Rect2(0,0,16,16), Vector2(x*16,y*16))
		blocks_uv[key] = Vector2(x, y)
		x = x+1
		if x==atlas:
			x=0
			y=y+1
		
	for key in data.block:
		var b = data.block[key]
		var i = 0
		if b.uv.size()>0:
			var p = b.uv[0]
			for path in b.uv:
				if !path:
					path = p
					if !path:
						path = "/assets/block/default.png"
				b.uv[i] = blocks_uv[path]
				i=i+1
	block_img.save_png("res://assets/img/block/block.png")
	var texture = ImageTexture.new()
	texture.create_from_image(block_img,0)
	
#	var png0 = load("res://assets/img/block/block.png")
#	var png1 = load("res://assets/model/model.png")
	m0.albedo_texture = texture
	m1.albedo_texture = texture
	m2.albedo_texture = texture
#
#	m3.albedo_texture = png1
#	m4.albedo_texture = png1
#	m5.albedo_texture = png1
func set_language(index:int) -> void:
#	if Config.languages_index == index:
#		return
	var name_list = ["name_en","name_zh"]
	var info_list = ["info_en","info_zh"]
	
	for key in data.block:
		if data.block[key][name_list[index]]:
			data.block[key].name = data.block[key][name_list[index]]
		if data.block[key][info_list[index]]:
			data.block[key].info = data.block[key][info_list[index]]
		
	for key in data.item:
		if data.item[key][name_list[index]]:
			data.item[key].name = data.item[key][name_list[index]]
		if data.item[key][info_list[index]]:
			data.item[key].info = data.item[key][info_list[index]]
	for key in data.tool:
		if data.tool[key][name_list[index]]:
			data.tool[key].name = data.tool[key][name_list[index]]
		if data.tool[key][info_list[index]]:
			data.tool[key].info = data.tool[key][info_list[index]]
#	for key in AGES:
#		BUFF_LIST[key].name = AGES[key][name_list[index]]
#		BUFF_LIST[key].info = AGES[key][info_list[index]]
	for key in BUFF_LIST:
		if BUFF_LIST[key][name_list[index]]:
			BUFF_LIST[key].name = BUFF_LIST[key][name_list[index]]
		if BUFF_LIST[key][info_list[index]]:
			BUFF_LIST[key].info = BUFF_LIST[key][info_list[index]]

