extends Node
var selection: GridSlot = null
signal menu_changed
var drag_state:= false
var user: String
var icons: Dictionary
var applist: PackedStringArray = []
var positions: Dictionary

func _ready() -> void:
	menu_changed.connect(save_positions)
	if FileAccess.file_exists("user://icon_cache"):
		var file = FileAccess.open("user://icon_cache", FileAccess.READ)
		icons = JSON.parse_string(file.get_as_text())
	if FileAccess.file_exists("user://icon_positions"):
		var file = FileAccess.open("user://icon_positions", FileAccess.READ)
		positions = JSON.parse_string(file.get_as_text())

func save_iconcache():
	var file = FileAccess.open("user://icon_cache", FileAccess.WRITE)
	file.store_line(JSON.stringify(icons))

func save_positions():
	var file = FileAccess.open("user://icon_positions", FileAccess.WRITE)
	file.store_line(JSON.stringify(positions))
