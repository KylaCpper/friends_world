extends VoxelMesherBlocky

var cubeid := Voxel.GEOMETRY_CUBE
var obj := preload("res://assets/model/block/block.obj")
var texture := preload("res://assets/img/block/block.png")
var jump := 0
func _init() -> void:
	self.library = VoxelLibrary.new()
	library.bake_tangents = false
#	var be = Function.read_file(Config.block_json)
	var order= Config.data.order
	var size = texture.get_size()
	var x = ceil(size.x/16.0)
	var y = ceil(size.y/16.0)
	if x > y:
		Config.atlas_size = x
	else:
		Config.atlas_size = y
	library.atlas_size = Config.atlas_size
	library.voxel_count = Block.list.size()
	library.create_voxel(0,"air")
	library.get_voxel(0).transparent = true
	var id = 1
	for key in order:
		if jump:
			jump -=1
			continue
		var block = Block.get(key)
		var voxel := library.create_voxel(id,key)
		voxel.geometry_type = cubeid
		if block.aabb:
			voxel.collision_aabbs = [block.aabb]
		voxel.material_id = 0
		
		if block.transparent:
			voxel.transparent = true
			voxel.transparency_index = 99
		else:
			voxel.transparent = false
		if !block.entity:
			if block.liquid:
				voxel.collision_mask = CollisionGroup.VOXEL_LAYER.liquid
			else:
				voxel.collision_mask = CollisionGroup.VOXEL_LAYER.no_entity
		else:
			voxel.collision_mask = CollisionGroup.VOXEL_LAYER.block
		if block.tick:
			voxel.random_tickable = true
		if "material" in block:
			voxel.material_id = block.material
		if block.model:
			voxel.geometry_type = Voxel.GEOMETRY_CUSTOM_MESH
			if block.dire:
				voxel.material_id = 4
				voxel.custom_mesh = load("res://assets/model/null.obj")
				
			else:
				voxel.custom_mesh = block.model
		if block.dire == 3:
			voxel.geometry_type = Voxel.GEOMETRY_CUSTOM_MESH
			voxel.material_id = 4
			voxel.custom_mesh = load("res://assets/model/null.obj")
#			voxel.custom_mesh = null
#			voxel.custom_mesh = null
#		voxel.color = Color(0,0,0)
#		voxel["cube_geometry/padding_y"] = 1
# 在末尾增加可以改变方向方块id
		var uvs = block.uv
		if uvs.size()>0:
			if block.dire == 1:
				#自定义旋转
				if "customize_dire" in block:
					create_dire_id(id+1,key,0,uvs,key+"1")
					create_dire_id(id+2,key,0,uvs,key+"2")
					create_dire_id(id+3,key,0,uvs,key+"3")
					jump += 3
				else:
					create_dire_id(id+1,key,1,uvs)
					create_dire_id(id+2,key,2,uvs)
					create_dire_id(id+3,key,3,uvs)
				id += 3
			if block.dire == 2:
				if "customize_dire" in block:
					create_dire_id(id+1,key,0,uvs,key+"1")
					create_dire_id(id+2,key,0,uvs,key+"2")
					create_dire_id(id+3,key,0,uvs,key+"3")
					create_dire_id(id+4,key,0,uvs,key+"4")
					create_dire_id(id+5,key,0,uvs,key+"5")
					jump += 5
				else:
					create_dire_id(id+1,key,1,uvs)
					create_dire_id(id+2,key,2,uvs)
					create_dire_id(id+3,key,3,uvs)
					create_dire_id(id+4,key,4,uvs)
					create_dire_id(id+5,key,5,uvs)
				id += 5
			if block.dire == 4:
				if "customize_dire" in block:
					create_dire_id(id+1,key,0,uvs,key+"1")
					jump += 1
				else:
					create_dire_id(id+1,key,1,uvs)
				id += 1
			if !block.model:
	#		if typeof(json[key]) == TYPE_DICTIONARY && !block.model:
				voxel["cube_tiles/front"] = uvs[0]
				voxel["cube_tiles/back"] = uvs[1]
				voxel["cube_tiles/left"] = uvs[2]
				voxel["cube_tiles/right"] = uvs[3]
				voxel["cube_tiles/top"] = uvs[4]
				voxel["cube_tiles/bottom"] = uvs[5]
		id += 1
	print(id)

