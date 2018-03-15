extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _on_Area2D_body_enter( body ):

	get_node("/root/Game").stop_go_down()
	if(body.get_name() == "Player"):
		#print(body.get_name())
		get_node("/root/Game/Animation").play("die")
	else:
		pass
		#get_node("/root/Game").score_increment()
