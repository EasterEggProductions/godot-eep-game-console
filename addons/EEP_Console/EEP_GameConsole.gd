extends Panel


var tweener : Tween
var open : bool = false

@onready var console_in : LineEdit = $console_in
@onready var console_out : Label = $console_out

var previousCommands : Array[String] = []
var commandCycler : int 

## Define a password to lock the console from player input
@export var password : String = ""
## Does the console start locked to player input?
@export var locked : bool = false

var registeredCommands : Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	console_in.text_submitted.connect(_on_text_submit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass


func _input(event : InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == 96:
			if is_instance_valid(tweener) and tweener.is_running():
				return
			console_toggle()
			get_viewport().set_input_as_handled()


func _on_text_submit(command : String) -> void:
	print(command)
	if command == "":
		return
	console_out.text += "\n" + command
	console_in.text = ""
	PlayerCommand(command)

func console_toggle() -> void:
	tweener = get_tree().create_tween()
	var dest : Vector2 = Vector2(0, 0)
	var color : Color = Color(1,1,1,1)
	if open:
		dest.y = -size.y
		color = Color(1,1,1,0)
	tweener.set_ease(Tween.EASE_OUT)
	tweener.set_trans(Tween.TRANS_QUART)
	tweener.tween_property(self, 'position', dest, 0.33)
	tweener.set_trans(Tween.TRANS_LINEAR)
	tweener.parallel().tween_property(self, 'modulate', color, 0.15)
	open = !open
	if open:
		$console_in.grab_focus()
		$console_in.caret_column = 18000000
	else:
		$console_in.release_focus()

func PlayerCommand(cmd : String) -> void:
	console_out.text += "\n" + ExecuteCommand(cmd)

func ExecuteCommand(cmd : String) -> String:
	var returnable : String =  "no command found"
	if cmd == "quit" or cmd == "exit" or cmd == "activate self destruct":
		get_tree().quit()
		returnable = "yes"
	var dig_command : PackedStringArray = cmd.split(" ")
	# built in commands
	var command : String = ""
	var args : PackedStringArray = [] # string array, yooo
	if "(" in cmd: # Presume we have a paren encapsulated argument
		command = cmd.substr(0, cmd.find('('))
		args = cmd.substr(cmd.find('(')+1, len(cmd) - (cmd.find('(')+2)).split(',')
	else:
		command = dig_command[0]
		args = dig_command.slice(1, len(dig_command))
	# console_log("Cmd= " + command + " Args=" + str(args)) #NOTE For debugging
	match command:
		"clear":
			clearReadout()
			returnable = ""
		"help": 
			returnable = "Easter Egg Productions Console v0.2 is a tool meant to allow runtime modification of settings and execution of code from in game modules. " +\
				"\nIt was created in conjunction with the Speakeasy NPC dialog system and as such natively holds quest tokens." +\
				"\nWhen you type in a command, it is broken up by spaces, and then executes them in order. For example \"questToken add tookDrink\" will" +\
				"\ngo to the QuestToken system, then give it \"add tookDrink\" which will add a token called \"tookDrink\"" +\
				"\nAny class can register a method that takes a list of strings and returns a string and should work fine with it." +\
				"\nFor a list of registered commands type \"listCommands\""
		"listCommands":
			returnable = "quit, exit, activate self destruct\nclear\nhelp\n"
			for com in registeredCommands.keys():
				returnable += com + "\n"
		_: # Syntax for default of switch/match statement
			if command in registeredCommands:
				returnable = registeredCommands[command].call(args)
	return returnable

func clearReadout() -> void:
	console_out.text = ""
		
func registerCommand(key : String, command : Callable) -> void:
	registeredCommands[key] = command

func console_log(msg : String) -> void:
	console_out.text += "\n" + msg

func debug_log(msg : String) -> void:
	if OS.is_debug_build() == false:
		return
	console_log(msg)
