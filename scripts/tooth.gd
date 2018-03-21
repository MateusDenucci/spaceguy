extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _on_Area2D_body_enter( body ):
	if(body.get_name() == "Player" and !get_node("/root/Game/Player").morto):
		get_node("/root/Game").gameover()
		get_node("/root/Game/Player").morto = true
	elif(body.get_name() != "Player" and get_node("/root/Game/Player").morto):
		get_node("/root/Game").stop_go_down()
		#get_node("/root/Game").score_increment()
