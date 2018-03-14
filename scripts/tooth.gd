extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _on_Area2D_body_enter( body ):

	get_node("/root/Game").stop_go_down()
	if(body.get_name() == "Player"):
		pass
		#print("dead")
		#get_node("/root/Game/Lifes/Life0").queue_free()
	else:
		pass
		#get_node("/root/Game").score_increment()
