extends Node2D

onready var player = get_node("Player")
onready var timerclosemouth = get_node("TimerCloseMouth")
onready var animation = get_node("Animation")
onready var scoreboard = get_node("ControlScore/ScoreBoard")
onready var lowerteeth = get_node("LowerTeeth")
onready var topteeth = get_node("TopTeeth")

var animMouthOpen  = false
var animMouthClose = false
var yPosTopTeethOpenMouth 	= -500
var yPosLowerTeethOpenMouth = 1900

var jaIncrementouScore

var playerXPos

var jogarPlayerAnimCompleta = false
var randPosPlayer

onready var tween = get_node("Tween")
var property = "transform/pos"

var gameOver

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

var offsetYTopTeeth = 300

#### Highscore
var save_file = File.new()
var save_path = "user://savegame.save"
var save_data = {"highscore":0}


func _ready():
	get_node("SamplePlayer").play("jungledrum")
	randomize()
	set_process(true)	
	avaible_spaces = get_avaible_spaces()
	random_height()	
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
	vibration = initialVibration - score*.05	
	if vibration < 1:
		vibration = 1
		

func _process(delta):
	#print(topteeth.get_pos().y)
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
			
	elif animMouthOpen:
		if !jaIncrementouScore:
			score_increment()
			player.set_gravity_scale(0)
			playerXPos = player.randXPos()
			while player.get_pos().x == playerXPos:
				playerXPos = player.randXPos()
			randPosPlayer = Vector2(playerXPos, 600)
			jaIncrementouScore = true
				
		moveToTarget(player, randPosPlayer, player.get_pos())		
		
		if topteeth.get_pos().y > yPosTopTeethOpenMouth:
			topteeth.set_pos(Vector2(topteeth.get_pos().x,topteeth.get_pos().y - 1500*delta+2))
		if lowerteeth.get_pos().y < yPosLowerTeethOpenMouth:
			lowerteeth.set_pos(Vector2(lowerteeth.get_pos().x,lowerteeth.get_pos().y + 700*delta+2))
							
		if topteeth.get_pos().y < yPosTopTeethOpenMouth and lowerteeth.get_pos().y > yPosLowerTeethOpenMouth:
			animMouthOpen = false	
			avaible_spaces = get_avaible_spaces()
			random_height()
			animMouthClose = true
			jogarPlayerAnimCompleta = false
			#for tooth in topteeth.get_children():
			#	tooth.set_pos(Vector2(tooth.get_pos().x, 0))
			#for tooth in lowerteeth.get_children():
			#	tooth.set_pos(Vector2(tooth.get_pos().x, 0))			
	
	elif animMouthClose:
		if jogarPlayerAnimCompleta:		
			if topteeth.get_pos().y < 300:
				topteeth.set_pos(Vector2(topteeth.get_pos().x,topteeth.get_pos().y + 700*delta+2))
			else:
				topteeth.set_pos(Vector2(0, 300))
				
			if lowerteeth.get_pos().y > 1130:
				lowerteeth.set_pos(Vector2(lowerteeth.get_pos().x,lowerteeth.get_pos().y - 2000*delta+2))
			else:
				lowerteeth.set_pos(Vector2(0, 1130))
				
			if topteeth.get_pos().y == 300 and lowerteeth.get_pos().y == 1130:
				animMouthClose = false	
				print("agui")
				player.set_gravity_scale(100)			
				player.podeSerMorto = true
				player.canMove = true	
					
				play()
				
#	#if player.onTooth():
#		player.podeSerMorto = true
#		player.canMove = true
#		#player.set_gravity_scale(25)

func moveToTarget(node, end, start):
	var distance = start.distance_to(end)	
	tween.interpolate_property(node, property, start, end, .6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

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
	if not gameOver:
		animMouthOpen = true
	player.podeSerMorto = false
	

func _on_TimerCloseMouth_timeout():
	if !player.morto:
		play()
	
func get_avaible_spaces():
	var spaces
	if score <= 10:
		spaces = int(rand_range(2,4))
	elif score > 10 and score <= 20:
		spaces = int(rand_range(1,3))
	elif score > 20 and score <= 30:
		spaces = int(rand_range(1,2))
	else:
		spaces = 1
	return spaces
	
func play():

	#timerclosemouth.stop()
	#lowerteeth.set_pos(Vector2(0,1430))
	#animation.seek(0,true)
	gameOver = false	
	
	#animation.play("lowerteetgoingup")
	#vibrate()
	#player.canMove = true
	#player.podeSerMorto = true
	#player.set_pos(Vector2(360,580))
	
	#topteeth.set_pos(Vector2(0,300))	
	player.set_gravity_scale(25)
	vibrate()
	alreadyVibrated = false
	goDown = true
	vel = log(250*(score+1) + 2.72)*initialVel
	
	jaIncrementouScore = false

	
func score_increment():
	score += 1
	scoreboard.set_text(str(score))
	#play()
	
func gameover():
	if(song_is_playing):
		get_node("GameOverScreen/SomDie").play()
	
	if(score > highscore):
		highscore = score
		save()
	gameOver = true
	player.hide()
	get_node("Control").hide()
	get_node("Blood").show()
	get_node("GameOverScreen").start()

func _on_Tween_tween_complete( object, key ):
	player.set_pos(randPosPlayer)
	jogarPlayerAnimCompleta = true

func _on_MuteButton_pressed():
	if song_is_playing:
		get_node("SamplePlayer").stop_all()
		song_is_playing = false
	else:
		get_node("SamplePlayer").play("jungledrum")
		song_is_playing = true