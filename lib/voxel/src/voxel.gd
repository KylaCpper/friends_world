
extends Reference
class_name Voxel_


# Schema:
# {
#    color      :   Color        =   Color(0, 0, 0),       #   Main albedo color, typically used when individual albedo colors aren't present
#    colors     :   Dictionary   =   {}, ::                #   Individual albedo colors, used to define an individual albedo color for any and all Voxel faces
#       {
#          Vector3.UP        :   Color     =   null || color,
#          Vector3.DOWN      :   Color     =   null || color,
#          Vector3.RIGHT     :   Color     =   null || color,
#          Vector3.LEFT      :   Color     =   null || color,
#          Vector3.BACK      :   Color     =   null || color,
#          Vector3.FORWARD   :   Color     =   null || color
#       }
#    texture    :   Vector2      =   null,                 #   Main texture position, typically used when individual texture positions and individual albedo colros aren't present
#    textures   :   Dictionary   =   {}, ::                #   Individual texture positions, used to define an individual texture position for any and all Voxel faces
#       {
#          Vector3.UP        :   Vector2   =   null || texture,
#          Vector3.DOWN      :   Vector2   =   null || texture,
#          Vector3.RIGHT     :   Vector2   =   null || texture,
#          Vector3.LEFT      :   Vector2   =   null || texture,
#          Vector3.BACK      :   Vector2   =   null || texture,
#          Vector3.FORWARD   :   Vector2   =   null || texture
#       }
#    data       :   Dictionary   =   {}                    #   Custom data, any and all user defined data should be placed here so as to avoid issues
# }
#
# Example:
# {
#    color      :   Color(0.6, 0.12, 1),
#    colors     :   {
#       Vector3.FORWARD   :   Color(0, 0.33, 0.11),
#       Vector3.DOWN      :   Color(1, 0.6, 0),
#       Vector3.BACK      :   Color(0.13, 0.75, 0.45)
#    },
#    texture    : Vector2(2, 3),
#    textures   :   {
#       Vector.DOWN       :   Vector2(0, 1),
#       Vector.RIGHT      :   Vector2(3, 3)
#    },
#    data       :   {
#       custom            :   3,
#       data              :   'wow'
#    }
# }
#



# Static Declarations
const VoxelScale : float = 1.0                             # Global Voxel scale
const VoxelSize : float = 1.0           # Global actual Voxel size
const GridStep : float = 2.0        # Global distance between Voxels
const GridCorrection : float = 1.0    # Global correction between Voxels; for when and if the grid breaks




# abs_pos    :   Vector3   -   world position to be transformed
# @returns   :   Vector3   -   given world position to snapped position
#
# Example:
#   abs_to_pos(Vector3(20, 0.312, -4.6543))   ->   Vector3(10, 0.25, -2.25)
#
static func abs_to_pos(abs_pos : Vector3) -> Vector3: return (abs_pos / GridStep).floor() * GridStep

# grid       :   Vector3   -   world position to be transformed
# @returns   :   Vector3   -   given world position transformed to grid position
#
# Example:
#   abs_to_grid(Vector3(20, 0.312, -4.6543))   ->   Vector3(20, 1, -4.5)
#
static func abs_to_grid(abs_pos : Vector3) -> Vector3: return pos_to_grid(abs_to_pos(abs_pos))

# pos        :   Vector3   -   snapped position to be transformed
# @returns   :   Vector3   -   given snapped position transformed to grid position
#
# Example:
#   pos_to_grid(Vector3(1, 0, -0.75))   ->   Vector3(2, 0, -0.5)
#
static func pos_to_grid(pos : Vector3) -> Vector3: return pos / GridStep

# grid       :   Vector3   -   snapped position to be corrected
# @returns   :   Vector3   -   given snapped position corrected
#
# Example:
#   pos_correct(Vector3(3, 0, -3))   ->   Vector3(3.5, 0, -3.5)
#
static func pos_correct(pos : Vector3) -> Vector3: return pos + Vector3(GridCorrection, GridCorrection, GridCorrection)

# grid       :   Vector3   -   grid position to be transformed
# @returns   :   Vector3   -   given grid position transformed to snapped position
#
# Example:
#   grid_to_pos(Vector3(3, 0, -3))   ->   Vector3(1, 0, -0.75)
#
static func grid_to_pos(grid : Vector3) -> Vector3: return grid * GridStep

# grid       :   Vector3   -   Vector3 to be clamped
# _min       :   Vector3   -   minimum values
# _max       :   Vector3   -   maximum values
# @returns   :   Vector3   -   Vector3 clamped to given range
#
# Example:
#   vec3_clamp(Vector3(12, -3, -21), Vector3(-6, -3, 5), Vector3(23, -1, 32))   ->   Vector3(12, -3, 5)
#
static func vec3_clamp(vec3 : Vector3, _min : Vector3 = Vector3(), _max : Vector3 = Vector3()) -> Vector3:
	return Vector3(clamp(vec3.x, -_min.x, _max.x - 1), clamp(vec3.y, -_min.y, _max.y - 1), clamp(vec3.z, -_min.z, _max.z - 1))



