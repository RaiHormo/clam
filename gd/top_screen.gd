extends CanvasLayer

func _ready() -> void:
	State.menu_changed.connect(update_topscreen)
	update_topscreen()

func update_topscreen():
	if not is_instance_valid(State.selection) or State.selection.filename.is_empty():
		$Clock.appear()
		$Icon.hide()
		$Title.hide()
	else: 
		$Clock.disappear()
		$Title.show()
		$Icon.show()
		$Title/Label.text = State.selection.title
		$Icon.texture = State.selection.icon

func _input(event: InputEvent) -> void:
	if event.is_action("ui_right") or event.is_action("ui_left") or event.is_action("ui_up") or event.is_action("ui_down"):
		State.get_window().grab_focus()
		if is_instance_valid(State.selection): State.selection.grab_focus()
		else: get_child(0).grab_focus()
