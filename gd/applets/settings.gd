extends CanvasLayer

@export var previous: Node = null
@export var current: String

func open(menu: String, from: Node = null):
	current = menu
	previous = from
	for i in %Scroll.get_children():
		if i is not Control: continue
		if i.name == menu: i.show()
		else: i.hide()
	$Window.show()
	$Fader.show()
	var t = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel()
	t.tween_property($Window, "position:y", $Window.position.y, 0.3).from(get_bottom()+50)
	t.tween_property($Fader, "modulate:a", 1, 0.3).from(0)
	get_node("%Scroll/"+current+"/Header/Back").grab_focus()

func back():
	if previous != null:
		previous.reopen()
	elif State.selection != null:
		State.selection.grab_focus()
	close()

func close():
	var t = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property($Window, "position:y", get_bottom()+50, 0.3)
	t.tween_property($Fader, "modulate:a", 0, 0.3)
	await t.finished
	queue_free()
	
func get_bottom():
	return get_viewport().get_visible_rect().get_center().y*2

func get_x():
	return get_viewport().get_visible_rect().get_center().x-$Window.size.x/2

func navigate() -> void:
	var foc =  get_viewport().gui_get_focus_owner()
	if foc != null and foc.has_meta("link"):
		Executor.settings(foc.get_meta("link"), self)
		var t = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel()
		t.tween_property($Window, "position:x", get_x()-$Window.size.x-50, 0.3)

func reopen():
	var t = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel()
	t.tween_property($Window, "position:x", get_x(), 0.3)
