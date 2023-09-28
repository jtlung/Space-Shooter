extends Node

var VP = Vector2.ZERO
var score = 0
var lives = 0
var time = 0
var boost = 0
var Asteroid = load("res://Asteroid/asteroid.tscn")
var maxAsteroid = 5
var map = Vector2(1500,1500)

func spawnAsteroid(spawnPos=null, size = "medium"):
	var Asteroid_Container = get_node_or_null("/root/Game/Asteroid_Container")
	var newAsteroid = Asteroid.instantiate()
	Asteroid_Container.add_child(newAsteroid)
	var RNG = randi_range(0,1)
	var offset = -50+100*RNG
	newAsteroid.updateSize(size)
	if spawnPos:
		newAsteroid.position = spawnPos
	else:
		if randi_range(0,1):
			newAsteroid.position = Vector2(VP.x*RNG+offset,randi_range(0,VP.y))
		else:
			newAsteroid.position = Vector2(randi_range(0,VP.x),VP.y*RNG+offset)

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	randomize()
	VP = get_viewport().size
	var _signal = get_tree().get_root().size_changed.connect(_resize)
	reset()
	
func _process(_delta):
	if Input.is_action_just_pressed("Quit"):
		var menu = get_node_or_null("/root/Game/UI/Menu")
		if menu == null:
			get_tree().quit()
		else:
			if menu.visible:
				get_tree().paused = false
				menu.hide()
			else:
				get_tree().paused = true
				menu.show()
	var Asteroid_Container = get_node_or_null("/root/Game/Asteroid_Container")
	var Enemy_Container = get_node_or_null("/root/Game/Enemy_Container")
	if Asteroid_Container != null and Enemy_Container != null:
		var AsteroidNum = Asteroid_Container.get_child_count()
		var EnemyNum = Enemy_Container.get_child_count()
		if AsteroidNum < maxAsteroid + clamp(floor(Global.time/15),0,12):
			var size = "medium"
			if randi_range(1,3) == 3:
				size = "large"
			spawnAsteroid(null,size)
		#if Asteroid_Container.get_child_count() == 0 and Enemy_Container.get_child_count() == 0:
			#get_tree().change_scene_to_file("res://UI/end_game.tscn")

func update_lives(x):
	lives+= x
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_lives()
	if lives <= 0:
		get_tree().change_scene_to_file("res://UI/end_game.tscn")

func update_score(x):
	score+= x
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_score()
	
func update_time(x):
	time+= x
	
func _resize():
	VP = get_viewport().size
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_lives()

func update_boost(x):
	boost+= x
	boost = clamp(boost,0,100)
	var hud = get_node_or_null("/root/Game/UI/HUD")
	if hud != null:
		hud.update_boost()

func reset():
	get_tree().paused = false
	boost = 50
	score = 0
	time = 0
	lives = 5
