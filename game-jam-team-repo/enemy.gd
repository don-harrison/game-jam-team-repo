extends Node2D
@onready var health: Node = $Health
@onready var body: RigidBody2D = $Body

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body.contact_monitor = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	signal 
