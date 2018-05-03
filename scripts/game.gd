extends Node2D

onready var player = get_node("Player")
onready var timerOpenMouth = get_node("TimerOpenMouth")
onready var animation = get_node("Animation")
onready var scoreboard = get_node("ControlScore/ScoreBoard")
onready var lowerteeth = get_node("LowerTeeth")
onready var topteeth = get_node("TopTeeth")
onready var playerIdleAnimatedSprite= get_node("Player/AnimatedSprite")
onready var playerInFearSprite = get_node("Player/ShakeArms")
onready var playerScared = get_node("Player/PlayerScared")

var animMouthOpen  = false
var animMouthClose = false
var yPosTopTeethOpenMouth 	= -500
var yPosLowerTeethOpenMouth = 1900

var topTeethInPosition 	 = false
var lowerTeethInPosition = false

var initialTimeStartVibrating = 2
var timeStartVibrating = initialTimeStartVibrating

var jaIncrementouScore

var playerXPos

var jogarPlayerAnimCompleta = false
var randPosPlayer

onready var tween = get_node("Tween")
var property = "transform/pos"

var gameOver

var vel
var initialVel = 100

var initialTimeStartVibratingMin = .2

var goDown = false
var avaible_spaces
var sprite_player_size = 180
var score = 0
var highscore = 0
var song_is_playing = true

var initialVibration = 0.5
var vibration = 0
var alreadyVibrated = false

var mouthClosed

var safe_already

var posPlayer

var closeMouth = false

var offsetYTopTeeth = 300


#### Highscore
var save_file = File.new()
var save_path = "user://savegame.save"
var save_data = {"highscore":0, "hat":'default'}

func _ready():
	set_hat()
	get_node("Player/AnimationPlayer").play("move_hat")
	get_node("SamplePlayer").play("jungledrum")	
	playerInFearSprite.get_sprite_frames().set_animation_speed("default", 30)	
	randomize()
	set_process(true)	
	topteeth.set_pos(Vector2(cos(rad2deg(vibration))*2, offsetYTopTeeth))
	avaible_spaces = get_avaible_spaces()
	random_height()	
	play()
	
	if not save_file.file_exists(save_path):
		create_save()
	else:
		highscore = read("highscore")
				

func create_save():
	save_file.open(save_path, File.WRITE)
	save_file.store_var(save_data)
	save_file.close()
	
func save():
	save_data["highscore"] = highscore
	save_file.open(save_path,File.WRITE)
	save_file.store_var(save_data)
	save_file.close()
	
func read(attr):
	save_file.open(save_path, File.READ)
	save_data = save_file.get_var()
	save_file.close()
	return save_data[attr]


func vibrate():
	alreadyVibrated = false
	closeMouth = false
	initialTimeStartVibrating = initialTimeStartVibrating - score*.03
	if initialTimeStartVibrating < initialTimeStartVibratingMin:
		initialTimeStartVibrating = initialTimeStartVibratingMin
	timeStartVibrating = initialTimeStartVibrating	
	vibration = initialVibration	
		

func _process(delta):
	#print(topteeth.get_pos().y)
	if(goDown):
		#### Vibration
		if not alreadyVibrated:
			if timeStartVibrating > 0:
				timeStartVibrating -= delta
			else:				
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
			var avancoY = vel*delta
			var indiceTemp
			for i in range(9):
				if not safe_already.has(i):
					indiceTemp = i
					break
			var primeiroDenteSupYPos = topteeth.get_children()[indiceTemp].get_global_pos().y
			var primeiroDenteInfYPos = lowerteeth.get_children()[indiceTemp].get_global_pos().y
			var difAltura = primeiroDenteInfYPos - primeiroDenteSupYPos

			if difAltura - avancoY < 300:
				avancoY = difAltura - 300			
				mouthClosed = true

			topteeth.set_pos(Vector2(topteeth.get_pos().x,topteeth.get_pos().y + avancoY))
			
			if mouthClosed:
				stop_go_down()
			
	elif animMouthOpen:
		if !jaIncrementouScore:
			score_increment()
			player.set_gravity_scale(0)
			player.playerOnTooth = false
			player.podePisar = false
			#playerXPos = player.randXPos()
			#while player.get_pos().x == playerXPos:
			#	playerXPos = player.randXPos()
			#randPosPlayer = Vector2(playerXPos, 600)
			posPlayer = Vector2(360, 600)
			jaIncrementouScore = true
			moveToTarget(player, posPlayer, player.get_pos())	
		
		if topteeth.get_pos().y > yPosTopTeethOpenMouth:
			topteeth.set_pos(Vector2(topteeth.get_pos().x,topteeth.get_pos().y - 3000*delta+2))
		if lowerteeth.get_pos().y < yPosLowerTeethOpenMouth:
			lowerteeth.set_pos(Vector2(lowerteeth.get_pos().x,lowerteeth.get_pos().y + 1400*delta+2))
							
		if topteeth.get_pos().y < yPosTopTeethOpenMouth and lowerteeth.get_pos().y > yPosLowerTeethOpenMouth:
			animMouthOpen = false	
			avaible_spaces = get_avaible_spaces()
			random_height()
			animMouthClose = true
			#jogarPlayerAnimCompleta = false
			#for tooth in topteeth.get_children():
			#	tooth.set_pos(Vector2(tooth.get_pos().x, 0))
			#for tooth in lowerteeth.get_children():
			#	tooth.set_pos(Vector2(tooth.get_pos().x, 0))	
					
	
	elif animMouthClose:
		print("animClose", topteeth.get_pos(), topteeth.get_pos().y < 300, jogarPlayerAnimCompleta)
		if jogarPlayerAnimCompleta:		
			if topteeth.get_pos().y < 300:		
				print(topteeth.get_pos())		
				topteeth.set_pos(Vector2(topteeth.get_pos().x, topteeth.get_pos().y + 1500*delta))
			else:
				print("pos certa", score)
				topteeth.set_pos(Vector2(0, 300))		
				topTeethInPosition = true
				
			if lowerteeth.get_pos().y > 1130:
				lowerteeth.set_pos(Vector2(lowerteeth.get_pos().x,lowerteeth.get_pos().y - 4000*delta))
			else:
				lowerteeth.set_pos(Vector2(0, 1130))
				lowerTeethInPosition = true
				
			if topTeethInPosition and lowerTeethInPosition:
				topTeethInPosition 	 = false
				lowerTeethInPosition = false
				animMouthClose = false	
				player.set_gravity_scale(25)	
				player.podePisar = true		
				#player.podeSerMorto = true
				#player.canMove = true		
									
				play()
	
