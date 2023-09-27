extends Node2D
var Enemy = load("res://Enemy/enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_timer_timeout():
	var enemyContainer = get_node("Enemy_Container")
	var enemy = Enemy.instantiate()
	enemyContainer.add_child(enemy)
	pass # Replace with function body.
