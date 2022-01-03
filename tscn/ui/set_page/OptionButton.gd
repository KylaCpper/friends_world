extends OptionButton

func _ready() -> void:
	add_item("english")
	add_item("中文")
	connect("item_selected",self,"_on_select")
	connect("mouse_entered",self,"_on_enter")
	connect("pressed",self,"_on_click")
	select(Save.set_data.language)
func _on_select(id:int) -> void:
	Save.set_data.language = id
	TranslationServer.set_locale(Config.languages[Save.set_data.language])
	Config.languages_index = id
func _on_enter() -> void:
	Overall.audio_node.play_ui("hover")
func _on_click() -> void:
	Overall.audio_node.play_ui("click")