# position    :   Vector3                                       -   voxel's grid position
# direction   :   Vector3                                       -   direction to check for obstruction
# voxels      :   Dictinary<Vector3, Variant>                   -   voxels used to check for obstruction
# include     :   Array<Vector3>/Dictionary<Vector3, Variant>   -   check if given grid position is contained in collection
#
# Example:
#   is_voxel_obstructed([Vector3], [Vector3], Dictionary<Vector3, Variant>) -> false
#   is_voxel_obstructed([Vector3], [Vector3], Dictionary<Vector3, Variant>, Array<Vector3>) -> true
#
static func is_voxel_obstructed(position : Vector3, direction : Vector3, voxels : Dictionary, include = []) -> bool:
	return include.has(position) or voxels.has(position + direction)

# data       :   Dictionary   -   user defined data
# @returns   :   Dictionary   -   basic Voxel; NOTE: contains only necessary information
#
# Example:
#   basic()          ->   {}
#   basic({})        ->   {}
#   basic({ ... })   ->   { data: { ... } }
#
static func basic(data : Dictionary = {}) -> Dictionary:
	var basic = {}
	
	if not data.empty(): basic['data'] = data
	
	return basic

# voxel      :   Dictionary   -   Voxel to get value from
# @returns   :   Dictionary   -   requested value, if found and valid; else, default value
#
# Example:
#   get_data({ ... })   ->   { ... }
#
static func get_data(voxel : Dictionary) -> Dictionary:
	if typeof(voxel.get('data')) == TYPE_NIL:
		voxel['data'] = {}
	return voxel['data']
#	return voxel['data'] if typeof(voxel.get('data')) == TYPE_DICTIONARY else {}

# voxel   :   Dictionary   -   Voxel to modify
# data    :   Dictionary   -   value to set to given Voxel
#
# Example:
#   set_data({ ... }, { ... })
#
static func set_data(voxel : Dictionary, data : Dictionary) -> void:
	voxel['data'] = data

# color      :   Color                        -   main albedo color used by Voxel
# colors     :   Dictioanry<Vector3, Color>   -   albedo colors to specific sides
# data       :   Dictionary                   -   user defined data
# @returns   :   Dictionary                   -   colored Voxel; NOTE: contains only necessary information
#
# Example:
#   colored([Color])                                                 ->   { 'color': [Color] }
#   colored([Color], { Vector.UP : Color(0.3, 0, 0.66) })            ->   { data: { ... }, 'colors': { Vector.UP : Color(0.3, 0, 0.66) } }
#   colored([Color], { Vector.UP : Color(0.3, 0, 0.66) }, { ... })   ->   { data: { ... }, 'colors': { Vector.UP : Color(0.3, 0, 0.66) }, 'color': [Color] }
#
static func colored(color : Color, colors : Dictionary = {}, data : Dictionary = {}) -> Dictionary:
	var colored = basic(data)
	
	if not color == Color(): set_color(colored, color)
	for side in colors: if typeof(side) == TYPE_VECTOR3 and typeof(colors[side]) == TYPE_COLOR: set_color_side(colored, side, colors[side])
	
	return colored

# voxel      :   Dictionary   -   Voxel to get value from
# @returns   :   Color        -   requested value, if found and valid; else, default value
#
# Example:
#   get_color({ ... })   ->   [Color]
#
static func get_color(voxel : Dictionary) -> Color:
	return voxel['color'] if typeof(voxel.get('color')) == TYPE_COLOR else Color()

# voxel   :   Dictionary   -   Voxel to modify
# color   :   Color        -   value to set to given Voxel
#
# Example:
#   set_color({ ... }, [Color])
#
static func set_color(voxel : Dictionary, color : Color) -> void:
	voxel['color'] = color

# voxel      :   Dictionary   -   Voxel to get value from
# side       :   Vector3      -   normal of face to get from
# @returns   :   Color        -   requested value, if found and valid; else, default value
#
# Example:
#   get_color_side({ ... }, Vector.UP)   ->   [Color]
#
static func get_color_side(voxel : Dictionary, side : Vector3) -> Color:
	return voxel['colors'][side] if typeof(voxel.get('colors')) == TYPE_DICTIONARY and typeof(voxel['colors'].get(side)) == TYPE_COLOR else get_color(voxel)

# voxel      :   Dictionary   -   Voxel to get value from
# @returns   :   Color        -   requested value, if found and valid; else, default value
#
# Example:
#   get_color_right({ ... })   ->   [Color]
#
static func get_color_right(voxel : Dictionary) -> Color: return get_color_side(voxel, Vector3.RIGHT)
static func get_color_left(voxel : Dictionary) -> Color: return get_color_side(voxel, Vector3.LEFT)
static func get_color_up(voxel : Dictionary) -> Color: return get_color_side(voxel, Vector3.UP)
static func get_color_down(voxel : Dictionary) -> Color: return get_color_side(voxel, Vector3.DOWN)
static func get_color_back(voxel : Dictionary) -> Color: return get_color_side(voxel, Vector3.BACK)
static func get_color_forward(voxel : Dictionary) -> Color: return get_color_side(voxel, Vector3.FORWARD)

