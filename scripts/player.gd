extends RigidBody2D

var canMove = true #necessary

func _ready():
	pass

func _on_Right_input_event( viewport, event, shape_idx ):
	if(event.type == InputEvent.SCREEN_TOUCH) and event.pressed and canMove:
		move_right()


func _on_Left_input_event( viewport, event, shape_idx ):
	if(event.type == InputEvent.SCREEN_TOUCH) and event.pressed and canMove:
		move_left()

func move_right():
	var  constant = get_parent().get_node("LowerTeeth").get_pos().y - 228
	if(self.get_pos().x == 40):
		self.set_pos(Vector2(120,get_parent().get_node("LowerTeeth/LowTooth1").get_pos().y + constant))
	elif(self.get_pos().x == 120):
		self.set_pos(Vector2(200,get_parent().get_node("LowerTeeth/LowTooth2").get_pos().y + constant))
	elif(self.get_pos().x == 200):
		self.set_pos(Vector2(280,get_parent().get_node("LowerTeeth/LowTooth3").get_pos().y + constant))
	elif(self.get_pos().x == 280):
		self.set_pos(Vector2(360,get_parent().get_node("LowerTeeth/LowTooth4").get_pos().y + constant))
	elif(self.get_pos().x == 360):
		self.set_pos(Vector2(440,get_parent().get_node("LowerTeeth/LowTooth5").get_pos().y + constant))
	elif(self.get_pos().x == 440):
		self.set_pos(Vector2(520,get_parent().get_node("LowerTeeth/LowTooth6").get_pos().y + constant))
	elif(self.get_pos().x == 520):
		self.set_pos(Vector2(600,get_parent().get_node("LowerTeeth/LowTooth7").get_pos().y + constant))
	elif(self.get_pos().x == 600):
		self.set_pos(Vector2(680,get_parent().get_node("LowerTeeth/LowTooth8").get_pos().y + constant))

func move_left():
	var  constant = get_parent().get_node("LowerTeeth").get_pos().y - 228 #I think 228 it is because of the character size
	if (self.get_pos().x == 120):
		self.set_pos(Vector2(40,get_parent().get_node("LowerTeeth/LowTooth0").get_pos().y + constant))
	elif (self.get_pos().x == 200):
		self.set_pos(Vector2(120,get_parent().get_node("LowerTeeth/LowTooth1").get_pos().y + constant))
	elif (self.get_pos().x == 280):
		self.set_pos(Vector2(200,get_parent().get_node("LowerTeeth/LowTooth2").get_pos().y + constant))
	elif (self.get_pos().x == 360):
		self.set_pos(Vector2(280,get_parent().get_node("LowerTeeth/LowTooth3").get_pos().y + constant))
	elif (self.get_pos().x == 440):
		self.set_pos(Vector2(360,get_parent().get_node("LowerTeeth/LowTooth4").get_pos().y + constant))
	elif (self.get_pos().x == 520):
		self.set_pos(Vector2(440,get_parent().get_node("LowerTeeth/LowTooth5").get_pos().y + constant))
	elif (self.get_pos().x == 600):
		self.set_pos(Vector2(520,get_parent().get_node("LowerTeeth/LowTooth6").get_pos().y + constant))
	elif (self.get_pos().x == 680):
		self.set_pos(Vector2(600,get_parent().get_node("LowerTeeth/LowTooth7").get_pos().y + constant))



