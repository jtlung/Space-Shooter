extends CharacterBody2D

var initial_speed = 350.0
var health = 5
var size = "medium"
var boostUp = 1
var scoreUp = 25
var Explosion = load("res://Effects/Explosion.tscn")

func updateSize(newSize):
	size = newSize
	if size == "large":
		scale = Vector2(2,2)
		health = 10
		boostUp *= 2
		scoreUp *= 2
	elif size == "small":
		scale = Vector2(.65,.65)
		health = 1
		boostUp *= 2
		scoreUp *= 2

func appear():
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	$Sprite2D.modulate.a = 0
	tween.tween_property($Sprite2D, "modulate:a", 1, .5)
	#$Sprite2D.scale = Vector2(0,0)
	#tween.tween_property($Sprite2D, "scale", Vector2(1,1), .5)
	#tween.tween_callback(func():
		#$CollisionPolygon2D.disabled = false
		#)

func split():
	var newSize = "small"
	if size == "large":
		newSize = "medium"
	var pxSize = $Sprite2D.texture.get_size()
	for i in 2:
		Global.spawnAsteroid(position,newSize)

func _ready():
	appear()
	velocity = Vector2(0,initial_speed*randf()).rotated(2*PI*randf())

func _physics_process(_delta):
	velocity = velocity.normalized()*clamp(velocity.length(),0,initial_speed)
	move_and_slide()
	position.x = wrapf(position.x,0-50,Global.VP.x+50)
	position.y = wrapf(position.y,0-50,Global.VP.y+50)

func damage(d):
	health -= d
	if health <= 0:
		Global.update_score(scoreUp)
		Global.update_boost(boostUp)
		var Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instantiate()
			Effects.add_child(explosion)
			explosion.global_position = global_position
		if size != "small":
			split()
		queue_free()
