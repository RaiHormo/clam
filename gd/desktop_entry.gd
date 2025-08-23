extends Entry
class_name DesktopEntry

var lines: PackedStringArray

static func open(path: String) -> DesktopEntry:
	var file = FileAccess.open(path, FileAccess.READ)
	if not is_instance_valid(file) or not path.ends_with(".desktop"): return null
	file.get_as_text()
	var entry = DesktopEntry.new()
	entry.filepath = path
	entry.lines = file.get_as_text().split("\n")
	entry.title = State.get_line("Name", entry.lines)
	
	var icon_param = State.get_line("Icon", entry.lines)
	if icon_param == null: return null
	if icon_param.begins_with("/"):
		entry.iconpath = icon_param
	elif State.icons.has(icon_param):
		entry.iconpath = State.icons.get(icon_param)
	else:
		var output: Array
		output = await Executor.run(["python", "external/get_icon.py" ,"--size=64", icon_param])
		#OS.execute("python", ["external/get_icon.py" ,"--size=64", icon_param], output)
		entry.iconpath = output[0].split(": ")[3].replace("\n", "")
		if not FileAccess.file_exists(entry.iconpath) and FileAccess.file_exists(entry.iconpath.replace("/usr/share", "/run/host/usr/share")):
			entry.iconpath = entry.iconpath.replace("/usr/share", "/run/host/usr/share")
		State.icons.set(icon_param, entry.iconpath)
	return entry

	
func get_type_extended():
	if "steam" in State.get_line("Exec", lines): return "steam"
	return "native_app"
