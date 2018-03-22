extends Control

var time_to_restart = false

func _ready():
	set_process_input(true)
	

func start():
	get_node("HighScore").set_text("HIGHSCORE:  "+str(get_parent().highscore))	
	get_node("/root/Game/TimerCloseMouth").stop()
	show()
	get_node("SomAngel").play()
	get_node("AnimationGameOver").play("gameover")

func _on_Exit_pressed():
	get_tree().quit()

func _on_TryAgain_pressed():
	get_tree().reload_current_scene()

func _on_Menu_pressed():
	transition.fade_to("res://scenes/mainscreen.tscn")
