extends Node2D

onready var player = get_node("Player")
onready var timerclosemouth = get_node("TimerCloseMouth")
onready var animation = get_node("Animation")
onready var scoreboard = get_node("ControlScore/ScoreBoard")
onready var lowerteeth = get_node("LowerTeeth")
onready var topteeth = get_node("TopTeeth")

var vel
var initialVel = 100

var goDown = false
var avaible_spaces
var sprite_player_size = 180
var score = 0
var highscore = 0
var song_is_playing = true

var initialVibration = 3
var vibration = 0
var alreadyVibrated = false

var closeMouth = false

var offsetYTopTeeth = 200

#### Highscore
var save_file = File.new()
var save_path = "user://savegame.save"
var save_data = {"highscore":0}


func _ready():
	get_node("SamplePlayer").play("jungledrum")
	randomize()
	set_process(true)	
	#player.morto = false
	play()
	
	if not save_file.file_exists(save_path):
		create_save()
	else:
		read()

func create_save():
	save_file.open(save_path, File.WRITE)
	save_file.store_var(save_data)
	save_file.close()
	
func save():
	save_data["highscore"] = highscore
	save_file.open(save_path,File.WRITE)
	save_file.store_var(save_data)
	save_file.close()
	
func read():
	save_file.open(save_path, File.READ)
	save_data = save_file.get_var()
	save_file.close()
	highscore = save_data["highscore"]


	
func vibrate():
	vibration = initialVibration - score*.02	
	if vibration < 1:
		vibration = 1
	
func _process(delta):
	if(goDown):
		#### Vibration
		if not alreadyVibrated:
			if vibration > 0:
				#topteeth.set_pos(Vector2(cos(rad2deg(vibration)), sin(rad2deg(vibration))))
				#Se for vibrar em y, usar sen
				topteeth.set_pos(Vector2(cos(rad2deg(vibration))*2, offsetYTopTeeth))
				vibration -= delta
			else:
				topteeth.set_pos(Vector2(0,offsetYTopTeeth))
				closeMouth = true		
				alreadyVibrated = true
		
		### Close mouth
		if closeMouth:
			topteeth.set_pos(Vector2(topteeth.get_pos().x,topteeth.get_pos().y + vel*delta+2))
		

func random_height():
	var total_space = 350
	for i in range(0,9):
		var height_low = int(rand_range((total_space - 300),300))
		var height_top = (total_space - height_low) - 300
		get_node("LowerTeeth/LowTooth"+str(i)).set_pos(Vector2(get_node("LowerTeeth/LowTooth"+str(i)).get_pos().x,(-1*height_low)))
		get_node("TopTeeth/TopTooth"+str(i)).set_pos(Vector2(get_node("TopTeeth/TopTooth"+str(i)).get_pos().x,height_top))

	var safe_already = []
	#var safe_tooth = int(rand_range(0,9))
	#safe_already.append(safe_tooth)
	for i in range(0,avaible_spaces):
		var safe_tooth = int(rand_range(0,9))
		if(safe_already.has(safe_tooth) == false):
			safe_already.append(safe_tooth)
	for safe_tooth in safe_already:
		if( get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().y <= -180 ):
			get_node("LowerTeeth/LowTooth"+str(safe_tooth)).set_pos(Vector2(get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().x,get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().y+sprite_player_size))
		elif( get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().y <= -sprite_player_size/2 ):
			get_node("LowerTeeth/LowTooth"+str(safe_tooth)).set_pos(Vector2(get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().x,get_node("LowerTeeth/LowTooth"+str(safe_tooth)).get_pos().y+(sprite_player_size/2)))
			get_node("TopTeeth/TopTooth"+str(safe_tooth)).set_pos(Vector2(get_node("TopTeeth/TopTooth"+str(safe_tooth)).get_pos().x,get_node("TopTeeth/TopTooth"+str(safe_tooth)).get_pos().y-(sprite_player_size/2)))
		else:
			get_node("TopTeeth/TopTooth"+str(safe_tooth)).set_pos(Vector2(get_node("TopTeeth/TopTooth"+str(safe_tooth)).get_pos().x,get_node("TopTeeth/TopTooth"+str(safe_tooth)).get_pos().y-(sprite_player_size)))
			
func stop_go_down():
	player.canMove = false
	goDown = false
	timerclosemouth.start()

func _on_TimerCloseMouth_timeout():
	if !player.morto:
		play()
	
func get_avaible_spaces():
	var spaces
	if score <= 10:
		spaces = int(rand_range(1,4))
	elif score > 10 and score <= 20:
		spaces = int(rand_range(1,3))
	elif score > 20 and score <= 30:
		spaces = int(rand_range(1,2))
	else:
		spaces = 1
	return spaces
	
func play():

	timerclosemouth.stop()
	lowerteeth.set_pos(Vector2(0,1430))
	#animation.seek(0,true)
	avaible_spaces = get_avaible_spaces()
	
	animation.play("lowerteetgoingup")
	score_increment()	
	vibrate()
	player.canMove = true
	player.set_pos(Vector2(360,580))
	random_height()
	topteeth.set_pos(Vector2(0,300))	
	vibrate()
	alreadyVibrated = false
	goDown = true
	vel = log(250*score + 2.72)*initialVel

	
func score_increment():
	score += 1
	scoreboard.set_text(str(score))
	
func gameover():
	if(song_is_playing):
		get_node("GameOverScreen/SomDie").play()
	
	if(score > highscore):
		highscore = score
		save()
	player.hide()
	get_node("Control").hide()
	get_node("Blood").show()
	get_node("GameOverScreen").start()


func _on_MuteButton_pressed():
	if song_is_playing:
		get_node("SamplePlayer").stop_all()
		song_is_playing = false
	else:
		get_node("SamplePlayer").play("jungledrum")
		song_is_playing = true