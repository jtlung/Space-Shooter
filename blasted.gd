extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Emit.emitting = true
	await get_tree().create_timer(1.0).timeout
	queue_free()
