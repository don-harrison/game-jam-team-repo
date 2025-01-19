extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var arrow: Sprite2D = $Arrow

func _process(delta: float) -> void:
	var mouse_direction = get_local_mouse_position()
	arrow.rotation = mouse_direction.angle()
	print("angle ", arrow.rotation, "vector", mouse_direction.normalized())

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		var mouse_direction = position + get_global_mouse_position()
		mouse_direction.angle()
		print(raytrace(position, mouse_direction))
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

#cast a circle out in a line and see what point the circle touches
#func circle_trace(radius, distance):
	#var circle = CollisionShape2D.new()
	#circle.shape = CircleShape2D.new()
	#circle.transform
	#	
func raytrace(origin: Vector2, direction: Vector2) -> Vector2:
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		var minDist = origin + Vector2(20 * direction.normalized().x, 20 * direction.normalized().y)
		var query = PhysicsRayQueryParameters2D.create(minDist, direction)
		var result = space_state.intersect_ray(query)
		var res_position =  Vector2(0,0)
		
		if result.has('position'):
			res_position = result.position
		return res_position
		
