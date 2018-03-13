extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass
	

var score = 0
func _on_Area2D_body_enter( body ):
	#print(score)
	get_node("/root/Game").stop_go_down()
	if(body.get_name() == "Player"):
		pass
		#print("dead")
		#print(score)
		#get_node("/root/Game/Lifes/Life0").queue_free()
	else:
		score += 1
	
