extends Control

@export var path: String
@export_enum("variable", "stylebox_bg", "stylebox_border") var type

func _ready() -> void:
	match type:
		0:
			set(path, State.theme.accent_color)
		1:
			var box: StyleBoxFlat = get_theme_stylebox(path)
			box.bg_color = State.theme.accent_color
		2:
			var box: StyleBoxFlat = get_theme_stylebox(path)
			box.border_color = State.theme.accent_color
