extends CanvasLayer

var next_path
var loadingAnimLength  = 1.0
var loadingAnimSteps   = 16
var loadingAnimStepLen = loadingAnimLength / loadingAnimSteps

onready var loadingSymbolSprite = get_node("Sprite")
onready var timerSteps = get_node("TimerSteps")

var _thread

func _ready():
#	loadingAnim()
	pass


func fade_to(path):
	loadingSymbolSprite.hide()
	#startLoadingAnim()
	next_path = path
	get_node("Anim").play("fade")	

func change_scene():	
	if next_path != null:
		get_tree().change_scene(next_path)		
		
func startLoadingAnim():
	_thread = Thread.new()
	_thread.start(self, "loadingAnim")

func loadingAnim(userdata):
	print("entrou")
	OS.delay_msec(100)
	loadingSymbolSprite.show()
	while true:
		print("rodando")
	#	timerSteps.set_wait_time(loadingAnimStepLen)
	#	timerSteps.start()
		OS.delay_msec(loadingAnimStepLen*1000)
		loadingSymbolSprite.set_rot(loadingSymbolSprite.get_rot() + deg2rad(360/loadingAnimSteps))
	
func _on_TimerSteps_timeout():
	loadingSymbolSprite.set_rot(loadingSymbolSprite.get_rot() + deg2rad(360/loadingAnimSteps))
	loadingAnim()
