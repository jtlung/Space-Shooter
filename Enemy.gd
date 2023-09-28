extends CharacterBody2D

var Bullet = load("res://Enemy/enemy_bullet.tscn")
var health = 10
#var y_positions = [100,150,200,500,550]
var initial_position = Vector2.ZERO
var direction = Vector2.ZERO
var wobble = 40.0
var Explosion = load("res://Effects/Explosion.tscn")

func _ready():
	if randi_range(0,1):
		initial_position.x = -Global.map.x-50
		initial_position.y = randi_range(0,Global.map.y)
		direction = Vector2(3.5,0)
	else:
		initial_position.x = Global.map.x+50
		initial_position.y = randi_range(0,Global.map.y)
		direction = Vector2(-3.5,0)
	position = initial_position
	
func _physics_process(_delta):
	position += direction
	position.y = initial_position.y + sin(position.x/80)*wobble
	if position.x > Global.map.x+100 or position.x < -Global.map.x-100:
		queue_free()

func _on_timer_timeout():
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	var Effects = get_node_or_null("/root/Game/Effects")
	if Player != null and Effects != null:
		var bullet = Bullet.instantiate()
		var d = global_position.angle_to_point(Player.global_position) + PI/2
		bullet.rotation = d
		bullet.global_position = global_position + Vector2(0,-50).rotated(d)
		Effects.add_child(bullet)

func damage(d):
	health -= d
	if health <= 0:
		var boostUp = 5
		var scoreUp = 100
		var Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var explosion = Explosion.instantiate()
			Effects.add_child(explosion)
			explosion.global_position = global_position
		Global.update_score(scoreUp)
		Global.update_boost(boostUp)
		queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		damage(100)
		body.damage(100)
