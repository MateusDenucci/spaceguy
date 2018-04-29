extends Node

onready var sprite = get_node("Sprite")
onready var control = get_node("Control")
onready var timer = get_node("Timer")

func _ready():	
	showScene()

func _on_TextureButton_pressed():
	transition.fade_to("res://scenes/game.tscn")

func showScene():
	sprite.show()
	control.show()

func hideScene():
	sprite.hide()
	control.hide()
	
func _on_Timer_timeout():
	hideScene()
