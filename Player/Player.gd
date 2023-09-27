extends CharacterBody2D

var speed = 20
var deceleration = 4
var rotate_speed = .1
var maxspeed = 400
var nose = Vector2(60,0)
var health = 10
var dead = false
var Bullet = load("res://Player/bullet.tscn")
var Effects = null
var Explosion = load("res://Effects/Explosion.tscn")
var lastmousePos = Vector2(0,0)
var bursting = false

func shootBullet():
	var bullet = Bullet.instantiate()
	bullet.position = position + nose.rotated(rotation)
	bullet.rotation = rotation+deg_to_rad(90)
	var Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		Effects.add_child(bullet)

func burst():
	bursting = true
	speed = 1200
	maxspeed = 1200
	await get_tree().create_timer(1.0).timeout
	bursting = false
	speed = 15
	maxspeed = 400
	pass

func get_input():
	var mousePos = get_global_mouse_position()
	if mousePos.distance_to(lastmousePos) > 0 or mousePos.distance_to(position) > 25:
		look_at(mousePos)
	lastmousePos = mousePos
	$Exhaust.hide()
	if Input.is_action_pressed("Forward") or bursting:
		$Exhaust.show()
		velocity += transform.x *speed
	if not Input.is_action_pressed("Forward"):
		velocity = velocity.normalized()*(velocity.length()-deceleration)
	if Input.is_action_just_pressed("Shoot"):
		shootBullet()
	if Input.is_action_just_pressed("Burst"):
		burst()
	velocity = velocity.normalized() * clamp(velocity.length(),0,maxspeed)


func _physics_process(delta):
	Global.update_boost(.1)
	get_input()
	move_and_slide()
	position.x = wrapf(position.x,0-50,Global.VP.x+50)
	position.y = wrapf(position.y,0-50,Global.VP.y+50)

func damage(d):
	health -= d 
	if health <= 0 and not dead:
		dead = true
		Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instantiate()
			Effects.add_child(explosion)
			explosion.global_position = global_position
			hide()
			$CollisionPolygon2D.disabled = true
			$Area2D/CollisionPolygon2D.disabled = true
			await explosion.animation_finished
		Global.update_lives(-1)
		queue_free()
		


func _on_area_2d_body_entered(body):
	if body.name != "Player":
		damage(100)
