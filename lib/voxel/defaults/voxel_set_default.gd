extends "res://lib/voxel/src/voxel_set.gd"


var default_color := Color(1,1,1)
var default_colors := {}


# The following will initialize the object as needed
func _load():
	set_tile_size(Config.tile_size)
	set_albedo_texture(load(Config.block_png))
#	var be = Function.read_file(Config.block_json)
	var list = Block.list
	var items = Block.items
#	list = {"default":{"x":0,"y":0},"dirt":{"x":1,"y":0},"grass":{"x":2,"y":0},"grass_dirt":{"x":0,"y":1,"up":{"x":2,"y":0},"down":{"x":1,"y":0}},"stone":{"x":1,"y":1},"wood":{"x":2,"y":1,"up":{"x":0,"y":2},"down":{"x":0,"y":2}},"wood_board":{"x":1,"y":2}}
	
	for key in list:
		if list[key] != "air":
			var item = items[list[key]]
			if item.uv.size()>0:
				var vec2 = item.uv[0]
				var data = {}
				data[Vector3.RIGHT] = item.uv[0]
				data[Vector3.LEFT] = item.uv[1]
				data[Vector3.FORWARD] = item.uv[2]
				data[Vector3.BACK] = item.uv[3]
				data[Vector3.UP] = item.uv[4]
				data[Vector3.DOWN] = item.uv[5]
	#			if "up" in list[key]:
	#				data[Vector3.UP] = Vector2(list[key].up.x,list[key].up.y)
	#			if "down" in list[key]:
	#				data[Vector3.DOWN] = Vector2(list[key].down.x,list[key].down.y)
	#			if "left" in list[key]:
	#				data[Vector3.FORWARD] = Vector2(list[key].left.x,list[key].left.y)
	#			if "right" in list[key]:
	#				data[Vector3.BACK] = Vector2(list[key].right.x,list[key].right.y)
	#			if "forward" in list[key]:
	#				data[Vector3.RIGHT] = Vector2(list[key].forward.x,list[key].forward.y)
	#			if "back" in list[key]:
	#				data[Vector3.LEFT] = Vector2(list[key].back.x,list[key].back.y)
				set_voxel(Voxel_.textured(vec2,data,default_color,default_colors,{"name":key}), list[key])
#	set_voxel(Voxel.textured(Vector2(2, 0)), 'dirt')
#	set_voxel(Voxel.textured(Vector2(3, 0), {
#		Vector3.UP: Vector2(0, 0),
#		Vector3.DOWN: Vector2(2, 0)
#	}, Color.white), 'dirt grass')
#	set_voxel(Voxel.textured(Vector2(4, 0)), 'wooden plank')
#
#	set_voxel(Voxel.textured(Vector2(0, 1)), 'cobblestone')
#	set_voxel(Voxel.textured(Vector2(1, 1)), 'bedrock')
#	set_voxel(Voxel.textured(Vector2(2, 1)), 'sand')
#	set_voxel(Voxel.textured(Vector2(3, 1)), 'gravel')
#	set_voxel(Voxel.textured(Vector2(4, 1)), 'wood')
#
#	set_voxel(Voxel.textured(Vector2(0, 2)), 'diamond ore')
#	set_voxel(Voxel.textured(Vector2(1, 2)), 'restone ore')
#	set_voxel(Voxel.textured(Vector2(2, 2)), 'gold ore')
#	set_voxel(Voxel.textured(Vector2(3, 2)), 'iron ore')
#	set_voxel(Voxel.textured(Vector2(4, 2)), 'charcoal ore')
#
#	set_voxel(Voxel.textured(Vector2(0, 3)), 'obsidian')
#	set_voxel(Voxel.textured(Vector2(1, 3)), 'brick wall')
#	set_voxel(Voxel.textured(Vector2(2, 3), {
#		Vector3.UP: Vector2(3, 3),
#		Vector3.DOWN: Vector2(4, 3)
#	}, Color.white), 'tnt')
#
#	set_voxel(Voxel.textured(Vector2(0, 4)), 'iron block')
#	set_voxel(Voxel.textured(Vector2(1, 4)), 'gold block')
#	set_voxel(Voxel.textured(Vector2(2, 4)), 'diamond block')
#	set_voxel(Voxel.textured(Vector2(3, 4)), 'emerald block')
#	set_voxel(Voxel.textured(Vector2(4, 4)), 'redstone block')