# voxel   :   Dictionary   -   Voxel to modify
# side    :   Vector3      -   normal of face to set
# color   :   Color        -   value to set to given Voxel side
#
# Example:
#   set_color_side({ ... }, Vector.RIGHT, [Color])
#
static func set_color_side(voxel : Dictionary, side : Vector3, color : Color) -> void:
	if not typeof(voxel.get('colors')) == TYPE_DICTIONARY: voxel['colors'] = {}
	voxel['colors'][side] = color

# voxel   :   Dictionary   -   Voxel to modify
# color   :   Color        -   value to set to Voxel side
#
# Example:
#   set_color_down({ ... }, [Color])
#
static func set_color_right(voxel : Dictionary, color : Color) -> void: set_color_side(voxel, Vector3.RIGHT, color)
static func set_color_left(voxel : Dictionary, color : Color) -> void: set_color_side(voxel, Vector3.LEFT, color)
static func set_color_up(voxel : Dictionary, color : Color) -> void: set_color_side(voxel, Vector3.UP, color)
static func set_color_down(voxel : Dictionary, color : Color) -> void: set_color_side(voxel, Vector3.DOWN, color)
static func set_color_back(voxel : Dictionary, color : Color) -> void: set_color_side(voxel, Vector3.BACK, color)
static func set_color_forward(voxel : Dictionary, color : Color) -> void: set_color_side(voxel, Vector3.FORWARD, color)


# texture_position   :   Vector2                        -   position of main texture
# textures           :   Dictioanry<Vector3, Vector2>   -   texture positions for specific sides
# color              :   Color                          -   main albedo color used by Voxel
# colors             :   Dictioanry<Vector3, Color>     -   albedo colors to specific sides
# data               :   Dictionary                     -   user defined data
# @returns           :   Dictionary                     -   textured Voxel; NOTE: contains only necessary information
#
# Example:
#   textured([Vector2])                                                    ->   { 'color': Color(0, 0, 0), 'texture': [Vector2] }
#   textured([Vector2], { Vector.UP : Vector2(0, 3) }, [Color], { ... })   ->   { 'data': { ... }, 'color': [Color], 'texture': [Vector2], 'textures': { Vector.UP : Vector2(0, 3) } }
#
static func textured(texture_position : Vector2, textures : Dictionary = {}, color : Color = Color.white, colors : Dictionary = {}, data : Dictionary = {}) -> Dictionary:
	var textured = colored(color, colors, data)
	
	set_texture(textured, texture_position)
	for side in textures: if typeof(side) == TYPE_VECTOR3 and typeof(textures[side]) == TYPE_VECTOR2: set_texture_side(textured, side, textures[side])
	
	return textured


static func get_texture(voxel : Dictionary) -> Vector2:
	return voxel['texture'] if typeof(voxel.get('texture')) == TYPE_VECTOR2 else null

static func set_texture(voxel : Dictionary, texture_position : Vector2) -> void:
	voxel['texture'] = texture_position

static func get_texture_side(voxel : Dictionary, side : Vector3) -> Vector2:
	return voxel['textures'][side] if typeof(voxel.get('textures')) == TYPE_DICTIONARY and typeof(voxel['textures'].get(side)) == TYPE_VECTOR2 else get_texture(voxel)
	
	
static func get_texture_right(voxel : Dictionary) -> Vector2:return get_texture_side(voxel, Vector3.RIGHT)

static func get_texture_left(voxel : Dictionary) -> Vector2: return get_texture_side(voxel, Vector3.LEFT)
	
static func get_texture_up(voxel : Dictionary) -> Vector2:return get_texture_side(voxel, Vector3.UP)
	
static func get_texture_down(voxel : Dictionary) -> Vector2: return get_texture_side(voxel, Vector3.DOWN)
	
static func get_texture_back(voxel : Dictionary) -> Vector2:return get_texture_side(voxel, Vector3.BACK)
static func get_texture_forward(voxel : Dictionary) -> Vector2:return get_texture_side(voxel, Vector3.FORWARD)
	

#
static func set_texture_side(voxel : Dictionary, side : Vector3, texture_position : Vector2) -> void:
	if not typeof(voxel.get('textures')) == TYPE_DICTIONARY: voxel['textures'] = {}
	voxel['textures'][side] = texture_position


static func set_texture_right(voxel : Dictionary, texture_position : Vector2) -> void: set_texture_side(voxel, Vector3.RIGHT, texture_position)
static func set_texture_left(voxel : Dictionary, texture_position : Vector2) -> void: set_texture_side(voxel, Vector3.LEFT, texture_position)
static func set_texture_up(voxel : Dictionary, texture_position : Vector2) -> void: set_texture_side(voxel, Vector3.UP, texture_position)
static func set_texture_down(voxel : Dictionary, texture_position : Vector2) -> void: set_texture_side(voxel, Vector3.DOWN, texture_position)
static func set_texture_back(voxel : Dictionary, texture_position : Vector2) -> void: set_texture_side(voxel, Vector3.BACK, texture_position)
static func set_texture_forward(voxel : Dictionary, texture_position : Vector2) -> void: set_texture_side(voxel, Vector3.FORWARD, texture_position)



