extends Node

var song_is_playing = true

func _ready():
	pass

func isSoundOn():
	return song_is_playing
	
func turnSoundOn():
	song_is_playing = true
	
func turnSoundOff():
	song_is_playing = false