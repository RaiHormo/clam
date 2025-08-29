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
	var cur: VBoxContainer = get_node("%Scroll/"+current)
	cur.get_node("Header/Back").grab_focus()
	#await get_tree().process_frame
	$Window.size.y = min(cur.size.y+50, get_viewport().get_visible_rect().size.y - 50)
	var t = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel()
	t.tween_property($Fader, "modulate:a", 1, 0.3).from(0)
	t.tween_property($Window, "position:y", get_y(), 0.3).from(get_bottom()+50)
	match menu:
		"Home":
			var brightness = (await Executor.run(["external/brightnessctl", "g", "-P"]))[0].to_int()
			$Window/Scroll/Home/Brightness/HSlider.value = brightness

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

func get_y():
	return get_viewport().get_visible_rect().size.y-$Window.size.y

func navigate() -> void:
	var foc =  get_viewport().gui_get_focus_owner()
	if foc != null and foc.has_meta("link"):
		Executor.settings(foc.get_meta("link"), self)
		var t = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel()
		t.tween_property($Window, "position:x", get_x()-$Window.size.x-50, 0.3)

func reopen():
	var t = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel()
	t.tween_property($Window, "position:x", get_x(), 0.3)


func brightness_slider(value: float) -> void:
	Executor.run(["external/brightnessctl", "s", str(value)+"%"])

func sleep():
	Executor.run(["systemctl", "suspend"])
	back()

func power_off():
	Executor.run(["pkexec" ,"systemctl", "poweroff"])

func reboot():
	Executor.run(["pkexec" ,"systemctl", "reboot"])

func quit():
	get_tree().quit()
