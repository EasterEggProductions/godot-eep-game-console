extends Node

## Feather Audio Manager (FAM)
## System to manage common components of game audio.
## One off sound effects for things like UI, and music.

var music_aud : AudioStreamPlayer

## A list of loaded effects
var effects = {}

## Songs should not be loaded as needed 
## Later this may be a resource that holds metadata like song mood or something 
var songs = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load in example music files
	songs["dungeon_loop"] = load("res://addons/EEP_FeatherAudioManager/music/BGM Dungeon Loop.ogg")
	songs["town_loop"] = load("res://addons/EEP_FeatherAudioManager/music/BGM Town Loop.ogg")

	# load in example effects 
	effects["ui_big_confirm"] = load("res://addons/EEP_FeatherAudioManager/effects/SFX UI Big Confirm.ogg")
	effects["ui_confirm"] = load("res://addons/EEP_FeatherAudioManager/effects/SFX UI Confirm.ogg")
	effects["ui_navigate"] = load("res://addons/EEP_FeatherAudioManager/effects/SFX UI Navigate.ogg")

	# TODO - Come up with a better way of handling these sounds. We want them to be handled by name, so they 
	# can be swapped out later if need be, so a better system for loading an managing that is needed, perhaps
	# a resource 

	# Create a music player
	music_aud = AudioStreamPlayer.new()
	music_aud.name = "Music"
	music_aud.process_mode = Node.PROCESS_MODE_ALWAYS # keep processing during pause
	music_aud.bus = "Music"
	add_child(music_aud)
	play_song("town_loop")
	register_with_console()

## Plays a specific song
func play_song(song_name : String):
	if song_name in songs.keys():
		# TODO - smooth song transition 
		music_aud.stop()
		music_aud.stream = songs[song_name]
		music_aud.play()
		
## Plays an effect once, for UI sounds or speakeasy dialog
func play_effect(effect_name : String):
	if effect_name in effects.keys():
		var effect = AudioStreamPlayer.new()
		add_child(effect)
		effect.stream = effects[effect_name]
		effect.bus = "SFX"
		effect.play()
		effect.connect("finished", effect.queue_free)



func _console_command(commands : PackedStringArray) -> String:
	if commands[0].to_lower() == "play":
		if commands[1] in songs.keys():
			play_song(commands[1])
			return "Playing " + commands[1]
		else:
			return commands[1] + "not found"
	elif commands[0].to_lower() == "sfx":
		if commands[1] in effects.keys():
			play_effect(commands[1])
			return "Playing effect " + commands[1]
		else:
			return "SFX " + commands[1] + "not found"
	else:
		return "FAM can play music and effects\nFAM play <song name>\nFAM sfx <effect name>\nTo play a song, or effect respectively"




# Registers commands with the EEP game console
func register_with_console():
	if console:
		print("console or something called that exists")
		console.registerCommand("FAM", _console_command)
