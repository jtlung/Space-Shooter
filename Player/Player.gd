extends CharacterBody2D

var speed = 5
var rotate_speed = .08
var maxspeed = 400

func _physics_process(delta):
	if Input.is_action_pressed("Left"):
		rotation -= rotate_speed
	if Input.is_action_pressed("Right"):
		rotation += rotate_speed
	if Input.is_action_pressed("Forward"):
		velocity = velocity+Vector2(0,-speed).rotated(rotation)
	
	position.x = wrapf(position.x,0,1152)
	position.y = wrapf(position.y,0,648)
	velocity = velocity.normalized() * clamp(velocity.length(),0,maxspeed)
	print(velocity.length())
	move_and_slide()
