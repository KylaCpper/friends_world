extends GuiGrid
func _init() -> void:
	grid = 0
	
var icon = preload("res://assets/img/ui/default.png")
func _ready():
#	Overall.composite_node = self
#	for i in range(grid):
#		get_node("ScrollContainer/grid/grid"+str(i)).connect("mouse_entered",self,"_on_grid_enter",[i])
#		get_node("ScrollContainer/grid/grid"+str(i)).connect("mouse_exited",self,"_on_grid_exit",[i])
	$tab.set_tab_icon(0,icon)
	$tab.set_tab_icon(1,icon)

	$tab.set_tab_title(0,"")
	$tab.set_tab_title(1,"")
	
#	$tab/Tabs/ScrollContainer/GridContainer/bar0.queue_free()
#	$tab/Tabs/ScrollContainer/GridContainer/bar1.queue_free()
	
