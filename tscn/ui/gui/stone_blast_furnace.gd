extends "furnace.gd"


func _init() -> void:
	Overall.stone_blast_furnace_node = self
	table_name = "stone_blast_furnace"
	grid = 3
	export_list = [{"name":"","num":0,"hp":0},{"name":"","num":0,"hp":0}]
	fuel_grid = 1
	fuel_time_max = 0.0
	fuel_time = 0.0
