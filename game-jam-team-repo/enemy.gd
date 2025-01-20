extends Node2D

const MAX_HEALTH = 1
@onready var health: Node = $Health
@onready var body: RigidBody2D = $EnemyBody

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.max_health = MAX_HEALTH
	health.health = MAX_HEALTH
	body.contact_monitor = true
	body.max_contacts_reported = 10
	SignalManager.slime_collision.connect(collide_reciever)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func collide_reciever(collider: Node2D, slime_velocity: Vector2):
	if collider == body:
		var velocity_diff = (slime_velocity - body.linear_velocity).length()
		#TODO: create some function to determine how much damage is done
		print("slime hit me at speed of: ", velocity_diff)
		if velocity_diff > 1000:
			health.take_damage(1)
		pass
