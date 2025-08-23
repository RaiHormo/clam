extends Node
var selection: GridSlot = null
signal menu_changed
var drag_state:= false
var user: String
var icons: Dictionary
var applist: PackedStringArray = []
var positions: Dictionary
var theme: MenuTheme = preload("res://theme/default/theme.tres")
var theme_path = "dev"
var content_folders: Array[String] = [
	"/usr/share/applications",
	"/run/host/usr/share/applications/",
	"/home/%USER%/.local/share/flatpak/exports/share/applications",
	"/home/%USER%/.local/share/applications/"
]

func _ready() -> void:
	menu_changed.connect(save_positions)
	if FileAccess.file_exists("user://icon_cache"):
		var file = FileAccess.open("user://icon_cache", FileAccess.READ)
		icons = JSON.parse_string(file.get_as_text())
	if FileAccess.file_exists("user://icon_positions"):
		var file = FileAccess.open("user://icon_positions", FileAccess.READ)
		positions = JSON.parse_string(file.get_as_text())
	if not FileAccess.file_exists("user://theme/default/theme.tres") or theme_path == "dev":
		theme_path = "user://theme/default/"
		DirAccess.make_dir_absolute("user://theme")
		DirAccess.make_dir_absolute("user://theme/default")
		for i in DirAccess.get_files_at("res://theme/default"):
			if ".import" in i: continue
			DirAccess.copy_absolute("res://theme/default/"+i, theme_path+i)
			#var res: Resource =  load("res://theme/default/"+i)
			#print(ResourceSaver.save(res, "user://theme/default/theme.tres"))
	theme = load(theme_path+"theme.tres")

func save_iconcache():
	var file = FileAccess.open("user://icon_cache", FileAccess.WRITE)
	file.store_line(JSON.stringify(icons))

func save_positions():
	var file = FileAccess.open("user://icon_positions", FileAccess.WRITE)
	file.store_line(JSON.stringify(positions))

func get_line(line: String, in_arr: Array, devider:= "=") -> String:
	for i: String in in_arr:
		if i.begins_with(line+"="): 
			return i.replace(line+"=", "")
	return ""
