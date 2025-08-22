@tool
extends GridContainer
@export var rows: int = 3:
	set(x):
		rows = x
		_on_pre_sort_children()

func _ready() -> void:
	State.menu_changed.connect(menu_changed)

func menu_changed():
	_on_pre_sort_children()

func _on_pre_sort_children() -> void:
	columns = ceili(float(get_child_count()) / float(rows))
	for i in get_children():
		i.update()
	for i: GridSlot in get_children():
		#i.rotation_degrees = -90
		if not i.filename.is_empty():
			State.positions.set(i.filename, i.get_index())

func _on_smooth_scroll_container_scroll_started() -> void:
	State.selection = null
	State.menu_changed.emit()

func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_focus_owner() == null:
		if event.is_action("ui_right") or event.is_action("ui_left") or event.is_action("ui_up") or event.is_action("ui_down"):
			if is_instance_valid(State.selection): State.selection.grab_focus()
			else: get_child(0).grab_focus()
	if event.is_action("ui_cancel"):
		get_viewport().gui_release_focus()
		State.selection = null
		State.menu_changed.emit()
	
func _on_smooth_scroll_container_scroll_ended() -> void:
	pass # Replace with function body.
