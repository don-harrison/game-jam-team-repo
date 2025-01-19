extends Node2D
@onready var health: Node = $Health
@onready var body: RigidBody2D = $RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body.contact_monitor = true
	body.max_contacts_reported = 5
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rigid_body_2d_body_entered(body: Node) -> void:
	SignalManager.collision.emit(body)
