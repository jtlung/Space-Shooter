extends Node

func _ready():
	randomize()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("Quit"):
		get_tree().quit()
r
