extends Control

@onready var fill: Panel = $Bat/Fill
@onready var precentage: Label = $Bat/Precentage
@onready var battery: Sprite2D = $Bat/Battery

func _ready() -> void:
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	var upower: Array = await Executor.run(
		["bash", "-c", 'upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage | grep -o "[0-9]*"'])
	var num: String = upower[0]
	if num != "":
		$Bat.show()
		$Power.hide()
		print(precentage)
		precentage.text = num
		fill.size.y = remap(num.to_int(), 0, 100, 0, 85)
	else:
		$Bat.hide()
		$Power.show()
