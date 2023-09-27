extends CharacterBody2D

var initial_speed = 350.0
var health = 5

func appear():
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	$Sprite2D.modulate.a = 0
	tween.tween_property($Sprite2D, "modulate:a", 1, .5)
	#$Sprite2D.scale = Vector2(0,0)
	#tween.tween_property($Sprite2D, "scale", Vector2(1,1), .5)
	#tween.tween_callback(func():
		#$CollisionPolygon2D.disabled = false
		#)

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
		Global.update_score(100)
		Global.update_boost(10)
		queue_free()
