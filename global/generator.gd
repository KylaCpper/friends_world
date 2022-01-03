extends Node

const tree_class = preload("res://tscn/world/generator/tree/tree.gd")
var tree :tree_class
var tree_models := []
const apple_tree_class = preload("res://tscn/world/generator/tree/apple_tree.gd")
var apple_tree :apple_tree_class
var apple_tree_models := []
const banana_tree_class = preload("res://tscn/world/generator/tree/banana_tree.gd")
var banana_tree :banana_tree_class
var banana_tree_models := []

const grass_plain_script := preload("res://tscn/world/generator/grass_plain.gd")
var grass_plain :grass_plain_script
const default_script := preload("res://tscn/world/generator/default.gd")
var default :default_script

const coal_ore_script := preload("res://tscn/world/generator/stone/coal_ore.gd")
var coal_ore :coal_ore_script
const copper_ore_script := preload("res://tscn/world/generator/stone/copper_ore.gd")
var copper_ore :copper_ore_script
var copper_ore_moudels := []

var coal_ore_models := []
const plant_script := preload("res://tscn/world/generator/plant/plant.gd")
var plant :plant_script

var list = {}
const voxelgenerator_script := preload("res://tscn/world/generator.gd")
var voxelgenerator :voxelgenerator_script

var copper_height := preload("res://tscn/world/generator/stone/copper_ore.tres")
func _ready() -> void:
	if Config.test:return
	copper_height.bake()
	var rand = RandomNumberGenerator.new()
	rand.seed = 22
	
	tree = tree_class.new()
	for i in range(10):
		var be = tree.generate(rand)
		tree_models.append(be)
	apple_tree = apple_tree_class.new()
	for i in range(3):
		var be = apple_tree.generate(rand)
		apple_tree_models.append(be)
	banana_tree = banana_tree_class.new()
	for i in range(3):
		var be = banana_tree.generate(i)
		banana_tree_models.append(be)
	voxelgenerator = voxelgenerator_script.new()
	
	grass_plain = grass_plain_script.new()
	default = default_script.new()
	
#	coal_ore = coal_ore_script.new()
#	for i in range(7):
#		coal_ore_models.append(coal_ore.generate(rand))
#	copper_ore = copper_ore_script.new()
#	for i in range(7):
#		copper_ore_moudels.append(copper_ore.generate(rand))
		
	plant = plant_script.new()
	



