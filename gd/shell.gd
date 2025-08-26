extends Control
class_name Shell
@onready var grid: PanelContainer = $Grid/GridScroll/HBoxContainer/GridPanel
var seen_apps: PackedStringArray


func _ready() -> void:
	var whoami: Array[String]
	OS.execute("whoami", [], whoami)
	State.user = whoami[0].trim_suffix("\n")
	call_deferred("fetch_apps")
	State.shell = self
	get_window().focus_entered.connect(restore)
	
func fetch_apps():
	seen_apps = []
	for i in State.content_folders:
		parse_app_folder(i)
	State.save_iconcache()
	State.applist.sort()

func parse_app_folder(dir: String):
	dir = dir.replace("%USER%", State.user)
	var app_folder = DirAccess.open(dir)
	if app_folder == null: return
	print(app_folder.get_files())
	var root_slots: Array[GridSlot] = []
	var dock_slots: Array[GridSlot] = []
	for i in app_folder.get_files():
		var slot = GridSlot.new()
		var entry = await Entry.open(dir+i)
		if entry != null and entry.should_be_shown():
			if i in seen_apps: continue
			seen_apps.append(i)
			if not State.applist.has(i):
				State.applist.set(i, "root")
			slot.entry = entry
			slot.filename = i
			slot.title = entry.title
			slot.icon = entry.icon()
			slot.set_dynamic_icon()
			if State.applist.get(i) == "root":
				root_slots.append(slot)
			if State.applist.get(i) == "dock":
				dock_slots.append(slot)
	grid.setup_slots(root_slots)
	$Grid/Dock.setup_slots(dock_slots)

func minimize():
	var t = create_tween().set_parallel()
	t.tween_property($Black, "modulate:a", 0, 0.5)
	t.tween_property($Grid, "modulate:a", 0, 0.5)
	t.tween_property($Grid, "scale", Vector2(0.5, 0.5), 0.5)
	await t.finished
	#get_window().mode = Window.MODE_MINIMIZED

func restore():
	var t = create_tween().set_parallel()
	t.tween_property($Black, "modulate:a", 1, 0.5)
	t.tween_property($Grid, "modulate:a", 1, 0.5)
	t.tween_property($Grid, "scale", Vector2.ONE, 0.5)
