
extends Node



# VoxelSet:
# A mayor problem when working with Voxels is memory and storage, afterall a VoxelObject of 16x16x16 dimensions contains, at its peak, 4096 Voxels!
# There are various ways to solve this issue, among them is having predefined Voxels and assigning them IDs.
# In this way a Voxels data won’t be repetiably copied, but instead be stored once and be referenced as many times as needed.
# VoxelSets job is to ease data consumption by having a curated fully customizable Voxel Dictionary of sorts to be used by VoxelObjects.



# Refrences
# Sorts an array, strings are not sorted and placed at the begging
class MyCustomSorter:
	static func sort(a, b):
		if typeof(a) == TYPE_STRING:
			return true
		elif typeof(b) == TYPE_STRING:
			return false
		elif a < b:
			return true
		else:
			return false



# Declarations
signal updated


var _ID := 0 setget set_id              #   Auto-increments on Voxel append
func set_id(id : int) -> void: return   #   shouldn't be settable externally
func get_id(id) -> int:
	if typeof(id) == TYPE_STRING:
		if id.is_valid_integer():
			id = id.to_int()
		else: id = _NAMES.get(id)
	return id

var _NAMES := {} setget set_names
func set_names(names : Dictionary) -> void: return   #   shouldn't be settable externally


# Sets Voxels of set, emits 'update'.
# voxels   :   Dictionary<int, Dictionary[Voxel]>   -   Voxels to duplicate
# update   :   bool                                 -   whether to call on 'update'
#
# Example:
#   set_voxels({ ... }, false)
#
var Voxels : Dictionary = {} setget set_voxels
func set_voxels(voxels : Dictionary, update := true) -> void:
	var ids = voxels.keys()
	ids.sort_custom(MyCustomSorter, "sort")
	_ID = (ids[-1] + 1) if typeof(ids[-1]) == TYPE_INT else 0
	
	Voxels = voxels.duplicate(true)
	
	if update: self.update()



var UV_SCALE := 1.0              #   UV Scale per tile
func set_uv_scale(uv_scale : float) -> void: return   #   UV_SCALE shouldn't be settable externally
# Updates UV_SCALE according to TileSize and AlbedoTexture.
# update   :   bool   -   whether to call on 'update'
#
# Example:
#   update_uv_scale(false)
#
func update_uv_scale(update := true) -> void:
	if TileSize > 0 and not AlbedoTexture == null:
		UV_SCALE = 1.0 / (AlbedoTexture.get_width() / TileSize)
		if update: self.update()

# Setter for TileSize; emits 'update' and 'set_tile_size'
# tilesize   :   int    -   size of tile
# update     :   bool   -   whether to call on 'update'
# emit       :   bool   -   true, emit signal; false, don't emit signal   #   NOTE: Won't emit 'update' if AlbedoTexture isn't set
# 
# Example:
#   set_tile_size(32, false)
#
signal set_tile_size(tilesize)
var TileSize := 0 setget set_tile_size
func set_tile_size(tilesize : int, update := true, emit := true) -> void:
	TileSize = abs(tilesize)
	
	update_uv_scale(update)
	
	if emit: emit_signal('set_tile_size', TileSize)

# Setter for AlbedoTexture; emits 'update' and 'set_albedo_texture'
# albedotexture   :   Texture   -   Texture to set
# update          :   bool      -   whether to call on 'update'
# emit            :   bool      -   true, emit signal; false, don't emit signal   #   NOTE: Won't emit 'update' if TileSize isn't set
# 
# Example:
#   set_albedo_texture([String], false)
#
signal set_albedo_texture(albedotexture)
var AlbedoTexture : Texture setget set_albedo_texture
func set_albedo_texture(albedotexture : Texture = AlbedoTexture, update := true, emit : bool = true) -> void:
	AlbedoTexture = albedotexture
	
	update_uv_scale(update)
	
	if emit: emit_signal('set_albedo_texture', AlbedoTexture)




# Core
# Load necessary data
func _load() -> void:
	_ID = get_meta('_ID') if has_meta('_ID') else 0
	_NAMES = get_meta('_NAMES') if has_meta('_NAMES') else {}
	Voxels = get_meta('Voxels') if has_meta('Voxels') else {}

# Save necessary data
func _save() -> void:
	set_meta('_ID', _ID)
	set_meta('_NAMES', _NAMES)
	set_meta('Voxels', Voxels)


# The following will initialize the object as needed
func _ready(): _load()


# Returns the current value for the specified ID in the VoxelSet.
# id         :   int/String        -   ID related to Voxel being retrieved
# @returns   :   Dictionary/null   -   Dictionary representing Voxel; null, if ID isn't found
#
# Example:
#   get_voxel(3) -> { ... }
#
func get_voxel(id):
	return Voxels.get(get_id(id))

# Append a Voxel, or set Voxel by providing a ID to VoxelSet.
# voxel      :   Dictionary   -   Voxel data to store
# id         :   int/String   -   ID to set to Voxel if not given, next available ID will be assigned and returned
# update     :   bool         -   whether to call on 'update'
# @returns   :   int/String   -   ID given to Voxel
#
# Example:
#   set_voxel({ ... })       ->   3
#   set_voxel({ ... }, 45)   ->   45
#
func set_voxel(voxel : Dictionary, id = _ID,update := true):
#	if typeof(id) == TYPE_STRING:
#		_NAMES[id] = _ID
##		Voxel.get_data(voxel)['name'] = id
##		Voxel.get_data(voxel)['light'] = light
#
#		id = _ID
#	if typeof(id) == TYPE_INT:
#		if id >= _ID: _ID = id + 1
#	else: printerr('`' + str(id) + ' `invalid id for voxelset')
#	if typeof(id) == TYPE_NIL:
#		id = _ID
#		_ID += 1
	
	Voxels[id] = voxel
	
	if update: self.update()
	
	return id

# Erase a Voxel by ID.
# id         :   int/String   -   ID related to Voxel being retrieved
# update     :   bool         -   whether to call on 'update'
#
# Example:
#   erase_voxel(33)   ->   { ... }
#
func erase_voxel(id, update := true) -> void:
	var _id = _NAMES.get(id)
	if typeof(_id) == TYPE_NIL:
		Voxels.erase(id)
	else:
		_NAMES.erase(id)
		Voxels.erase(_id)
	if update: self.update()


# Saves VoxelSet data, and emits 'update'.
func update() -> void:
	_save()
	emit_signal('updated')
