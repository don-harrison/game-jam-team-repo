extends RigidBody2D
class_name Rocket

const SPEED = 250

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_damp = 0
	contact_monitor = true
	max_contacts_reported = 10
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for bod in get_colliding_bodies():
		print(bod)
	pass

func launch_towards(start_position: Vector2, target_position: Vector2) -> void:
	var position_diff =  target_position - start_position
	PhysicsServer2D.body_set_state(
		get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D.IDENTITY.translated(start_position))
	PhysicsServer2D.body_set_state(
		get_rid(),
		PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY,
		position_diff.normalized() * SPEED)
	print("launching towards ", target_position, " from ", start_position, ", setting velocity to ", position_diff.normalized() * SPEED)
	pass