static func generate_right(st : SurfaceTool, voxel : Dictionary, g1 : Vector3, g2 = null, g3 = null, g4 = null) -> void:
	st.add_normal(Vector3.RIGHT)
	st.add_color(get_color_right(voxel))
	
	st.add_vertex(grid_to_pos(g1 + Vector3.RIGHT))
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.RIGHT + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.RIGHT + Vector3.UP))
	
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.RIGHT + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g4 if g4 != null else g1) + Vector3.ONE))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.RIGHT + Vector3.UP))

static func generate_left(st : SurfaceTool, voxel : Dictionary, g1 : Vector3, g2 = null, g3 = null, g4 = null) -> void:
	st.add_normal(Vector3.LEFT)
	st.add_color(get_color_left(voxel))
	
	st.add_vertex(grid_to_pos((g4 if g4 != null else g1) + Vector3.UP + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.UP))
	
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.BACK))
	
	st.add_vertex(grid_to_pos(g1))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.UP))

static func generate_up(st : SurfaceTool, voxel : Dictionary, g1 : Vector3, g2 = null, g3 = null, g4 = null) -> void:
	st.add_normal(Vector3.UP)
	st.add_color(get_color_up(voxel))
	
	st.add_vertex(grid_to_pos((g4 if g4 != null else g1) + Vector3.ONE))
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.UP + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.RIGHT + Vector3.UP))
	
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.UP + Vector3.BACK))
	
	st.add_vertex(grid_to_pos(g1 + Vector3.UP))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.RIGHT + Vector3.UP))

static func generate_down(st : SurfaceTool, voxel : Dictionary, g1 : Vector3, g2 = null, g3 = null, g4 = null) -> void:
	st.add_normal(Vector3.DOWN)
	st.add_color(get_color_down(voxel))
	
	st.add_vertex(grid_to_pos(g1))
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.RIGHT))
	
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g4 if g4 != null else g1) + Vector3.RIGHT + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.RIGHT))

static func generate_back(st : SurfaceTool, voxel : Dictionary, g1 : Vector3, g2 = null, g3 = null, g4 = null) -> void:
	st.add_normal(Vector3.BACK)
	st.add_color(get_color_back(voxel))
	
	st.add_vertex(grid_to_pos((g4 if g4 != null else g1) + Vector3.ONE))
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.RIGHT + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.UP + Vector3.BACK))
	
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.RIGHT + Vector3.BACK))
	
	st.add_vertex(grid_to_pos(g1 + Vector3.BACK))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.UP + Vector3.BACK))

static func generate_forward(st : SurfaceTool, voxel : Dictionary, g1 : Vector3, g2 = null, g3 = null, g4 = null) -> void:
	st.add_normal(Vector3.FORWARD)
	st.add_color(get_color_forward(voxel))
	
	st.add_vertex(grid_to_pos(g1))
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.RIGHT))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.UP))
	
	
	st.add_vertex(grid_to_pos((g2 if g2 != null else g1) + Vector3.RIGHT))
	
	st.add_vertex(grid_to_pos((g4 if g4 != null else g1) + Vector3.RIGHT + Vector3.UP))
	
	st.add_vertex(grid_to_pos((g3 if g3 != null else g1) + Vector3.UP))

static func generate_side(direction : Vector3, st : SurfaceTool, voxel : Dictionary, g1 : Vector3, g2 = null, g3 = null, g4 = null) -> void:
	match direction:
		Vector3.RIGHT: generate_right(st, voxel, g1, g2, g3, g4)
		Vector3.LEFT: generate_left(st, voxel, g1, g2, g3, g4)
		Vector3.UP: generate_up(st, voxel, g1, g2, g3, g4)
		Vector3.DOWN: generate_down(st, voxel, g1, g2, g3, g4)
		Vector3.BACK: generate_back(st, voxel, g1, g2, g3, g4)
		Vector3.FORWARD: generate_forward(st, voxel, g1, g2, g3, g4)

static func sync_dire(dire) -> int:
	match dire:
		0:dire = 3
		1:dire = 2
		2:dire = 1
		3:dire = 0
#		4:dire = 5
#		5:dire = 4
	return dire

static func check_direction_forward(voxel : Dictionary,key:Vector3,dire) -> Vector2:
	var uv_position : Vector2 
	dire = sync_dire(dire)
	if dire == 3:
		uv_position = get_texture_left(voxel)
	if dire == 0:
		uv_position = get_texture_forward(voxel)
	if dire == 1:
		uv_position = get_texture_right(voxel)
	if dire == 2:
		uv_position = get_texture_back(voxel)
	if dire == 4:
#		uv_position = get_texture_left(voxel)
		uv_position = get_texture_forward(voxel)
	if dire == 5:
		uv_position = get_texture_forward(voxel)
	return uv_position
