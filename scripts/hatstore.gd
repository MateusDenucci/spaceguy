extends Control

var admob = null
var isReal = false
var adRewardedId = "ca-app-pub-3940256099942544/5224354917" # [There is no testing option for rewarded videos, so you can use this id for testing]

onready var options = get_node("ScrollContainer/VBoxContainer")
var active_hat = Global.save_data["hat"]

var ultimaPosMouse = Vector2()

onready var scrollContainer = get_node("ScrollContainer")
var posInicialContainer

func _ready():
	posInicialContainer = scrollContainer.get_pos()
	get_node("CoinsScreen/GetCoins").set_disabled(Global.disable_btn)
	if(Globals.has_singleton("AdMob")):
		admob = Globals.get_singleton("AdMob")
		admob.init(isReal, get_instance_ID())
		loadRewardedVideo()
	set_process_input(true)
		
	open_hats()
	mark_current_hat()
	set_coins()

func _input(event):
	if(event.type == InputEvent.SCREEN_TOUCH):
		ultimaPosMouse = event.pos
	if(event.type == InputEvent.SCREEN_DRAG):
		var posContainer = Vector2(scrollContainer.get_pos().x, scrollContainer.get_pos().y + (event.pos.y - ultimaPosMouse.y)/20)
		if posContainer.y > posInicialContainer.y:
			posContainer = posInicialContainer
		elif posContainer.y < -450:
			posContainer.y = -450
		print(posContainer)
		scrollContainer.set_pos(posContainer)

func open_hats():
	var open_hats = Global.save_data['open_hats']
	var all_hats = get_node("ScrollContainer/VBoxContainer").get_children()
	var hat
	for i in range(open_hats.size()):
		hat = all_hats[i].get_children()
		if open_hats[i] == 0:
			hat[2].hide()
			hat[4].show()

func _on_MenuButton_pressed():
	transition.fade_to("res://scenes/mainscreen.tscn")

func loadRewardedVideo():
	if admob != null:
		admob.loadRewardedVideo(adRewardedId)


func mark_current_hat():
	options.get_node(active_hat+"/Checkmark").show()

func unmark_current_hat():
	active_hat = Global.save_data["hat"]
	options.get_node(active_hat+"/Checkmark").hide()

func _on_IndianaBtn_pressed():
	unmark_current_hat()
	options.get_node("default/Checkmark").show()
	Global.save("hat","default")
	

func _on_WinterBtn_pressed():
	if Global.save_data['open_hats'][1] == 1:
		unmark_current_hat()
		options.get_node("winter/Checkmark").show()
		Global.save("hat","winter")
	else:
		var coins = Global.save_data['coins']
		if coins >= 2:
			Global.save('coins',(coins - 2))
			var open_hats = Global.save_data['open_hats']
			open_hats[1] = 1
			Global.save('open_hats',open_hats)
			options.get_node("winter/Label").show()
			options.get_node("winter/Requirements").hide()
			set_coins()


func _on_CapBtn_pressed():
	if Global.save_data['open_hats'][2] == 1:
		unmark_current_hat()
		options.get_node("cap/Checkmark").show()
		Global.save("hat","cap")
	else:
		var coins = Global.save_data['coins']
		if coins >= 3 and Global.save_data['highscore'] >= 10:
			Global.save('coins',(coins - 3))
			var open_hats = Global.save_data['open_hats']
			open_hats[2] = 1
			Global.save('open_hats',open_hats)
			options.get_node("cap/Label").show()
			options.get_node("cap/Requirements").hide()
			set_coins()

func _on_VikingBtn_pressed():
	if Global.save_data['open_hats'][3] == 1:
		unmark_current_hat()
		options.get_node("viking/Checkmark").show()
		Global.save("hat","viking")
	else:
		var coins = Global.save_data['coins']
		if coins >= 4 and Global.save_data['highscore'] >= 20:
			Global.save('coins',(coins - 4))
			var open_hats = Global.save_data['open_hats']
			open_hats[3] = 1
			Global.save('open_hats',open_hats)
			options.get_node("viking/Label").show()
			options.get_node("viking/Requirements").hide()
			set_coins()

func _on_SantaBtn_pressed():
	if Global.save_data['open_hats'][4] == 1:
		unmark_current_hat()
		options.get_node("santa/Checkmark").show()
		Global.save("hat","santa")
	else:
		var coins = Global.save_data['coins']
		if coins >= 5 and Global.save_data['highscore'] >= 35:
			Global.save('coins',(coins - 5))
			var open_hats = Global.save_data['open_hats']
			open_hats[4] = 1
			Global.save('open_hats',open_hats)
			options.get_node("santa/Label").show()
			options.get_node("santa/Requirements").hide()
			set_coins()

func _on_PirateBtn_pressed():
	if Global.save_data['open_hats'][5] == 1:
		unmark_current_hat()
		options.get_node("pirate/Checkmark").show()
		Global.save("hat","pirate")
	else:
		var coins = Global.save_data['coins']
		if coins >= 5 and Global.save_data['highscore'] >= 50:
			Global.save('coins',(coins - 5))
			var open_hats = Global.save_data['open_hats']
			open_hats[5] = 1
			Global.save('open_hats',open_hats)
			options.get_node("pirate/Label").show()
			options.get_node("pirate/Requirements").hide()
			set_coins()

func _on_KingBtn_pressed():
	if Global.save_data['open_hats'][6] == 1:
		unmark_current_hat()
		options.get_node("king/Checkmark").show()
		Global.save("hat","king")
	else:
		var coins = Global.save_data['coins']
		if coins >= 7 and Global.save_data['highscore'] >= 80:
			Global.save('coins',(coins - 7))
			var open_hats = Global.save_data['open_hats']
			open_hats[6] = 1
			Global.save('open_hats',open_hats)
			options.get_node("king/Label").show()
			options.get_node("king/Requirements").hide()
			set_coins()


func _on_CoinsButton_pressed():
	get_node("ScrollContainer").hide()
	get_node("CoinsScreen").show()
	
func _on_rewarded_video_ad_loaded():
	get_node("CoinsScreen/GetCoins").set_disabled(false)
	Global.disable_btn = false
	
func _on_rewarded_video_ad_closed():
	get_node("CoinsScreen/GetCoins").set_disabled(true)
	loadRewardedVideo()
	
func _on_rewarded(currency, amount):
	var total = Global.save_data['coins'] + (amount/10)
	Global.save("coins",total)
	set_coins()

func set_coins():
	get_node("QtdCoins").set_text(str(Global.save_data['coins']))

func _on_GetCoins_pressed():
	if admob != null:
		admob.showRewardedVideo()

func _on_StoreButton_pressed():
	get_node("ScrollContainer").show()
	get_node("CoinsScreen").hide()
