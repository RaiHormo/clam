extends Control

@onready var grid: GridContainer = $Grid/SmoothScrollContainer/HBoxContainer/PanelContainer/GridContainer
var collumns = 40

func _ready() -> void:
	var whoami: Array[String]
	OS.execute("whoami", [], whoami)
	State.user = whoami[0].trim_suffix("\n")
	while grid.get_child_count() < grid.rows*collumns:
		var dub = grid.get_child(0).duplicate()
		dub.erase()
		grid.add_child(dub)
	call_deferred("fetch_apps")
	
func fetch_apps():
	var j = 0
	for i in State.content_folders:
		parse_app_folder(i, j)
	State.save_iconcache()
	State.applist.sort()

func parse_app_folder(dir: String, j = 0):
	dir = dir.replace("%USER%", State.user)
	var app_folder = DirAccess.open(dir)
	if app_folder == null: return
	#print(app_folder.get_files())
	for i in app_folder.get_files():
		if i in State.applist: continue
		var slot = grid.get_child(j)
		var prev_j = j
		if State.positions.has(i):
			var pos = State.positions.get(i)  
			if pos < 0:
				slot = $Grid/Dock.get_child(abs(pos)-1)
			else:
				slot = grid.get_child(State.positions.get(i))
		while not (is_instance_valid(slot) and slot.filename.is_empty() and slot.extending < 0): 
			j += grid.columns
			if j > grid.get_child_count()-1:
				j =  max(0, j - grid.get_child_count()+1)
			slot = grid.get_child(j)
		var entry = await DesktopEntry.open(dir+i)
		if entry != null and State.get_line("NoDisplay", entry.lines) != "true" and not "Proton" in entry.title:
			State.applist.append(i)
			slot.entry = entry
			slot.filename = i
			slot.title = entry.title
			slot.icon = entry.icon()
			slot.set_dynamic_icon()
		else:
			j = prev_j
