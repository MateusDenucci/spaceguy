extends Control

var time_to_restart = false

func _ready():
	set_process_input(true)
	
#func _input(event):
#	if event.type == InputEvent.SCREEN_TOUCH and time_to_restart:
#		get_tree().reload_current_scene()

func start():
	#get_node("HighScore").set_text("HIGHSCORE:  "+str(get_parent().highscore))	
	get_node("/root/Game/TimerCloseMouth").stop()
	show()
	get_node("AnimationGameOver").play("angel_up")
	get_node("Timer").start()

func _on_Timer_timeout():
	time_to_restart = true
	get_node("Timer").stop()

func _on_Exit_pressed():
	get_tree().quit()

func _on_TryAgain_pressed():
	get_tree().reload_current_scene()

func _on_Menu_pressed():
	transition.fade_to("res://scenes/mainscreen.tscn")
