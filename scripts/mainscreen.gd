extends Node

onready var sprite = get_node("Sprite")
onready var control = get_node("Control")
onready var timer = get_node("Timer")
onready var button = get_node("Control/TextureButton")

onready var spTeste = get_node("Sprite2")
onready var animTeste = get_node("Anim")

func _ready():	
	button.set("disabled", false)
	showScene()

func _on_TextureButton_pressed():
	button.set("disabled", true)
	transition.fade_to("res://scenes/game.tscn", true)
	#goto_scene("res://scenes/game.tscn")
	#animTeste.play("teste")
	#var s = ResourceLoader.load_interactive((path))
	#Global.goto_scene("res://scenes/game.tscn")

func showScene():
	sprite.show()
	control.show()

func hideScene():
	sprite.hide()
	control.hide()
	
func _on_Timer_timeout():
	hideScene()

func _on_HatStore_pressed():
	transition.fade_to("res://scenes/hatstore.tscn")
