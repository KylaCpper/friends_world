extends MeshInstance
var surfTool = SurfaceTool.new()
var triangleCount =0
var depth=1.5
var alpha_offset=1.0
var voxel_me = null

var height:float
var width:float
var img 


var debug=false
#func _init() -> void:
#	mat1 = mat1.duplicate()
func create(spr) -> void:
	self.depth = depth
	voxel_me = spr
	if voxel_me:
		
		material_override = material_override.duplicate()
		voxel_me = voxel_me.duplicate()
		voxelization()



#func _files_dropped(images, screen):#delete if this func you don't need
#	$ItemList.clear()
#	var extensions = ResourceLoader.get_recognized_extensions_for_type("Texture")
#
#	var im = Image.new()
#	var err = im.load(images[0])
#	if err != OK:
#		print("Could not load image file")
#		return
#
#	var tex = ImageTexture.new()
#	tex.create_from_image(im, Texture.FLAGS_DEFAULT)
#	voxelization(tex)
#	$ItemList.add_item(images[0], tex, true)


func voxelization():
	var ms = OS.get_ticks_msec()
	triangleCount=0
	img = voxel_me.get_data()
	img.lock()
	height = voxel_me.get_height()
	width = voxel_me.get_width()
	var mesh = Mesh.new()
	material_override.albedo_texture = voxel_me
	surfTool.set_material(material_override)
	surfTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for x in voxel_me.get_width():
		for y in voxel_me.get_height():
			var _color = img.get_pixel ( x,y ) 
			if _color.a >=alpha_offset: # get all opaque pixels send check for sides
				make_cube(Vector2(x,y))
			else:
				img.set_pixel(x,y,Color.transparent)#if it is under the offset pixel will be transparent
	
	make_up_down_side()
	surfTool.generate_normals(false)
	surfTool.index()
	surfTool.commit(mesh)
	self.set_mesh(mesh)
	self.set_surface_material(0,material_override)
	
	if(debug):
		var itex = ImageTexture.new()
		itex.create_from_image(img,0)
		material_override.albedo_texture = itex
	
	img.unlock()
	ms -= OS.get_ticks_msec()
	

#	print(str(abs(ms)),str(triangleCount))



func make_up_down_side():
	#   -Vector3(width/2,height/2,0) and -Vector3(width/2,height/2,-depth) is for correcting offset
	
	### front side
	# y is 1 or height+1 because of fixing gliding upwards
	var vec1 = Vector3(width,height+1,0)-Vector3(width/2,height/2,-depth)
	var vec2 = Vector3(width,1,0)-Vector3(width/2,height/2,-depth)
	var vec3 = Vector3(0,1,0)-Vector3(width/2,height/2,-depth)
	
	surfTool.add_uv(Vector2(1.0,0.0))
	surfTool.add_vertex(vec1)
	surfTool.add_uv(Vector2(1.0,1.0))
	surfTool.add_vertex(vec2)
	surfTool.add_uv(Vector2(0.0,1.0))
	surfTool.add_vertex(vec3)
	triangleCount+=1
  #other triangle
	vec1 = Vector3(0,1,0)-Vector3(width/2,height/2,-depth)
	vec2 = Vector3(0,height+1,0)-Vector3(width/2,height/2,-depth)
	vec3 = Vector3(width,height+1,0)-Vector3(width/2,height/2,-depth)

	surfTool.add_uv(Vector2(0.0,1.0))
	surfTool.add_vertex(vec1)
	surfTool.add_uv(Vector2(0.0,0.0))
	surfTool.add_vertex(vec2)
	surfTool.add_uv(Vector2(1.0,0.0))
	surfTool.add_vertex(vec3)
	triangleCount+=1
	
	### back side
	vec1 = Vector3(0,height+1,0)-Vector3(width/2,height/2,0)
	vec2 = Vector3(0,1,0)-Vector3(width/2,height/2,0)
	vec3 = Vector3(width,1,0)-Vector3(width/2,height/2,0)
	
	surfTool.add_uv(Vector2(0.0,0.0))
	surfTool.add_vertex(vec1)
	surfTool.add_uv(Vector2(0.0,1.0))
	surfTool.add_vertex(vec2)
	surfTool.add_uv(Vector2(1.0,1.0))
	surfTool.add_vertex(vec3)
	triangleCount+=1
  #other triangle
	vec1 = Vector3(width,1,0)-Vector3(width/2,height/2,0)
	vec2 = Vector3(width,height+1,0)-Vector3(width/2,height/2,0)
	vec3 = Vector3(0,height+1,0)-Vector3(width/2,height/2,0)
	
	surfTool.add_uv(Vector2(1.0,1.0))
	surfTool.add_vertex(vec1)
	surfTool.add_uv(Vector2(1.0,0.0))
	surfTool.add_vertex(vec2)
	surfTool.add_uv(Vector2(0.0,0.0))
	surfTool.add_vertex(vec3)
	triangleCount+=1
	

