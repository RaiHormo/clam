extends HBoxContainer

func _ready() -> void:
	State.menu_changed.connect(save_slots)

func save_slots():
	for i in get_children():
		if not i.filename.is_empty():
			State.positions.set(i.filename, i.get_index())
			State.applist.set(i.filename, "dock")

func setup_slots(slots: Array[GridSlot]):
	while get_child_count() < State.config.get("dock_size"):
		var dub = get_child(0).duplicate()
		dub.erase()
		add_child(dub)
	for i in slots:
		if State.positions.has(i.filename):
			var pos = min(State.positions.get(i.filename), State.config.get("dock_size")-1)
			get_child(pos).copy(i)
		else:
			for j in get_children():
				if j.filename == "":
					j.copy(i)
					break
