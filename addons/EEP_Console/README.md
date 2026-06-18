# EEP Game Console 

## Setup
Add the scene `eep_game_console.tscn` as an autoload with the name 'console' so that other addons that use it work seamlessly.

Make sure the console loads before anything that may depend on it, such as the FeatherAudioManager (FAM)

## Registering things with the console
You can add new commands to the console like so:
```
	console.registerCommand("FAM", _console_command)
	#  name typed into console^            ^callable that will be used
```

The callable should take in a `PackedStringArray` as args, and return a `String`. See questToken.gd for a simple example.
