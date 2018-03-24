extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _on_Area2D_body_enter( body ):
	if(body.get_name() == "Player" and !get_node("/root/Game/Player").morto and get_node("/root/Game/Player").podeSerMorto):
		get_node("/root/Game").gameover()
		get_node("/root/Game/Player").morto = true
	else:
		#print(body.get_name())
		get_node("/root/Game").stop_go_down()
		
		
		
		
		
		