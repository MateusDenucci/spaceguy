extends Node

var song_is_playing = true

var disable_btn = true
var save_file = File.new()
var save_path = "user://savegame.save"
var save_data = {
	"highscore":0,
 	'hat':'default',
	'coins': 0,
	'open_hats': [1,0,0,0,0,0,0]
}

var pathTelaJogo = "res://scenes/game.tscn"

func _ready():
#	var dir = Directory.new()
#	dir.remove(save_path)
	if not save_file.file_exists(save_path):
		create_save()
	read()

func create_save():
	save_file.open(save_path, File.WRITE)
	save_file.store_var(save_data)
	save_file.close()
	
func save(attr,data):
	save_data[attr] = data
	save_file.open(save_path,File.WRITE)
	save_file.store_var(save_data)
	save_file.close()
	
func read():
	save_file.open(save_path, File.READ)
	save_data = save_file.get_var()
	save_file.close()
	
func isSoundOn():
	return song_is_playing
	
func turnSoundOn():
	song_is_playing = true
	
func turnSoundOff():
	song_is_playing = false
