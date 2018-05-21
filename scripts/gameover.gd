extends Control

var admob = null
var isReal = false
var adInterId = "ca-app-pub-3940256099942544/1033173712"
var adRewardedId = "ca-app-pub-3940256099942544/5224354917"
#var adBannerId = "ca-app-pub-3940256099942544/6300978111"
#var adInterId = "ca-app-pub-3455131815008956/6028386143"


onready var tryAgainButton = get_node("TryAgain")
onready var menuButton = get_node("Menu")
onready var exitButton = get_node("Exit")


func _ready():
	ativarBotoes()
	randomize()
	if(Globals.has_singleton("AdMob")):
		admob = Globals.get_singleton("AdMob")
		admob.init(isReal, get_instance_ID())
		loadInterstitial()
		loadRewardedVideo()
	#set_process_input(true)
	

func loadInterstitial():
	if admob != null:
		admob.loadInterstitial(adInterId)

func start():
	get_node("HighScore").set_text("HIGHSCORE :  "+str(get_parent().highscore))	
	show()	
	get_node("SomAngel").play()
	get_node("AnimationGameOver").play("gameover")

func _on_Exit_pressed():
	desativarBotoes()
	get_tree().quit()

func _on_TryAgain_pressed():
	desativarBotoes()
	var random = int(rand_range(0,4))
	if(random == 2):
		showInterstitialAd()
	#var cur = get_tree().get_current_scene()
	#print(get_tree().get_current_scene().get_name())
	#get_tree().reload_current_scene()
	#get_node("/root").get_children()[-1]
	#get_node("/root").add_child(cur)
	#cur.queue_free()
	transition.reloadGame()
					
func showInterstitialAd():
	if admob != null:
		admob.showInterstitial()

func _on_Menu_pressed():
	desativarBotoes()
	showInterstitialAd()
	transition.fade_to("res://scenes/mainscreen.tscn")
	
func desativarBotoes():
	tryAgainButton.set("disabled", true)
	menuButton.set("disabled", true)
	exitButton.set("disabled", true)
	
func ativarBotoes():
	tryAgainButton.set("disabled", false)
	menuButton.set("disabled", false)
	exitButton.set("disabled", false)
	

func _on_rewarded_video_ad_loaded():
	Global.disable_btn = false
	#get_node("CoinsScreen/GetCoins").set_disabled(false)