#追加 不同方向的材质
func create_dire_id(id:int,name_:String,add:int,uvs:Array,key:="") -> void:
		var voxel := library.create_voxel(id,name_)
		var block = Block.get(name_)
		voxel.geometry_type = cubeid
		if block.aabb:
			voxel.collision_aabbs = [block.aabb] 
		voxel.material_id = 0
		if block.transparent:
			voxel.transparent = true
			voxel.transparency_index = 1
		else:
			voxel.transparent = false
		if !block.entity:
			if block.liquid:
				voxel.collision_mask = CollisionGroup.VOXEL_LAYER.liquid
			else:
				voxel.collision_mask = CollisionGroup.VOXEL_LAYER.no_entity
		if block.tick:
			voxel.random_tickable = true
		if "material" in block:
			voxel.material_id = block.material

		if block.model:
			voxel.geometry_type = Voxel.GEOMETRY_CUSTOM_MESH
			if block.dire:
				voxel.material_id = 4
				voxel.custom_mesh = load("res://assets/model/null.obj")
			else:
				voxel.custom_mesh = block.model
			
			return
		if block.dire == 3:
			voxel.geometry_type = Voxel.GEOMETRY_CUSTOM_MESH
			voxel.material_id = 4
			voxel.custom_mesh = load("res://assets/model/null.obj")
		if add == 0:
			if key:
				name_ = key
			voxel["cube_tiles/front"] = uvs[0]
			voxel["cube_tiles/back"] = uvs[1]
			voxel["cube_tiles/left"] = uvs[2]
			voxel["cube_tiles/right"] = uvs[3]
			voxel["cube_tiles/top"] = uvs[4]
			voxel["cube_tiles/bottom"] = uvs[5]
		if add == 1:# 转 90 度
			voxel["cube_tiles/front"] = uvs[2]
			voxel["cube_tiles/back"] = uvs[3]
			voxel["cube_tiles/left"] = uvs[1]
			voxel["cube_tiles/right"] = uvs[0]
			voxel["cube_tiles/top"] = uvs[4]
			voxel["cube_tiles/bottom"] = uvs[5]
#			if "up" in json[name_]:
#				voxel["cube_tiles/top"] = Vector2(json[name_].up.x,json[name_].up.y)
#			else:
#				voxel["cube_tiles/top"] = Vector2(json[name_].x,json[name_].y)
#			if "down" in json[name_]:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].down.x,json[name_].down.y)
#			else:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].x,json[name_].y)
#			if "left" in json[name_]:
#				voxel["cube_tiles/front"] = Vector2(json[name_].left.x,json[name_].left.y)
#			else:
#				voxel["cube_tiles/front"] = Vector2(json[name_].x,json[name_].y)
#			if "right" in json[name_]:
#				voxel["cube_tiles/back"] = Vector2(json[name_].right.x,json[name_].right.y)
#			else:
#				voxel["cube_tiles/back"] = Vector2(json[name_].x,json[name_].y)
#			if "forward" in json[name_]:
#				voxel["cube_tiles/right"] = Vector2(json[name_].forward.x,json[name_].forward.y)
#			else:
#				voxel["cube_tiles/right"] = Vector2(json[name_].x,json[name_].y)
#			if "back" in json[name_]:
#				voxel["cube_tiles/left"] = Vector2(json[name_].back.x,json[name_].back.y)
#			else:
#				voxel["cube_tiles/left"] = Vector2(json[name_].x,json[name_].y)

		if add == 2:# 转 180 度
			voxel["cube_tiles/front"] = uvs[1]
			voxel["cube_tiles/back"] = uvs[0]
			voxel["cube_tiles/left"] = uvs[3]
			voxel["cube_tiles/right"] = uvs[2]
			voxel["cube_tiles/top"] = uvs[4]
			voxel["cube_tiles/bottom"] = uvs[5]
#			if "up" in json[name_]:
#				voxel["cube_tiles/top"] = Vector2(json[name_].up.x,json[name_].up.y)
#			else:
#				voxel["cube_tiles/top"] = Vector2(json[name_].x,json[name_].y)
#			if "down" in json[name_]:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].down.x,json[name_].down.y)
#			else:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].x,json[name_].y)
#			if "left" in json[name_]:
#				voxel["cube_tiles/right"] = Vector2(json[name_].left.x,json[name_].left.y)
#			else:
#				voxel["cube_tiles/right"] = Vector2(json[name_].x,json[name_].y)
#			if "right" in json[name_]:
#				voxel["cube_tiles/left"] = Vector2(json[name_].right.x,json[name_].right.y)
#			else:
#				voxel["cube_tiles/left"] = Vector2(json[name_].x,json[name_].y)
#			if "forward" in json[name_]:
#				voxel["cube_tiles/back"] = Vector2(json[name_].forward.x,json[name_].forward.y)
#			else:
#				voxel["cube_tiles/back"] = Vector2(json[name_].x,json[name_].y)
#			if "back" in json[name_]:
#				voxel["cube_tiles/front"] = Vector2(json[name_].back.x,json[name_].back.y)
#			else:
#				voxel["cube_tiles/front"] = Vector2(json[name_].x,json[name_].y)

		if add == 3:# 转 270 度
			voxel["cube_tiles/front"] = uvs[3]
			voxel["cube_tiles/back"] = uvs[2]
			voxel["cube_tiles/left"] = uvs[0]
			voxel["cube_tiles/right"] = uvs[1]
			voxel["cube_tiles/top"] = uvs[4]
			voxel["cube_tiles/bottom"] = uvs[5]
