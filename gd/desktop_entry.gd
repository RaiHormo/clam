extends Node
class_name DesktopEntry

var lines: PackedStringArray
var title: String
var iconpath: String

static func open(filepath: String) -> DesktopEntry:
	var file = FileAccess.open(filepath, FileAccess.READ)
	if not is_instance_valid(file) or not filepath.ends_with(".desktop"): return null
	file.get_as_text()
	var entry = DesktopEntry.new()
	entry.lines = file.get_as_text().split("\n")
	entry.title = entry.get_line("Name")
	
	var icon_param = entry.get_line("Icon")
	if icon_param == null: return null
	if icon_param.begins_with("/"):
		entry.iconpath = icon_param
	elif State.icons.has(icon_param):
		entry.iconpath = State.icons.get(icon_param)
	else:
		var output: Array
		OS.execute("python", ["external/get_icon.py" ,"--size=64", icon_param], output)
		entry.iconpath = output[0].split(": ")[3].replace("\n", "")
		if not FileAccess.file_exists(entry.iconpath) and FileAccess.file_exists(entry.iconpath.replace("/usr/share", "/run/host/usr/share")):
			entry.iconpath = entry.iconpath.replace("/usr/share", "/run/host/usr/share")
		State.icons.set(icon_param, entry.iconpath)
	return entry

func get_line(line: String):
	for i: String in lines:
		if i.begins_with(line+"="): 
			return i.replace(line+"=", "")

func icon() -> Texture:
	if FileAccess.file_exists(iconpath):
		var img = Image.load_from_file(iconpath)
		return ImageTexture.create_from_image(img)
	else: 
		push_warning(iconpath+" isn't a valid path")
		return preload("res://asset/Placeholder.png")
	
