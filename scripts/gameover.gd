extends Control

var time_to_restart = false

#onready var tryAgainButton = get_node("TryAgain")

func _ready():
	#set_process_input(true)
	pass
	
func start():
	#get_node("HighScore").set_text("HIGHSCORE:  "+str(get_parent().highscore))	
	#get_node("/root/Game/TimerCloseMouth").stop()
	
	#tryAgainButton.set_disabled(true)
	show()
	get_node("SomAngel").play()
	get_node("AnimationGameOver").play("gameover")

func _on_Exit_pressed():
	get_tree().quit()

func _on_TryAgain_pressed():
	get_tree().reload_current_scene()

func _on_Menu_pressed():
	transition.fade_to("res://scenes/mainscreen.tscn")
	
# Fiz essa funcao pra ativar os botoes apenas quando a animacao terminar, 
# mas acho que o jogador pode querer apertar antes pra recomecar mais rapido
func ativarBotoes():
	#tryAgainButton.set_disabled(false)
	pass
