# godot-eep-game-console
A Godot implementation of the Easter Egg Productions game console.

Add the addons/EEP_console directory to your project. Then go to project settings, globals, and register a new global from the path ```res://addons/EEP_Console/eep_game_console.tsch``` make sure it is named ```console```. 

Now you can open it in your game by pressing the grave key, the one to the left of the 1 and above tab. 

By default it comes with QuestToken

## Features
* Registering new commands that other systems may use.
* Password protect and lock the console
* Print debug statements with console.console_log(msg) and console.debug_log(msg)

## Default Commands
* exit
  * closes the game
* help
  * displays a help message
* listCommands
  * This will print a list of commands
* clear
  * Clears the current console output
 
## Commands from code
The console has two functions to run commands, to run it from code use the ExecuteCommand function:
```
console.ExecuteCommand("questToken add quest_10_failure")
```
If you need to, capture the returned string, and use it for whatever you need::
```
var tok_present = console.ExecuteCommand("questToken quest_10_failure")
if tok_present == "True":
  do_something()
```

## Quest Token
Quest token is a basic tag system. You can add and remove keys to it, or check if they are present. It was made for the speakeasy dialog system, and is kept as a legacy basic implementation. 
Commands:
* add myToken
  * This will add your new token to the internal list.
* remove myToken
  * This will remove the token from the list if present.
* [none] myToken
  * This will return true or false if the token is present or not. 

structure a whole command like this:

```questToken add myNewToken```

## Adding new commands
The syntax for adding new commands is to access the console, and provide an alias and callable:

```
func registerWithConsole() -> void:
	console.registerCommand("questToken", Callable(self, "executeCommand"))
	console.registerCommand("questTokenAdd", Callable(self, "qt_add"))
	console.registerCommand("questTokenRemove", Callable(self, "qt_remove"))
```
A single class can add as many commands as needed. The callable should be a function that takes in a list of strings as arguments, and returns a string. By default the returned string will print to the console:
```
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
```
