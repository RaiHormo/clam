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
		1: return "January"
		2: return "February"
		3: return "March"
		4: return "April"
		5: return "May"
		6: return "June"
		7: return "July"
		8: return "August"
		9: return "September"
		10: return "October"
		11: return "November"
		12: return "December"
		_: return "???"

func get_weekday(m: int) -> String:
	match m:
		1: return "MON"
		2: return "TUE"
		3: return "WED"
		4: return "THU"
		5: return "FRI"
		6: return "SAT"
		7: return "SUN"
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