static func check_direction_left(voxel : Dictionary,key:Vector3,dire) -> Vector2:
	var uv_position : Vector2 
	dire = sync_dire(dire)
	if dire == 3:
		uv_position = get_texture_back(voxel)
	if dire == 0:
		uv_position = get_texture_left(voxel)
	if dire == 1:
		uv_position = get_texture_forward(voxel)
	if dire == 2:
		uv_position = get_texture_right(voxel)
	if dire == 4:
		uv_position = get_texture_down(voxel)
	if dire == 5:
		uv_position = get_texture_up(voxel)
	return uv_position
static func check_direction_right(voxel : Dictionary,key:Vector3,dire) -> Vector2:
	var uv_position : Vector2 
	dire = sync_dire(dire)
	if dire == 3:
		uv_position = get_texture_forward(voxel)
	if dire == 0:
		uv_position = get_texture_right(voxel)
	if dire == 1:
		uv_position = get_texture_back(voxel)
	if dire == 2:
		uv_position = get_texture_left(voxel)
	if dire == 4:
		uv_position = get_texture_up(voxel)
	if dire == 5:
		uv_position = get_texture_down(voxel)
	return uv_position
static func check_direction_back(voxel : Dictionary,key:Vector3,dire) -> Vector2:
	var uv_position : Vector2 
	dire = sync_dire(dire)
	if dire == 3:
		uv_position = get_texture_right(voxel)
	if dire == 0:
		uv_position = get_texture_back(voxel)
	if dire == 1:
		uv_position = get_texture_left(voxel)
	if dire == 2:
		uv_position = get_texture_forward(voxel)
	if dire == 4:
		uv_position = get_texture_back(voxel)
	if dire == 5:
		uv_position = get_texture_back(voxel)
	return uv_position
static func check_direction_up(voxel : Dictionary,key:Vector3,dire) -> Vector2:
	var uv_position : Vector2 
	if dire == 0:
		uv_position = get_texture_up(voxel)
	if dire == 1:
		uv_position = get_texture_up(voxel)
	if dire == 2:
		uv_position = get_texture_up(voxel)
	if dire == 3:
		uv_position = get_texture_up(voxel)
	if dire == 4:
		uv_position = get_texture_left(voxel)
	if dire == 5:
		uv_position = get_texture_right(voxel)
	return uv_position
static func check_direction_down(voxel : Dictionary,key:Vector3,dire) -> Vector2:
	var uv_position : Vector2 
	if dire == 0:
		uv_position = get_texture_down(voxel)
	if dire == 1:
		uv_position = get_texture_down(voxel)
	if dire == 2:
		uv_position = get_texture_down(voxel)
	if dire == 3:
		uv_position = get_texture_down(voxel)
	if dire == 4:
		uv_position = get_texture_right(voxel)
	if dire == 5:
		uv_position = get_texture_left(voxel)
	return uv_position


static func generate_right_with_uv(st : SurfaceTool, voxel : Dictionary, g1 : Vector3,dire:=0,offset=Vector2(0,0)) -> void:
	st.add_normal(Vector3.RIGHT)
	st.add_color(Color())
	var uv_position : Vector2 = get_texture_right(voxel)
	uv_position = check_direction_right(voxel,g1,dire)
	if uv_position == null: uv_position = Vector2(-1, -1)
	var offset_ = 1.0
	if offset!= Vector2(0,0):
		offset_ = 0.2
		uv_position += offset
	st.add_uv((uv_position + Vector2.ONE*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.BACK))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.UP))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.BACK))
	st.add_uv((uv_position) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.ONE))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.UP))

static func generate_left_with_uv(st : SurfaceTool, voxel : Dictionary, g1 : Vector3,dire:=0,offset=Vector2(0,0)) -> void:
	
	st.add_normal(Vector3.LEFT)
	st.add_color(Color())
	var uv_position : Vector2 = get_texture_left(voxel)
	uv_position = check_direction_left(voxel,g1,dire)
	if uv_position == null: uv_position = Vector2(-1, -1)
	var offset_ = 1.0
	if offset!= Vector2(0,0):
		offset_ = 0.2
		uv_position += offset
	st.add_uv((uv_position) * VoxelSet.UV_SCALE)
	st.add_vertex((g1 + Vector3.UP + Vector3.BACK) * GridStep)
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex((g1 + Vector3.BACK) * GridStep)
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex((g1 + Vector3.UP) * GridStep)
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex((g1 + Vector3.BACK) * GridStep)
	st.add_uv((uv_position + Vector2.ONE*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex((g1) * GridStep)
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex((g1 + Vector3.UP) * GridStep)

static func generate_up_with_uv(st : SurfaceTool, voxel : Dictionary, g1 : Vector3,dire:=0,offset:=Vector2(0,0)) -> void:
	st.add_normal(Vector3.UP)
	st.add_color(Color())
	var uv_position : Vector2 = get_texture_up(voxel)
	uv_position = check_direction_up(voxel,g1,dire)
	var offset_ = 1.0
	if offset!= Vector2(0,0):
		offset_ = 0.2
		uv_position += offset
	if uv_position == null: uv_position = Vector2(-1, -1)
	st.add_uv((uv_position + Vector2.ONE*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.ONE))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.UP + Vector3.BACK))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.UP))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.UP + Vector3.BACK))
	st.add_uv((uv_position) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.UP))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.UP))

