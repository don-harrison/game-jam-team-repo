extends Node2D

const MAX_HEALTH = 1
@onready var health: Node = $Health
@onready var body: RigidBody2D = $RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health.max_health = MAX_HEALTH
	health.health = MAX_HEALTH
	body.contact_monitor = true
	body.max_contacts_reported = 10
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("hitting ", body.get_contact_count(), " bodies")
	for colliding_body in body.get_colliding_bodies():
		if(colliding_body.name == "Slime"):
			print("hit slime!")
			var slime_player := colliding_body as CharacterBody2D
			var relative_velocity = slime_player.velocity - get_child(1).linear_velocity
			if relative_velocity.length() > 10: # minimum speed to kill
				health.take_damage(1)
