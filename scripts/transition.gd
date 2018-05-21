extends CanvasLayer

var next_path

onready var anim = get_node("Anim")
onready var animLoading = get_node("AnimLoading")

onready var loadingSymbolSprite = get_node("Sprite")
onready var barra = get_node("Barra")
onready var marc = get_node("Barra/Marcador")
onready var logo = get_node("Logo")

var loader
var wait_frames
var time_max = 100 # msec
var current_scene

var telaJogo

var mostrarLoading

var _thread

func _ready():
	pass


func fade_to(path, mostrarLoadingParam=false):
	#loadingSymbolSprite.hide()
	#startLoadingAnim()
	marc.set_region_rect(Rect2(0, 0, 0, 23))
	mostrarLoading = mostrarLoadingParam
	next_path = path
	anim.play("fade")	

func change_scene():	
	anim.set_speed(0)	
	if mostrarLoading:
		barra.show()
		#loadingSymbolSprite.show()
		#animLoading.play("loading")
	goto_scene(next_path, mostrarLoading)
	#if next_path != null:
	#	get_tree().change_scene(next_path)		
	
func goto_scene(path, mostrarLoading):  
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		show_error()
		return
	set_process(true)
	
	current_scene.queue_free() # get rid of the old scene
	
	wait_frames = 1

func _process(time):
    if loader == null:
        # no need to process anymore
        set_process(false)
        return

    if wait_frames > 0: # wait for frames to let the "loading" animation to show up
        wait_frames -= 1
        return

    var t = OS.get_ticks_msec()
    while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread

        # poll your loader
        var err = loader.poll()

        if err == ERR_FILE_EOF: # load finished
            var resource = loader.get_resource()
            loader = null
            barra.hide()
            #loadingSymbolSprite.hide()
            anim.set_speed(1)
            #if mostrarLoading:                
                #animLoading.stop()
            set_new_scene(resource)
            break
        elif err == OK:
            update_progress()
        else: # error during loading
            show_error()
            loader = null
            break

func update_progress():
	if mostrarLoading:            
		var progress = float(loader.get_stage()) / loader.get_stage_count()
		
		marc.set_region_rect(Rect2(0, 0, progress*188, 23))
		marc.set_pos(Vector2(-(1-progress)*188/2, 0))
		
		# or update a progress animation?
		#var len = get_node("AnimLoading").get_current_animation_length()
		# call this on a paused animation. use "true" as the second parameter to force the animation to update
		#get_node("AnimLoading").seek(progress * len, true)

func set_new_scene(scene_resource):
    current_scene = scene_resource.instance()
    telaJogo = scene_resource
    get_node("/root").add_child(current_scene)
    #print(get_node("/root").get_children()[-1])
    #get_tree().set_current_scene(get_node("/root").get_children()[-1])

func reloadGame():
	get_node("/root").get_children()[-1].queue_free()
	get_node("/root").add_child(telaJogo.instance())