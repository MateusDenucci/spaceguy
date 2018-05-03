extends Control

onready var options = get_node("ScrollContainer/VBoxContainer")

var save_file = File.new()
var save_path = "user://savegame.save"
var save_data = {"highscore":0, 'hat':'default'}

func _ready():
	#var dir = Directory.new()
	#dir.remove("user://savegame.save")
	if not save_file.file_exists(save_path):
		create_save()
	mark_current_hat()

func _on_MenuButton_pressed():
	transition.fade_to("res://scenes/mainscreen.tscn")


func create_save():
	save_file.open(save_path, File.WRITE)
	save_file.store_var(save_data)
	save_file.close()
	
func save(attr,data):
	save_data[attr] = data
	save_file.open(save_path,File.WRITE)
	save_file.store_var(save_data)
	save_file.close()
	
func read(attr):
	save_file.open(save_path, File.READ)
	save_data = save_file.get_var()
	save_file.close()
	return save_data[str(attr)]
	

func mark_current_hat():
	var active_hat = read("hat")
	options.get_node(active_hat+"/Checkmark").show()

func unmark_current_hat():
	var active_hat = read("hat")
	options.get_node(active_hat+"/Checkmark").hide()

func _on_IndianaBtn_pressed():
	unmark_current_hat()
	options.get_node("default/Checkmark").show()
	save("hat","default")
	

func _on_WinterBtn_pressed():
	unmark_current_hat()
	options.get_node("winter/Checkmark").show()
	save("hat","winter")


func _on_CapBtn_pressed():
	unmark_current_hat()
	options.get_node("cap/Checkmark").show()
	save("hat","cap")


func _on_VikingBtn_pressed():
	unmark_current_hat()
	options.get_node("viking/Checkmark").show()
	save("hat","viking")


func _on_SantaBtn_pressed():
	unmark_current_hat()
	options.get_node("santa/Checkmark").show()
	save("hat","santa")


func _on_PirateBtn_pressed():
	unmark_current_hat()
	options.get_node("pirate/Checkmark").show()
	save("hat","pirate")


func _on_KingBtn_pressed():
	unmark_current_hat()
	options.get_node("king/Checkmark").show()
	save("hat","king")
