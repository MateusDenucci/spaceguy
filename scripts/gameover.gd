extends Control

var admob = null
var isReal = true
var adInterId = "ca-app-pub-3940256099942544/1033173712"
var adRewardedId = "ca-app-pub-3940256099942544/5224354917"
#var adBannerId = "ca-app-pub-3940256099942544/6300978111"
#var adInterId = "ca-app-pub-3455131815008956/6028386143"


func _ready():
	randomize()
	if(Globals.has_singleton("AdMob")):
		admob = Globals.get_singleton("AdMob")
		admob.init(isReal, get_instance_ID())
		loadInterstitial()
		loadRewardedVideo()
	#set_process_input(true)
	
func loadRewardedVideo():
	if admob != null:
		admob.loadRewardedVideo(adRewardedId)
		
func loadInterstitial():
	if admob != null:
		admob.loadInterstitial(adInterId)
		
func start():
	get_node("HighScore").set_text("HIGHSCORE :  "+str(get_parent().highscore))	
	show()
	get_node("SomAngel").play()
	get_node("AnimationGameOver").play("gameover")

func _on_Exit_pressed():
	if admob != null:
		admob.showRewardedVideo()
	get_tree().quit()

func _on_TryAgain_pressed():
	var random = int(rand_range(0,4))
	if(random == 2):
		showInterstitialAd()
	get_tree().reload_current_scene()
			
func showInterstitialAd():
	if admob != null:
		admob.showInterstitial()

func _on_Menu_pressed():
	showInterstitialAd()
	transition.fade_to("res://scenes/mainscreen.tscn")
	
# Fiz essa funcao pra ativar os botoes apenas quando a animacao terminar, 
# mas acho que o jogador pode querer apertar antes pra recomecar mais rapido
func ativarBotoes():
	#tryAgainButton.set_disabled(false)
	pass