#	print(player.podeSerMorto)
	
	if jogarPlayerAnimCompleta and player.playerOnTooth:
		
		playerIdleAnimatedSprite.show()
		playerInFearSprite.hide()

		player.podeSerMorto = true
		player.canMove = true
		#player.set_gravity_scale(25)
		jogarPlayerAnimCompleta = false
	
#	print(player.podeSerMorto)
#	print(animMouthClose, player.playerOnTooth)

func moveToTarget(node, end, start):
	var distance = start.distance_to(end)	
	tween.interpolate_property(node, property, start, end, .6, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func random_height():
	var total_space = 350
	var height_low
	var height_top
	for i in range(0,9):
		if i == 4:
			height_low = int(rand_range(50,150))
			height_top = (total_space - height_low) - 300
		else:
			height_low = int(rand_range((total_space - 300),300))
			height_top = (total_space - height_low) - 300
		get_node("LowerTeeth/LowTooth"+str(i)).set_pos(Vector2(get_node("LowerTeeth/LowTooth"+str(i)).get_pos().x,(-1*height_low)))
		get_node("TopTeeth/TopTooth"+str(i)).set_pos(Vector2(get_node("TopTeeth/TopTooth"+str(i)).get_pos().x,height_top))

	safe_already = []
	#var safe_tooth = int(rand_range(0,9))
	#safe_already.append(safe_tooth)
	var posicoes = [0, 1, 2, 3, 5, 6, 7, 8]
	
	for i in range(avaible_spaces):
		var safe_tooth = posicoes[randi() % posicoes.size()]
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
	player.podeSerMorto = false
	playerIdleAnimatedSprite.hide()
	playerScared.show()
	timerOpenMouth.start()
	
	
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
	mouthClosed = false	
	#animation.play("lowerteetgoingup")
	#vibrate()
	#player.canMove = true
	#player.podeSerMorto = true
	#player.set_pos(Vector2(360,580))
	
	#topteeth.set_pos(Vector2(0,300))	
	#player.set_gravity_scale(25)
	vibrate()
	goDown = true
	#vel = log(750*(score+1) + 2.72)*initialVel
	vel = 2500
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
	player.set_pos(posPlayer)
	jogarPlayerAnimCompleta = true

func _on_MuteButton_pressed():
	if song_is_playing:
		get_node("SamplePlayer").stop_all()
		song_is_playing = false
		get_node("MuteButton").set_normal_texture(load("res://assets/audio_off.png"))
	else:
		get_node("MuteButton").set_normal_texture(load("res://assets/audio.png"))
		get_node("SamplePlayer").play("jungledrum")
		song_is_playing = true

func _on_TimerOpenMouth_timeout():	
	if not gameOver:
		animMouthOpen = true
		playerScared.hide()
		playerInFearSprite.show()

func set_hat():
	var active_hat = "res://assets/hats/"+read("hat")+".png"
	var hat = load(active_hat)
	#var hat = preload("res://assets/hats/default.png")
	get_node("Player/AnimatedSprite/Hat").set_texture(hat)
	get_node("Player/ShakeArms/HatShakeArms").set_texture(hat)
	get_node("Player/PlayerScared/HatPlayerScared").set_texture(hat)
	get_node("GameOverScreen/AnimatedSprite/HatAngel").set_texture(hat)