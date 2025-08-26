extends Resource
class_name Entry

@export var title: String
@export var iconpath: String
@export var filepath: String
@export var type_override = ""
@export var dynamic_iconpath = ""

static func open(path: String) -> Entry:
	if path.ends_with(".tres"):
		var tres =  await Executor.thread_load(path)
		if tres is Entry:
			return tres
		else: return null
	elif path.ends_with(".desktop"):
		return await DesktopEntry.open(path)
	else:
		return null

func icon() -> Texture:
	if iconpath == "": return null
	if FileAccess.file_exists(iconpath):
		var img = Image.load_from_file(iconpath)
		return ImageTexture.create_from_image(img)
	else: 
		push_warning(iconpath+" isn't a valid path")
		return preload("res://asset/Placeholder.png")

func dynamic_icon() -> PackedScene:
	var path = State.theme_path+"dynamic_"+dynamic_iconpath+".tscn"
	if FileAccess.file_exists(path):
		return load(path)
	return null

func get_type():
	if type_override.is_empty():
		if has_method("get_type_extended"):
			return call("get_type_extended")
		else: return "unknown"
	else: return type_override

func should_be_shown():
	return true