func make_cube(pixel_pos):# this works on each pixels in the loop that above
	#-Vector3(width/2,height/2,0) is for correcting offset
	
		if pixel_pos.x==0 or  img.get_pixel (pixel_pos.x-1,pixel_pos.y).a <alpha_offset :# is it end of image or is leftside of pixel transparent?
			
			#height-pixel_pos.y because of flipping. Without it, mesh have wrong rotation
			var vec1 = Vector3(pixel_pos.x,height-pixel_pos.y,0)-Vector3(width/2,height/2,0)
			var vec2 = Vector3(pixel_pos.x,height-pixel_pos.y+1,0)-Vector3(width/2,height/2,0)
			var vec3 = Vector3(pixel_pos.x,height-pixel_pos.y+1,depth)-Vector3(width/2,height/2,0)
			
			#adding 0.5 because there is flitchering without it on image with power of 2 scales
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec1)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec2)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec3)
			triangleCount+=1
		  #other triangle
			vec1 = Vector3(pixel_pos.x,height-pixel_pos.y+1,depth)-Vector3(width/2,height/2,0)
			vec2 = Vector3(pixel_pos.x,height-pixel_pos.y,depth)-Vector3(width/2,height/2,0)
			vec3 = Vector3(pixel_pos.x,height-pixel_pos.y,0)-Vector3(width/2,height/2,0)
			
			#adding 0.5 because there is flitchering without it on image with power of 2 scales
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec1)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec2)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec3)
			triangleCount+=1

		if pixel_pos.x==width-1 or img.get_pixel (pixel_pos.x+1,pixel_pos.y).a <alpha_offset :# is it end of image or is right side of pixel transparent?
			
			#height-pixel_pos.y because of flipping. Without it, mesh have wrong rotation
			var vec1 = Vector3(pixel_pos.x+1,height-pixel_pos.y+1,0)-Vector3(width/2,height/2,0)
			var vec2 = Vector3(pixel_pos.x+1,height-pixel_pos.y,0)-Vector3(width/2,height/2,0)
			var vec3 = Vector3(pixel_pos.x+1,height-pixel_pos.y+1,depth)-Vector3(width/2,height/2,0)
			
			#adding 0.5 because there is flitchering without it on image with power of 2 scales
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec1)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec2)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec3)
			triangleCount+=1
		  #other triangle
			vec1 = Vector3(pixel_pos.x+1,height-pixel_pos.y,depth)-Vector3(width/2,height/2,0)
			vec2 = Vector3(pixel_pos.x+1,height-pixel_pos.y+1,depth)-Vector3(width/2,height/2,0)
			vec3 = Vector3(pixel_pos.x+1,height-pixel_pos.y,0)-Vector3(width/2,height/2,0)
			
			#adding 0.5 because there is flitchering without it on image with power of 2 scales
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec1)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec2)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec3)
			triangleCount+=1

		if pixel_pos.y==0 or img.get_pixel (pixel_pos.x,pixel_pos.y-1).a <alpha_offset :# is it end of image or is up side of pixel transparent?

			#height-pixel_pos.y+1 because of flipping. Without it, mesh have wrong rotation and 1 pixel down
			var vec1 = Vector3(pixel_pos.x+1,height-pixel_pos.y+1,0)-Vector3(width/2,height/2,0)
			var vec2 = Vector3(pixel_pos.x+1,height-pixel_pos.y+1,depth)-Vector3(width/2,height/2,0)
			var vec3 = Vector3(pixel_pos.x,height-pixel_pos.y+1,depth)-Vector3(width/2,height/2,0)

			#adding 0.5 because there is flitchering without it on image with power of 2 scales
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec1)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec2)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec3)
			triangleCount+=1
		  #other triangle
			vec1 = Vector3(pixel_pos.x,height-pixel_pos.y+1,depth)-Vector3(width/2,height/2,0)
			vec2 = Vector3(pixel_pos.x,height-pixel_pos.y+1,0)-Vector3(width/2,height/2,0)
			vec3 = Vector3(pixel_pos.x+1,height-pixel_pos.y+1,0)-Vector3(width/2,height/2,0)

			#adding 0.5 because there is flitchering without it on image with power of 2 scales
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec1)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec2)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec3)
			triangleCount+=1

		if pixel_pos.y==height-1 or img.get_pixel (pixel_pos.x,pixel_pos.y+1).a <alpha_offset :# is it end of image or is down side of pixel transparent?

			#height-pixel_pos.y+1 because of flipping. Without it, mesh have wrong rotation and 1 pixel down
			var vec1 = Vector3(pixel_pos.x,height-pixel_pos.y,0)-Vector3(width/2,height/2,0)
			var vec2 = Vector3(pixel_pos.x,height-pixel_pos.y,depth)-Vector3(width/2,height/2,0)
			var vec3 = Vector3(pixel_pos.x+1,height-pixel_pos.y,depth)-Vector3(width/2,height/2,0)

			#adding 0.5 because there is flitchering without it on image with power of 2 scales
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec1)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec2)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec3)
			triangleCount+=1
		  #other triangle
			vec1 = Vector3(pixel_pos.x+1,height-pixel_pos.y,depth)-Vector3(width/2,height/2,0)
			vec2 = Vector3(pixel_pos.x+1,height-pixel_pos.y,0)-Vector3(width/2,height/2,0)
			vec3 = Vector3(pixel_pos.x,height-pixel_pos.y,0)-Vector3(width/2,height/2,0)

			#adding 0.5 because there is flitchering without it on image with power of 2 scales
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec1)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec2)
			surfTool.add_uv(Vector2((pixel_pos.x+0.5)/width,(pixel_pos.y+0.5)/height))
			surfTool.add_vertex(vec3)
			triangleCount+=1



