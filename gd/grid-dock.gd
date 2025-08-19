extends HBoxContainer

func _ready() -> void:
	State.menu_changed.connect(save_slots)

func save_slots():
	for i in get_children():
		if not i.filename.is_empty():
			State.positions.set(i.filename, -i.get_index())
