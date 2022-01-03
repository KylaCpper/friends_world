extends Base_Block
class_name Advanced_Model

var block_tscn := preload("res://script/stone_age/model/stone_furnace.tscn")
# 数据模型
var model = {
	"id":0,
}
#实际数据
var list = {}
var name_ := "default"

func init() -> void:
	var box = Save.world.box
	for key1 in box:
		for key2 in box[key1]:
			for key3 in box[key1][key2]:
#				if "type" in box[key1][key2][key3]:
#					if box[key1][key2][key3].type == name_:
#						box[key1][key2][key3]["id"] = model.id
#						box[key1][key2][key3].erase("type")
				if "id" in box[key1][key2][key3]:
					if int(box[key1][key2][key3].id) == model.id:
						list[key3] = box[key1][key2][key3]
						var pos3 = Function.arr_vec(key3)
						place_real([pos3,name_,Block.get_dire(Save.world.map[key1][key2][key3])])
						init_(pos3,key3)
#						Overall.terrain_main_node.queue_place_real(pos3,name_)
func init_(pos3,key3) -> void:
	pass
func _place(pos3:Vector3,block_name:String,dire:int) -> void:
	place_real([pos3,block_name,dire])
	._place(pos3,block_name,dire)
	Overall.rpc_item_script(block_name,"place_real",[pos3,block_name,dire])
	

func place_real(args:Array) -> void:
	var pos3 = args[0]
	var block_name = args[1]
	var dire = args[2]
	if Overall.chunks_node_node.is_place(pos3):
		var tscn = block_tscn.instance()
		tscn.translation = pos3+Vector3(0.5,0.5,0.5)
		Overall.chunks_node_node.place_real(pos3,tscn,block_name,dire)
		
func _damage(pos3:Vector3,block_name:String,dire:int) -> void:
	damage_real([pos3])
	Overall.rpc_item_script(block_name,"damage_real",[pos3])
	
func damage_real(args:Array) -> void:
	var pos3 = args[0]
	Overall.chunks_node_node.delete_block_real(pos3)
