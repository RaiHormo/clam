class_name GridSlot extends Button
@export var title: String
@export var filename: String = "":
	set(x):
		filename = x
		update()
var under_mouse:= false
@export var extension:= Vector2i(1, 1)
@export var extending:= -1
@export var entry: DesktopEntry

func _ready() -> void:
	focus_entered.connect(focus)
	button_down.connect(press)
	update()
	await get_tree().create_timer(0.1).timeout
	update()

func update():
	$Icon/Icon.texture = icon
	if filename.is_empty() and extending<0: 
		$Placeholder.show()
		$Icon.hide()
		$Border.hide()
	else:
		$Icon.show() 
		if extension == Vector2i.ONE and extending<0: $Border.show()
		else: $Border.hide()
		$Placeholder.hide()
		$Icon.size = size * Vector2(extension)
		$Focus.size = size * Vector2(extension)
		$Icon.pivot_offset = Vector2.ZERO
		$Icon.scale = Vector2(0.9, 0.9)
		if extending >= 0:
			var extender: GridSlot = get_parent().get_child(extending)
			if extender.filename.is_empty() or extender.extension == Vector2i.ONE:
				extending = -1
		if extension.x == 2:
			make_extension(find_valid_focus_neighbor(SIDE_RIGHT))
		if extension.y == 2:
			make_extension(find_valid_focus_neighbor(SIDE_BOTTOM))
		if extension == Vector2i(2,2):
			var neighbor = find_valid_focus_neighbor(SIDE_BOTTOM) 
			if is_instance_valid(neighbor):
				make_extension(neighbor.find_valid_focus_neighbor(SIDE_RIGHT))

func focus():
	update()
	if extending < 0:
		State.selection = self
		State.menu_changed.emit()
		$Focus.show()
		pivot_offset = $Focus.size/2
	else:
		var extender: GridSlot = get_parent().get_child(extending)
		extender.focus()

func press():
	scale = Vector2(0.9, 0.9)
	if extending >= 0:
		get_parent().get_child(extending).press()
	if not filename.is_empty() and not Input.is_action_pressed("ui_accept"):
		await get_tree().create_timer(0.5).timeout
		if button_pressed:
			scale = Vector2(0.9, 0.9)
			modulate = Color(1,1,1,0.6)
			get_viewport().gui_release_focus()
			State.drag_state = true
			while Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				await get_tree().process_frame
			State.drag_state = false
			modulate = Color.WHITE

func _on_mouse_entered() -> void:
	under_mouse = true
	if State.drag_state:
		while State.drag_state and under_mouse:
			modulate = Color.GRAY
			await get_tree().process_frame
		if not State.drag_state and is_instance_valid(State.selection):
			var temp = self.duplicate()
			copy(State.selection)
			State.selection.copy(temp)
			State.selection.update()
			grab_focus()
			State.menu_changed.emit()
		modulate = Color.WHITE


func _on_mouse_exited() -> void:
	under_mouse = false

func erase():
	filename = ""
	title = ""
	icon = null
	extending = -1
	extension = Vector2.ONE

func copy(item: GridSlot):
	filename = item.filename
	icon = item.icon
	title = item.title
	extension = item.extension

func _on_focus_exited() -> void:
	$Focus.hide()
	if extending >= 0: 
		get_parent().get_child(extending)._on_focus_exited()

func make_extension(neighbour: Control):
	if neighbour is GridSlot:
		neighbour.extending = get_index()
		neighbour.mouse_filter = Control.MOUSE_FILTER_PASS
		neighbour.update()


func _on_button_up() -> void:
	scale = Vector2(1, 1)
	if extending >= 0:
		get_parent().get_child(extending)._on_button_up()
