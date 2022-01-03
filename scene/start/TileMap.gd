extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var img = Image.new()
	img.create(16,16,false,Image.FORMAT_RGBA8)
	img.lock()
	for x in 16:
		for y in 16:
			img.set_pixel(x,y,Color(1,1,1,1))
	
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	var i := 0
	for r in 10:
		for g in 10:
			for b in 10: 
					tile_set.create_tile(i)
					tile_set.tile_set_texture(i,tex)
					tile_set.tile_set_modulate(i,Color(r*0.1,g*0.1,b*0.1,1))
					i += 1
	set_cell(0,0,30)
#	set_cell(1,1,5)
#	set_cell(2,2,5)
#	set_cell(3,3,5)
