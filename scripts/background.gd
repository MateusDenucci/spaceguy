extends Node2D

onready var anim = get_node("Anim")

var lengthMultiplier = 5.0

func _ready():
	anim.set_speed(1.0/lengthMultiplier)
