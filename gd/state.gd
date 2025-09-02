extends Node
var selection: GridSlot = null
signal menu_changed
var drag_state:= false
var user: String
var icons: Dictionary
var shell: Shell
var applist: Dictionary = {
	"settings.tres": "dock",
	"connections.tres": "dock",
	"power.tres": "dock"
}
var positions: Dictionary = {
	"settings.tres": 0,
	"connections.tres": 2,
	"power.tres": 4
}
var theme: MenuTheme = preload("res://theme/default/theme.tres")
var theme_path = "dev"
var content_folders: Array[String] = [
	"res://gd/applets/entries/",
	"/usr/share/applications/",
	"/run/host/usr/share/applications/",
	"/home/%USER%/.local/share/flatpak/exports/share/applications/",
	"/var/lib/flatpak/exports/share/applications/",
	"/home/%USER%/.local/share/applications/",
]
var config: Dictionary = {
	"menu_rows": 3,
	"menu_columns": 30,
	"menu_iconscale": 1,
	"dock_size": 5,
}

func _ready() -> void:
	menu_changed.connect(save_positions)
	if FileAccess.file_exists("user://icon_cache"):
		var file = FileAccess.open("user://icon_cache", FileAccess.READ)
		icons = JSON.parse_string(file.get_as_text())
	if FileAccess.file_exists("user://icon_positions"):
		var file = FileAccess.open("user://icon_positions", FileAccess.READ)
		positions = JSON.parse_string(file.get_as_text())
	if FileAccess.file_exists("user://icon_folders"):
		var file = FileAccess.open("user://icon_folders", FileAccess.READ)
		applist = JSON.parse_string(file.get_as_text())
	if FileAccess.file_exists("user://config"):
		var file = FileAccess.open("user://config", FileAccess.READ)
		config = JSON.parse_string(file.get_as_text())
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
	file = FileAccess.open("user://icon_folders", FileAccess.WRITE)
	file.store_line(JSON.stringify(applist))
	file = FileAccess.open("user://config", FileAccess.WRITE)
	file.store_line(JSON.stringify(config))

func get_line(line: String, in_arr: Array, devider:= "=") -> String:
	for i: String in in_arr:
		if i.begins_with(line+devider): 
			return i.replace(line+devider, "")
	return ""
