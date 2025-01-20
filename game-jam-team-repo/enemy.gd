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
	SignalManager.collision.connect(collide_reciever)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func collide_reciever(collider: Node2D):
	if collider == body:
		print("signal recieved in enemy! ", collider, ", my body is ", body)
		pass
