# Feather Audio Manager (FAM)
Feather is a sonomancer, and this tool is built to manage in game music, and allow one off sound effects for things like UI. 

## Setup
Add the script `FeatherAudioManager.gd` as an autoload named 'FAM'. Now from code you can load in music and sound effects like this:

```
FAM.load_song("res://path_to/my_audiosteam.ogg", "my_cool_song")
FAM.load_effect("res://path_to/my_sound_effect.wav", "ui_button")
```

This will load in the audio resources, and save them to a dictionary, allowing them to be referenced by the name you set. 

Once they are loaded in, you can play them like so:
```
# Plays music and keeps playing between scene changes, uses the "Music" audio bus for volume
FAM.play_song("my_cool_song")

# Plays effect once on the "SFX" audio bus for volume
FAM.play_effect("ui_button") 
```

These can also be accessed in the EEP_Console. Press the tilde to bring down the console at runtime then type:
`FAM play my_cool_song` to change the currently playing song, or `FAM SFX ui_button` to play one off effects. 
Note, the music functionality changes the currently playing song, while the effect functionality will play effects over each other.

## Roadmap

- Music fading in and out on song change to stop clicks during audio transitions. 
- Automatic music DJ based on 'mood' paramiters. Possibly a list of strings with weights for things like daytime, exploration, combat, which then chooses an appropriate song to match the mood. 
- Lists to load up batches of effects for certain purposes, allowing for some kind of 'audio theme' for UI buttons.
