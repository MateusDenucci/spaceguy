extends Control

var admob = null
var isReal = false
var adRewardedId = "ca-app-pub-3940256099942544/5224354917" # [There is no testing option for rewarded videos, so you can use this id for testing]

onready var options = get_node("ScrollContainer/VBoxContainer")
var active_hat = Global.save_data["hat"]


func _ready():
	get_node("CoinsScreen/GetCoins").set_disabled(Global.disable_btn)
	if(Globals.has_singleton("AdMob")):
		admob = Globals.get_singleton("AdMob")
		admob.init(isReal, get_instance_ID())
		loadRewardedVideo()
		
	mark_current_hat()
	open_hats()
	set_coins()

func open_hats():
	var open_hats = Global.save_data['open_hats']
	var all_hats = get_node("ScrollContainer/VBoxContainer").get_children()
	var btn
	for i in range(open_hats.size()):
		btn = all_hats[i].get_children()[0]
		if open_hats[i] == 0:
			btn.set_disabled(true)

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
	unmark_current_hat()
	options.get_node("winter/Checkmark").show()
	Global.save("hat","winter")


func _on_CapBtn_pressed():
	unmark_current_hat()
	options.get_node("cap/Checkmark").show()
	Global.save("hat","cap")


func _on_VikingBtn_pressed():
	unmark_current_hat()
	options.get_node("viking/Checkmark").show()
	Global.save("hat","viking")


func _on_SantaBtn_pressed():
	unmark_current_hat()
	options.get_node("santa/Checkmark").show()
	Global.save("hat","santa")


func _on_PirateBtn_pressed():
	unmark_current_hat()
	options.get_node("pirate/Checkmark").show()
	Global.save("hat","pirate")


func _on_KingBtn_pressed():
	unmark_current_hat()
	options.get_node("king/Checkmark").show()
	Global.save("hat","king")


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