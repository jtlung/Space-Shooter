extends Area2D


var speed = 7.5
var damage = 2
var velocity = Vector2.ZERO
var Effects = null
var Blasted = load("res://Effects/blasted.tscn")

func _ready():
	velocity = Vector2(0,-speed).rotated(rotation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position = position+velocity


func _on_body_entered(body):
	if body.has_method("damage"):
		body.damage(damage)
	Effects = get_node_or_null("/root/Game/Effects")
	if Effects != null:
		var blasted = Blasted.instantiate()
		Effects.add_child(blasted)
		blasted.rotation = rotation
		blasted.modulate = Color.from_hsv(0,100,100,1)
		blasted.global_position = global_position
	queue_free()


func _on_timer_timeout():
	queue_free()
