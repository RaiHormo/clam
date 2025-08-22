extends Node

func run(command: Array[String]):
	var args = command.duplicate()
	args.remove_at(0)
	var thread = Thread.new()
	var output: Array
	thread.start(OS.execute.bind(command[0], args, output))
	await thread.wait_to_finish()
	return output

func run_entry(entry: Entry):
	if entry is DesktopEntry:
		var exec: Array = Array(entry.get_line("Exec").split(" "))
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
		print("executing ", exec[0])
		print(args)
		OS.execute_with_pipe(exec[0], args)
	if entry is BuiltinEntry:
		if has_method(entry.filepath):
			call(entry.filepath)
	
func settings():
	var seti = load("res://gd/applets/settings.tscn").instantiate()
	get_tree().root.add_child(seti)
