extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func _on_Area2D_body_enter( body ):

	
	if(body.get_name() == "Player"):
		print(self.get_name())
		get_node("/root/Game").gameover()
	else:
		get_node("/root/Game").stop_go_down()
		#get_node("/root/Game").score_increment()
