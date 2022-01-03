extends Node
# layer
const MASK = 0x7FFFFFFF
const ALL = 0x7FFFFFFF
const IGNORE_LIQUID = 0x7FFFFFFF - 4
const CAN_PLACE = 0x7FFFFFFF - 2 - 8
const DROP = 1 + 4
const PICK_DROP = 4
enum LAYER{
	terrain = 1
	drop = 2
	player = 4
	gravity = 8
	pick_drop = 16  #特殊
	animal = 32
}
enum VOXEL_LAYER{
	block = 1
	no_entity = 2
	liquid = 4
	
	gravity = 7
	drop = 1
	player = 1
	animal = 1
	ray = 0x7FFFFFFF
}
var block = {
	"layer":LAYER.terrain,
	"mask":LAYER.terrain,
}

var drop = {
	"layer":LAYER.drop,
	"mask":LAYER.terrain + LAYER.drop,
}
var gravity = {
	"layer":LAYER.gravity,
	"mask":LAYER.terrain + LAYER.gravity,
#	"mask":LAYER.terrain,
}
var player = {
	"layer":LAYER.player,
	"mask":LAYER.terrain + LAYER.gravity,
}
var enemy = {
	"layer":0,
	"mask":0,
}
var player_area_drop = {
	"layer":0,
	"mask":LAYER.drop,
}
var player_area_animal = {
	"layer":0,
	"mask":LAYER.animal,
}
var block_ray = {
	"mask":LAYER.terrain + LAYER.drop + LAYER.player,
}
var player_ray = {
	"mask":LAYER.terrain + LAYER.drop + LAYER.animal,
}

var animal = {
	"layer":LAYER.animal,
	"mask":LAYER.terrain + LAYER.gravity,
}

func collision(obj,collision_group:String) -> void:
	if "layer" in self[collision_group]:
		obj.collision_layer = self[collision_group].layer
		obj.collision_mask = self[collision_group].mask
	else:
		obj.collision_mask = self[collision_group].mask
func change_collision(obj,layer:=[],mask:=[])->void:
	for i in range(20):
		obj.set_collision_layer_bit(i,false)
		for ii in layer:
			if (i+1) == ii:
				obj.set_collision_layer_bit(i,true)
		obj.set_collision_mask_bit(i,false)
		for ii in mask:
			if (i+1) == ii:
				obj.set_collision_mask_bit(i,true)
func change_collision_ray(obj,mask:=[])->void:
	for i in range(20):
		obj.set_collision_mask_bit(i,false)
		for ii in mask:
			if (i+1) == ii:
				obj.set_collision_mask_bit(i,true)
