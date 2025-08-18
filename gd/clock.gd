extends Label

var t

func tick():
	var time = Time.get_datetime_dict_from_system()
	text = "%02d:%02d:%02d" % [time.hour, time.minute, time.second]
	var month = get_month(time.month)
	var weekday = get_weekday(time.weekday)
	$Date.text = "%s %d %s" % [weekday, time.day, month.to_upper()]

func get_month(m: int) -> String:
	match m:
		0: return "January"
		1: return "February"
		2: return "March"
		3: return "April"
		4: return "May"
		5: return "June"
		6: return "July"
		7: return "August"
		8: return "September"
		9: return "October"
		10: return "November"
		11: return "December"
		_: return "???"

func get_weekday(m: int) -> String:
	match m:
		0: return "MON"
		1: return "TUE"
		2: return "WED"
		3: return "THU"
		4: return "FRI"
		5: return "SAT"
		6: return "SUN"
		_: return "???"

func appear():
	tick()
	if is_instance_valid(t): t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "modulate:a", 1, 1)

func disappear():
	if is_instance_valid(t): t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	t.tween_property(self, "modulate:a", 0, 0.3)
