extends Node2D

onready var player = get_node("Player")
onready var timerclosemouth = get_node("TimerCloseMouth")
onready var animation = get_node("Animation")


onready var lowerteeth = get_node("LowerTeeth")
onready var lowtooth0 = get_node("LowerTeeth/LowTooth0")
onready var lowtooth1 = get_node("LowerTeeth/LowTooth1")
onready var lowtooth2 = get_node("LowerTeeth/LowTooth2")
onready var lowtooth3 = get_node("LowerTeeth/LowTooth3")
onready var lowtooth4 = get_node("LowerTeeth/LowTooth4")
onready var lowtooth5 = get_node("LowerTeeth/LowTooth5")
onready var lowtooth6 = get_node("LowerTeeth/LowTooth6")
onready var lowtooth7 = get_node("LowerTeeth/LowTooth7")
onready var lowtooth8 = get_node("LowerTeeth/LowTooth8")

onready var topteeth = get_node("TopTeeth")
onready var toptooth0 = get_node("TopTeeth/TopTooth0")
onready var toptooth1 = get_node("TopTeeth/TopTooth1")
onready var toptooth2 = get_node("TopTeeth/TopTooth2")
onready var toptooth3 = get_node("TopTeeth/TopTooth3")
onready var toptooth4 = get_node("TopTeeth/TopTooth4")
onready var toptooth5 = get_node("TopTeeth/TopTooth5")
onready var toptooth6 = get_node("TopTeeth/TopTooth6")
onready var toptooth7 = get_node("TopTeeth/TopTooth7")
onready var toptooth8 = get_node("TopTeeth/TopTooth8")


var goDown = true
var avaible_spaces = 3
var sprite_player_size = 155

func _ready():
	randomize()
	#lowerteeth.set_pos(Vector2(lowerteeth.get_pos().x,lowerteeth.get_pos().y - 400))
	animation.play("lowerteetgoingup")
	random_height()
	set_process(true)
	
func _process(delta):
	if(goDown):
		topteeth.set_pos(Vector2(topteeth.get_pos().x,topteeth.get_pos().y + delta+2))

func random_height():
	var total_space = 350
	for i in range(0,9):
		var height_low = int(rand_range((total_space - 300),300))
		var height_top = (total_space - height_low) - 300
		get_node("LowerTeeth/LowTooth"+str(i)).set_pos(Vector2(get_node("LowerTeeth/LowTooth"+str(i)).get_pos().x,-height_low))
		get_node("TopTeeth/TopTooth"+str(i)).set_pos(Vector2(get_node("TopTeeth/TopTooth"+str(i)).get_pos().x,height_top))
	
	#var i = 4
	#get_node("LowerTeeth/LowTooth"+str(i)).set_pos(Vector2(get_node("LowerTeeth/LowTooth"+str(i)).get_pos().x,0))
	#get_node("TopTeeth/TopTooth"+str(i)).set_pos(Vector2(get_node("TopTeeth/TopTooth"+str(i)).get_pos().x,-300))
	var safe_already = []
	var safe_tooth = int(rand_range(0,9))
	safe_already.append(safe_tooth)
	for i in range(0,avaible_spaces-1):
		var safe_tooth = int(rand_range(0,9))
		if(safe_already.has(safe_tooth) == false):
			safe_already.append(safe_tooth)
		
	for safe_tooth in safe_already:
		if( get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().y <= -180 ):
			get_node("LowerTeeth/LowTooth"+str(safe_tooth)).set_pos(Vector2(get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().x,get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().y+sprite_player_size))
		else:
			get_node("LowerTeeth/LowTooth"+str(safe_tooth)).set_pos(Vector2(get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().x,get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().y+(sprite_player_size/2)))
			get_node("TopTeeth/TopTooth"+str(safe_tooth)).set_pos(Vector2(get_node("TopTeeth/TopTooth"+str(safe_tooth)).get_pos().x,get_node("TopTeeth/TopTooth"+str(safe_tooth)).get_pos().y-(sprite_player_size/2)))
			
func stop_go_down():
	#print("stop!")
	player.canMove = false
	goDown = false
	timerclosemouth.start()

func _on_TimerCloseMouth_timeout():
	print("timeout")
	timerclosemouth.stop()
	lowerteeth.set_pos(Vector2(0,1430))
	animation.seek(0,true)
	animation.play("lowerteetgoingup")
	
	player.canMove = true
	player.set_pos(Vector2(360,580))
	#animation.play("lowerteethgoingdown")
	random_height()
	topteeth.set_pos(Vector2(0,0))
	goDown = true
	
