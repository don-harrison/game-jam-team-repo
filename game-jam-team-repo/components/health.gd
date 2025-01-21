extends Node
class_name Health

var health
var max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(damage: float):
	print("took ", damage, " damage!")
	health -= damage

func restore_health(amount: float):
	health = move_toward(health, max_health, amount)
