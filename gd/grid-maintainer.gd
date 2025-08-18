@tool
extends GridContainer
@export var rows: int = 3:
	set(x):
		rows = x
		_on_sort_children()

func _ready() -> void:
	State.menu_changed.connect(menu_changed)

func menu_changed():
	pass

func _on_sort_children() -> void:
	columns = ceili(float(get_child_count()) / float(rows))

func _on_smooth_scroll_container_scroll_started() -> void:
	State.selection = null
	State.menu_changed.emit()


func _on_smooth_scroll_container_scroll_ended() -> void:
	pass # Replace with function body.
