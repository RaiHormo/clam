extends Control

@onready var grid: GridContainer = $Grid/SmoothScrollContainer/HBoxContainer/PanelContainer/GridContainer

func _ready() -> void:
	var whoami: Array[String]
	OS.execute("whoami", [], whoami)
	State.user = whoami[0].trim_suffix("\n")
	for i in 200:
		var dub = grid.get_child(0).duplicate()
		dub.erase()
		grid.add_child(dub)
	call_deferred("fetch_apps")
	
func fetch_apps():
	var j = 0
	parse_app_folder("/usr/share/applications", j)
	parse_app_folder("/run/host/usr/share/applications/", j)
	var dir = "/home/"+State.user+"/.local/share/applications/"
	parse_app_folder(dir, j)

func parse_app_folder(dir: String, j = 0):
	var app_folder = DirAccess.open(dir)
	#print(app_folder.get_files())
	for i in app_folder.get_files():
		if i in State.applist: continue
		var slot = grid.get_child(j)
		var prev_j = j
		if State.positions.has(i):
			var pos = State.positions.get(i)  
			if pos < 0:
				slot = $Grid/Dock.get_child(abs(pos))
			else:
				j = State.positions.get(i) 
		while not (is_instance_valid(slot) and slot.filename.is_empty() and slot.extending < 0): 
			j += grid.columns
			if j > grid.get_child_count()-1:
				j =  max(0, j - grid.get_child_count()-2)
			slot = grid.get_child(j)
		var entry = DesktopEntry.open(dir+i)
		if entry != null and entry.get_line("NoDisplay") != "true":
			State.applist.append(i)
			slot.entry = entry
			slot.filename = i
			slot.title = entry.title
			slot.icon = entry.icon()
		else:
			j = prev_j
	State.save_iconcache()