static func generate_down_with_uv(st : SurfaceTool, voxel : Dictionary, g1 : Vector3,dire:=0,offset:=Vector2(0,0)) -> void:
	st.add_normal(Vector3.DOWN)
	st.add_color(Color())
	var uv_position : Vector2 = get_texture_down(voxel)
	uv_position = check_direction_down(voxel,g1,dire)
	if uv_position == null: uv_position = Vector2(-1, -1)
	var offset_ = 1.0
	if offset!= Vector2(0,0):
		offset_ = 0.2
		uv_position += offset
	st.add_uv((uv_position) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.BACK))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.BACK))
	st.add_uv((uv_position + Vector2.ONE*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.BACK))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT))

static func generate_back_with_uv(st : SurfaceTool, voxel : Dictionary, g1 : Vector3,dire:=0,offset:=Vector2(0,0)) -> void:
	st.add_normal(Vector3.BACK)
	st.add_color(Color())
	var uv_position : Vector2 = get_texture_back(voxel)
	uv_position = check_direction_back(voxel,g1,dire)
	var offset_ = 1.0
	if offset!= Vector2(0,0):
		offset_ = 0.2
		uv_position += offset
	if uv_position == null: uv_position = Vector2(-1, -1)
	st.add_uv((uv_position) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.ONE))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.BACK))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.UP + Vector3.BACK))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.BACK))
	st.add_uv((uv_position + Vector2.ONE*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.BACK))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.UP + Vector3.BACK))

static func generate_forward_with_uv(st : SurfaceTool, voxel : Dictionary, g1 : Vector3,dire:=0,offset:=Vector2(0,0)) -> void:
	st.add_normal(Vector3.FORWARD)
	st.add_color(Color())
	var uv_position : Vector2 = get_texture_forward(voxel)
	uv_position = check_direction_forward(voxel,g1,dire)
	
	if uv_position == null: uv_position = Vector2(-1, -1)
	var offset_ = 1.0
	if offset!= Vector2(0,0):
		offset_ = 0.2
		uv_position += offset
	st.add_uv((uv_position + Vector2.ONE*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.UP))
	st.add_uv((uv_position + Vector2.DOWN*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT))
	st.add_uv((uv_position) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.RIGHT + Vector3.UP))
	st.add_uv((uv_position + Vector2.RIGHT*offset_) * VoxelSet.UV_SCALE)
	st.add_vertex(GridStep * (g1 + Vector3.UP))

static func generate_side_with_uv(direction : Vector3, st : SurfaceTool, voxel : Dictionary, g1 : Vector3) -> void:
	match direction:
		Vector3.RIGHT: generate_right_with_uv(st, voxel, g1)
		Vector3.LEFT: generate_left_with_uv(st, voxel, g1)
		Vector3.UP: generate_up_with_uv(st, voxel, g1)
		Vector3.DOWN: generate_down_with_uv(st, voxel, g1)
		Vector3.BACK: generate_back_with_uv(st, voxel, g1)
		Vector3.FORWARD: generate_forward_with_uv(st, voxel, g1)


