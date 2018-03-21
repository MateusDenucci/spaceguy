extends Control

var time_to_restart = false

func _ready():
	set_process_input(true)
	
func _input(event):
	if event.type == InputEvent.SCREEN_TOUCH and time_to_restart:
		get_tree().reload_current_scene()

func start():
	print("gameoverscreen")
	get_node("/root/Game/TimerCloseMouth").stop()
	show()
	get_node("AnimationGameOver").play("angel_up")
	get_node("Timer").start()

func _on_Timer_timeout():
	time_to_restart = true
	get_node("Timer").stop()
	get_node("PlayAgain").show()