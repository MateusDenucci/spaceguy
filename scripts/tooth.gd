extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var rayCast = get_node("StaticBody2DTooth/RayCast")

func _ready():
	pass

func _on_Area2D_body_enter( body ):
#	print("col")
	#if(body.get_name() == "Player" and !get_node("/root/Game/Player").morto and get_node("/root/Game/Player").podeSerMorto):
	if(body.get_name() == "Player" and !get_node("/root").get_children()[-1].get_node("Player").morto and get_node("/root").get_children()[-1].get_node("Player").podeSerMorto):
		get_node("/root").get_children()[-1].gameover()
		get_node("/root").get_children()[-1].get_node("Player").morto = true
		
#	else:
#		if rayCast.is_colliding():
#			#print(body.get_name())
#			print("col")
#			get_node("/root/Game").stop_go_down()
			
		
		
		
		
		
		