const MagicaVoxelColors : = [
	"00000000", "ffffffff", "ffccffff", "ff99ffff", "ff66ffff", "ff33ffff", "ff00ffff", "ffffccff", "ffccccff", "ff99ccff", "ff66ccff", "ff33ccff", "ff00ccff", "ffff99ff", "ffcc99ff", "ff9999ff",
	"ff6699ff", "ff3399ff", "ff0099ff", "ffff66ff", "ffcc66ff", "ff9966ff", "ff6666ff", "ff3366ff", "ff0066ff", "ffff33ff", "ffcc33ff", "ff9933ff", "ff6633ff", "ff3333ff", "ff0033ff", "ffff00ff",
	"ffcc00ff", "ff9900ff", "ff6600ff", "ff3300ff", "ff0000ff", "ffffffcc", "ffccffcc", "ff99ffcc", "ff66ffcc", "ff33ffcc", "ff00ffcc", "ffffcccc", "ffcccccc", "ff99cccc", "ff66cccc", "ff33cccc",
	"ff00cccc", "ffff99cc", "ffcc99cc", "ff9999cc", "ff6699cc", "ff3399cc", "ff0099cc", "ffff66cc", "ffcc66cc", "ff9966cc", "ff6666cc", "ff3366cc", "ff0066cc", "ffff33cc", "ffcc33cc", "ff9933cc",
	"ff6633cc", "ff3333cc", "ff0033cc", "ffff00cc", "ffcc00cc", "ff9900cc", "ff6600cc", "ff3300cc", "ff0000cc", "ffffff99", "ffccff99", "ff99ff99", "ff66ff99", "ff33ff99", "ff00ff99", "ffffcc99",
	"ffcccc99", "ff99cc99", "ff66cc99", "ff33cc99", "ff00cc99", "ffff9999", "ffcc9999", "ff999999", "ff669999", "ff339999", "ff009999", "ffff6699", "ffcc6699", "ff996699", "ff666699", "ff336699",
	"ff006699", "ffff3399", "ffcc3399", "ff993399", "ff663399", "ff333399", "ff003399", "ffff0099", "ffcc0099", "ff990099", "ff660099", "ff330099", "ff000099", "ffffff66", "ffccff66", "ff99ff66",
	"ff66ff66", "ff33ff66", "ff00ff66", "ffffcc66", "ffcccc66", "ff99cc66", "ff66cc66", "ff33cc66", "ff00cc66", "ffff9966", "ffcc9966", "ff999966", "ff669966", "ff339966", "ff009966", "ffff6666",
	"ffcc6666", "ff996666", "ff666666", "ff336666", "ff006666", "ffff3366", "ffcc3366", "ff993366", "ff663366", "ff333366", "ff003366", "ffff0066", "ffcc0066", "ff990066", "ff660066", "ff330066",
	"ff000066", "ffffff33", "ffccff33", "ff99ff33", "ff66ff33", "ff33ff33", "ff00ff33", "ffffcc33", "ffcccc33", "ff99cc33", "ff66cc33", "ff33cc33", "ff00cc33", "ffff9933", "ffcc9933", "ff999933",
	"ff669933", "ff339933", "ff009933", "ffff6633", "ffcc6633", "ff996633", "ff666633", "ff336633", "ff006633", "ffff3333", "ffcc3333", "ff993333", "ff663333", "ff333333", "ff003333", "ffff0033",
	"ffcc0033", "ff990033", "ff660033", "ff330033", "ff000033", "ffffff00", "ffccff00", "ff99ff00", "ff66ff00", "ff33ff00", "ff00ff00", "ffffcc00", "ffcccc00", "ff99cc00", "ff66cc00", "ff33cc00",
	"ff00cc00", "ffff9900", "ffcc9900", "ff999900", "ff669900", "ff339900", "ff009900", "ffff6600", "ffcc6600", "ff996600", "ff666600", "ff336600", "ff006600", "ffff3300", "ffcc3300", "ff993300",
	"ff663300", "ff333300", "ff003300", "ffff0000", "ffcc0000", "ff990000", "ff660000", "ff330000", "ff0000ee", "ff0000dd", "ff0000bb", "ff0000aa", "ff000088", "ff000077", "ff000055", "ff000044",
	"ff000022", "ff000011", "ff00ee00", "ff00dd00", "ff00bb00", "ff00aa00", "ff008800", "ff007700", "ff005500", "ff004400", "ff002200", "ff001100", "ffee0000", "ffdd0000", "ffbb0000", "ffaa0000",
	"ff880000", "ff770000", "ff550000", "ff440000", "ff220000", "ff110000", "ffeeeeee", "ffdddddd", "ffbbbbbb", "ffaaaaaa", "ff888888", "ff777777", "ff555555", "ff444444", "ff222222", "ff111111"
]

static func vox_to_voxels(file : File):
	var voxels := {}
	
	
	var magic := PoolByteArray([
		file.get_8(),
		file.get_8(),
		file.get_8(),
		file.get_8()
	]).get_string_from_ascii()
	
	var magic_version := file.get_32()
	
	var magic_custom_colors := []
	
	if magic == "VOX ":
		while file.get_position() < file.get_len():
			var chunkId = PoolByteArray([
				file.get_8(),
				file.get_8(),
				file.get_8(),
				file.get_8()
			]).get_string_from_ascii()
			var chunkSize = file.get_32()
			var childChunks = file.get_32()
			var chunkName = chunkId
			
			if chunkName == "SIZE":
				file.get_32()   #   size X-axis
				file.get_32()   #   size Y-axis
				file.get_32()   #   size Z-axis
				file.get_buffer(chunkSize - 4 * 3)
			elif chunkName == "XYZI":
				for i in range(0, file.get_32()):
					var x := file.get_8()
					var z := -file.get_8()
					var y := file.get_8()
					voxels[Vector3(x, y, z).floor()] = file.get_8()
			elif chunkName == "RGBA":
				magic_custom_colors = []
				for i in range(0,256):
					magic_custom_colors.append(Color(
						float(file.get_8() / 255.0),
						float(file.get_8() / 255.0),
						float(file.get_8() / 255.0),
						float(file.get_8() / 255.0)
					))
			else: file.get_buffer(chunkSize)
	else:
		printerr("VoxToVoxels: file not valid .vox")
		return FAILED
	file.close()
	
	if magic_custom_colors.size() > 0:
		for voxel_grid in voxels.keys():
			voxels[voxel_grid] = colored(magic_custom_colors[voxels[voxel_grid] - 1])
	else:
		for voxel_grid in voxels.keys():
			voxels[voxel_grid] = colored(Color(MagicaVoxelColors[voxels[voxel_grid]] - 1))
	
	
	return voxels

static func image_to_voxels(image : Image) -> Dictionary:
	var voxels : = {}
	
	
	image.lock()
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			if not image.get_pixel(x, y).a == 0:
				voxels[Vector3(x, -y, 0).round()] = colored(image.get_pixel(x, y))
	image.unlock()
	
	
	return voxels