#			if "up" in json[name_]:
#				voxel["cube_tiles/top"] = Vector2(json[name_].up.x,json[name_].up.y)
#			else:
#				voxel["cube_tiles/top"] = Vector2(json[name_].x,json[name_].y)
#			if "down" in json[name_]:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].down.x,json[name_].down.y)
#			else:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].x,json[name_].y)
#			if "left" in json[name_]:
#				voxel["cube_tiles/back"] = Vector2(json[name_].left.x,json[name_].left.y)
#			else:
#				voxel["cube_tiles/back"] = Vector2(json[name_].x,json[name_].y)
#			if "right" in json[name_]:
#				voxel["cube_tiles/front"] = Vector2(json[name_].right.x,json[name_].right.y)
#			else:
#				voxel["cube_tiles/front"] = Vector2(json[name_].x,json[name_].y)
#			if "forward" in json[name_]:
#				voxel["cube_tiles/left"] = Vector2(json[name_].forward.x,json[name_].forward.y)
#			else:
#				voxel["cube_tiles/left"] = Vector2(json[name_].x,json[name_].y)
#			if "back" in json[name_]:
#				voxel["cube_tiles/right"] = Vector2(json[name_].back.x,json[name_].back.y)
#			else:
#				voxel["cube_tiles/right"] = Vector2(json[name_].x,json[name_].y)
#

		if add == 4:# 朝上面
			voxel["cube_tiles/front"] = uvs[4]
			voxel["cube_tiles/back"] = uvs[5]
			voxel["cube_tiles/left"] = uvs[2]
			voxel["cube_tiles/right"] = uvs[3]
			voxel["cube_tiles/top"] = uvs[1]
			voxel["cube_tiles/bottom"] = uvs[0]
#			if "up" in json[name_]:
#				voxel["cube_tiles/front"] = Vector2(json[name_].up.x,json[name_].up.y)
#			else:
#				voxel["cube_tiles/front"] = Vector2(json[name_].x,json[name_].y)
#			if "down" in json[name_]:
#				voxel["cube_tiles/back"] = Vector2(json[name_].down.x,json[name_].down.y)
#			else:
#				voxel["cube_tiles/back"] = Vector2(json[name_].x,json[name_].y)
#			if "left" in json[name_]:
#				voxel["cube_tiles/left"] = Vector2(json[name_].left.x,json[name_].left.y)
#			else:
#				voxel["cube_tiles/left"] = Vector2(json[name_].x,json[name_].y)
#			if "right" in json[name_]:
#				voxel["cube_tiles/right"] = Vector2(json[name_].right.x,json[name_].right.y)
#			else:
#				voxel["cube_tiles/right"] = Vector2(json[name_].x,json[name_].y)
#			if "forward" in json[name_]:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].forward.x,json[name_].forward.y)
#			else:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].x,json[name_].y)
#			if "back" in json[name_]:
#				voxel["cube_tiles/top"] = Vector2(json[name_].back.x,json[name_].back.y)
#			else:
#				voxel["cube_tiles/top"] = Vector2(json[name_].x,json[name_].y)

		if add == 5:# 朝下面
			voxel["cube_tiles/front"] = uvs[5]
			voxel["cube_tiles/back"] = uvs[4]
			voxel["cube_tiles/left"] = uvs[2]
			voxel["cube_tiles/right"] = uvs[3]
			voxel["cube_tiles/top"] = uvs[0]
			voxel["cube_tiles/bottom"] = uvs[1]
#			if "up" in json[name_]:
#				voxel["cube_tiles/back"] = Vector2(json[name_].up.x,json[name_].up.y)
#			else:
#				voxel["cube_tiles/back"] = Vector2(json[name_].x,json[name_].y)
#			if "down" in json[name_]:
#				voxel["cube_tiles/front"] = Vector2(json[name_].down.x,json[name_].down.y)
#			else:
#				voxel["cube_tiles/front"] = Vector2(json[name_].x,json[name_].y)
#			if "left" in json[name_]:
#				voxel["cube_tiles/left"] = Vector2(json[name_].left.x,json[name_].left.y)
#			else:
#				voxel["cube_tiles/left"] = Vector2(json[name_].x,json[name_].y)
#			if "right" in json[name_]:
#				voxel["cube_tiles/right"] = Vector2(json[name_].right.x,json[name_].right.y)
#			else:
#				voxel["cube_tiles/right"] = Vector2(json[name_].x,json[name_].y)
#			if "forward" in json[name_]:
#				voxel["cube_tiles/top"] = Vector2(json[name_].forward.x,json[name_].forward.y)
#			else:
#				voxel["cube_tiles/top"] = Vector2(json[name_].x,json[name_].y)
#			if "back" in json[name_]:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].back.x,json[name_].back.y)
#			else:
#				voxel["cube_tiles/bottom"] = Vector2(json[name_].x,json[name_].y)
#		create_dire_id_(id+1,name_,add+1,json)
