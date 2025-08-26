extends PanelContainer

@onready var grid_v = $GridV
@export var folder = "root"
var current_rows: int = 0
var columns: int = 30

func _ready() -> void:
	State.menu_changed.connect(menu_changed)

func setup_slots(slots: Array[GridSlot]):
	var rows: int = State.config.get("menu_rows")
	if rows == 0:
		rows = 1
		State.config.set("menu_rows", 1)
	current_rows = rows
	var temp_column = $GridV/Column0
	var temp_slot = $GridV/Column0/Slot0
	var amount = State.applist.size()
	columns = ceili(float(amount)/float(rows))
	print(amount," ", rows," ", float(amount)/float(rows))
	while grid_v.get_child_count() < columns:
		var column = temp_column.duplicate()
		grid_v.add_child(column)
		column.name = "Column"+str(column.get_index())
		for i in column.get_children():
			i.erase()
	while grid_v.get_child_count() > columns:
		grid_v.get_child(-1).free()
	for i in grid_v.get_children():
		while i.get_child_count() < rows:
			var slot = temp_slot.duplicate()
			slot.erase()
			i.add_child(slot)
			slot.name = "Slot"+str(slot.get_index())
		while i.get_child_count() > rows:
			i.get_child(i.get_child_count()-1).free()
	var index: int = 0
	for slot in slots:
		if slot.filename in State.positions:
			index = State.positions.get(slot.filename)
		var row: GridSlot = slot_index(index)
		while not row.filename == "":
			index += 1
			if index >= rows*columns:
				index = 0
			row = slot_index(index)
		row.copy(slot)

func slot_index(index: int) -> GridSlot:
	var rows: int = State.config.get("menu_rows")
	index = min((rows)*(columns)-1, index)
	var column = grid_v.get_child(floori(index/rows))
	return column.get_child(index % rows)
	
func clear():
	for column in grid_v.get_children():
		for row in column.get_children():
			row.erase()

func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == null:
		if event.is_action("ui_right") or event.is_action("ui_left") or event.is_action("ui_up") or event.is_action("ui_down"):
			if is_instance_valid(State.selection): State.selection.grab_focus()
			else: grid_v.get_child(0).get_child(0).grab_focus()
	if event.is_action("ui_cancel"):
		get_viewport().gui_release_focus()
		State.selection = null
		State.menu_changed.emit()
	if event.is_action_pressed("ui_page_up"): State.config.set("menu_rows", current_rows+1)
	if event.is_action_pressed("ui_page_down"): State.config.set("menu_rows", current_rows-1)
	if current_rows != State.config.get("menu_rows") and not current_rows == 0:
		clear()
		get_tree().root.get_node("Shell").fetch_apps()

func menu_changed():
	for j in grid_v.get_children():
		for i: GridSlot in j.get_children():
			#i.rotation_degrees = -90
			if not i.filename.is_empty():
				State.positions.set(i.filename, (j.get_index()*State.config.get("menu_rows"))+i.get_index())
				State.applist.set(i.filename, folder)

func hide_top() -> void:
	State.selection = null
	State.menu_changed.emit()