# voxels     :   Dictionary       -   voxels from which to calculate extremes
# @returns   :   Array<Vector3>   -   empty, no Voxels are present; size 2, index 0 is min extreme and index 1 is max extreme
#
# Example:
#   get_extremes([VoxelObject]) -> [Vector3(-1, -3, 5), Vector3(0, -2, 9)]
#
static func get_extremes(voxels) -> Array:
	var extremes = []
	
	voxels = voxels.keys()
	
	if voxels.size() > 0:
		var _min : Vector3 = voxels[0]
		var _max : Vector3 = voxels[0]
		
		for voxel_grid in voxels:
			if voxel_grid.x < _min.x: _min.x = voxel_grid.x
			if voxel_grid.y < _min.y: _min.y = voxel_grid.y
			if voxel_grid.z < _min.z: _min.z = voxel_grid.z
			
			if voxel_grid.x > _max.x: _max.x = voxel_grid.x
			if voxel_grid.y > _max.y: _max.y = voxel_grid.y
			if voxel_grid.z > _max.z: _max.z = voxel_grid.z
		
		extremes.append(_min)
		extremes.append(_max)
	
	return extremes

# position   :   Vector3                                      -   Starting position
# target     :   int/String/Color                             -   Target searching for
# voxels     :   Dictionary<Vector3, int/String/Dictionary>   -   Voxels to search within NOTE: Voxels will be modified!
# @returns   :   Array<Vector3>                               -   Array containing all grid positions of matching Voxels
#
# Example:
#   flood_select(Vector3(-1, 2, 2), 33, { ... }) -> [ ... ]
#   flood_select(Vector3(-1, 2, 2), "black", { ... }) -> [ ... ]
#   flood_select(Vector3(-1, 2, 2), Color(1, 0, 0), { ... }) -> [ ... ]
#
static func flood_select(position : Vector3, target, voxels : Dictionary) -> Array:
	var selected := []
	var voxel = voxels.get(position)
	if (typeof(voxel) == TYPE_DICTIONARY and get_color(voxel) == target) if (not typeof(voxel) == TYPE_NIL and typeof(target) == TYPE_COLOR) else (str(voxel) == str(target)):
		selected.append(position)
		voxels.erase(position)
		
		selected += flood_select(position + Vector3.RIGHT, target, voxels)
		selected += flood_select(position + Vector3.LEFT, target, voxels)
		selected += flood_select(position + Vector3.UP, target, voxels)
		selected += flood_select(position + Vector3.DOWN, target, voxels)
		selected += flood_select(position + Vector3.BACK, target, voxels)
		selected += flood_select(position + Vector3.FORWARD, target, voxels)
	return selected

# position   :   Vector3                                      -   Starting position
# side       :   Vector3                                      -   Side to check for obstruction
# voxels     :   Dictionary<Vector3, int/String/Dictionary>   -   Voxels to search within NOTE: Voxels will be modified!
# @returns   :   Array<Vector3>                               -   Array containing all grid positions of matching Voxels
#
# Example:
#   face_select(Vector3(-1, 2, 2), Vector3.RIGHT, { ... }) -> [ ... ]
#
static func side_select(position : Vector3, side : Vector3, voxels : Dictionary) -> Array:
	var selected := []
	var voxel = voxels.get(position)
	if not typeof(voxel) == TYPE_NIL and typeof(voxels.get(position + side)) == TYPE_NIL:
		selected.append(position)
		voxels.erase(position)
		if side == Vector3.RIGHT or side == Vector3.LEFT:
			selected += side_select(position + Vector3.UP, side, voxels)
			selected += side_select(position + Vector3.DOWN, side, voxels)
			selected += side_select(position + Vector3.BACK, side, voxels)
			selected += side_select(position + Vector3.FORWARD, side, voxels)
		elif side == Vector3.UP or side == Vector3.DOWN:
			selected += side_select(position + Vector3.RIGHT, side, voxels)
			selected += side_select(position + Vector3.LEFT, side, voxels)
			selected += side_select(position + Vector3.BACK, side, voxels)
			selected += side_select(position + Vector3.FORWARD, side, voxels)
		elif side == Vector3.BACK or side == Vector3.FORWARD:
			selected += side_select(position + Vector3.UP, side, voxels)
			selected += side_select(position + Vector3.DOWN, side, voxels)
			selected += side_select(position + Vector3.RIGHT, side, voxels)
			selected += side_select(position + Vector3.LEFT, side, voxels)
	return selected

# voxels       :   Dictionary   -   voxels to center
# above_axis   :   bool         -   center Voxels above x and z axis
# @returns     :   Dictionary   -   voxels centered
#
# Example:
#   center({ ... }, false) -> { ... }
#
static func center(voxels : Dictionary, above_axis := false) -> Dictionary:
	var centred_voxels := {}
	
	if voxels.size() > 0:
		var extremes := get_extremes(voxels)
		var dimensions = extremes[1] - extremes[0] + Vector3.ONE
		var center_point = (extremes[0] + dimensions / 2).floor()
		
		if above_axis: center_point.y += dimensions.y / 2 * -1
		
		for voxel_grid in voxels:
			centred_voxels[(voxel_grid + (center_point * -1)).floor()] = voxels[voxel_grid]
	
	return centred_voxels
