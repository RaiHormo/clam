extends Control

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
