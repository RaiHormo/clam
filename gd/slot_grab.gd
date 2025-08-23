extends Control

var follow:= true
@onready var slot = $Slot

func _process(delta: float) -> void:
	if follow:
		position = get_viewport().get_mouse_position() - slot.size/2

func go_and_disappear(pos: Vector2 = State.selection.global_position):
	follow = false
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "position", pos, 0.3)
	await t.finished
	queue_free()
