extends Node

var tokens : Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	registerWithConsole()

func registerWithConsole() -> void:
	get_parent().registerCommand("questToken", Callable(self, "executeCommand"))
	get_parent().registerCommand("questTokenAdd", Callable(self, "qt_add"))
	get_parent().registerCommand("questTokenRemove", Callable(self, "qt_remove"))

func executeCommand(args: PackedStringArray) -> String:
	var returnable : String = "questTokenExecuted"
	if len(args) == 0:
		return "Quest Token system accepts \"add\" and \"remove\" commands, or another string to check if the token exists."
	elif args[0] == "add":
		args.remove_at(0)
		returnable = qt_add(args)
	elif args[0] == "remove":
		args.remove_at(0)
		returnable = qt_remove(args)
	else: # Check if all remaining tags exist in the tokens
		for s : String in args:
			if s not in tokens:
				return "False"
		returnable = "True"
	return returnable

func qt_add(new_tokens : PackedStringArray) -> String:
	var returnable : String = ""
	var added_tokens : String = ""
	var present_tokens : String = ""
	# split on space or comma
	for new_token in new_tokens:
		# Single token
		if new_token in tokens: # We do not want duplicates
			present_tokens += new_token + ", "
		else:
			tokens.append(new_token)
			added_tokens += new_token + ", "
	tokens.sort()
	if len(added_tokens) > 0:
		returnable += "Added: " + added_tokens
	if len(present_tokens) > 0:
		returnable += "Already present: " + present_tokens
	return returnable

func qt_remove(the_doomed : PackedStringArray) -> String:
	var returnable : String = ""
	var removed_tokens : String = ""
	var missing_tokens : String = ""
	# split on space or comma
	for doomed_token in the_doomed:
		# Single token
		if doomed_token in tokens: # We do not want duplicates
			removed_tokens += doomed_token + ", "
			tokens.erase(doomed_token)
		else:
			missing_tokens += doomed_token + ", "
	if len(removed_tokens) > 0:
		returnable += "Removed: " + removed_tokens
	if len(missing_tokens) > 0:
		returnable += "Missing: " + missing_tokens
	return returnable