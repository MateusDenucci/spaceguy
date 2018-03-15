extends Node


func _ready():
	pass


func _on_TextureButton_pressed():
	transition.fade_to("res://scenes/game.tscn")
