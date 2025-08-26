extends Node

var settings_pack: PackedScene = preload("res://gd/applets/settings.tscn")

func run(command: Array[String]) -> PackedStringArray:
	var args = command.duplicate()
	args.remove_at(0)
	var thread = Thread.new()
	var output: Array
	print("execute ", command)
	thread.start(OS.execute.bind(command[0], args, output))
	await thread.wait_to_finish()
	var putout: PackedStringArray = output[0].split('\n')
	print(putout)
	return putout

func thread_load(path: String):
	ResourceLoader.load_threaded_request(path)
	while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame
	return ResourceLoader.load_threaded_get(path)

func run_entry(entry: Entry):
	if entry is DesktopEntry:
		var exec: Array = Array(State.get_line("Exec", entry.lines).split(" "))
		if State.get_line("Terminal", entry.lines) == "true":
			exec.push_front("xdg-terminal-exec")
		if OS.get_environment("container"):
			exec.push_front("--host")
			exec.push_front("flatpak-spawn")
		exec.erase("%U")
		exec.erase("%u")
		exec.erase("%F")
		exec.erase("@@")
		exec.erase("@@u")
		var args:= Array(exec.duplicate())
		args.remove_at(0)
		print("executing ", exec)
		OS.execute_with_pipe(exec[0], args)
		State.shell.minimize()
	if entry is BuiltinEntry:
		if has_method(entry.shell_open):
			call(entry.shell_open)
	
func settings(menu = "Home", from: Node = null):
	var seti = settings_pack.instantiate()
	get_tree().root.add_child(seti)
	seti.open(menu, from)

func slot_grabber() -> Control:
	var grabber = (await thread_load("res://gd/slot_grab.tscn")).instantiate()
	get_tree().root.add_child(grabber)
	return grabber
