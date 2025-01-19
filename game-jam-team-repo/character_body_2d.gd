extends CharacterBody2D

const TOP_SPEED = 300.0
const RUN_ACCEL = 50.0
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 30.0
@onready var arrow: Sprite2D = $Arrow

func _process(delta: float) -> void:
	var mouse_direction = get_local_mouse_position()
	arrow.rotation = mouse_direction.angle()
	#print("angle ", arrow.rotation, "vector", mouse_direction.normalized())

func _physics_process(delta: float) -> void:
	
	# Get last collision to determine bounces
	var last_collision = get_last_slide_collision()
	if last_collision:
		print("angle: ", last_collision.get_angle(Vector2(0,1)),
		"\ncollider: ", last_collision.get_collider(),
		"\ncollider ID: ", last_collision.get_collider_id(),
		"\ncollider RID: ", last_collision.get_collider_rid(),
		"\ncollider shape: ", last_collision.get_collider_shape(),
		"\ncollider shape index: ", last_collision.get_collider_shape_index(),
		"\ncollider velocity: ", last_collision.get_collider_velocity(),
		"\ndepth: ", last_collision.get_depth(),
		"\nlocal shape: ", last_collision.get_local_shape(),
		"\nnormal: ", last_collision.get_normal(),
		"\nposition: ", last_collision.get_position(),
		"\nremainder: ", last_collision.get_remainder(),
		"\ntravel: ", last_collision.get_travel())

	
	# Add the gravity.
	velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") && is_on_floor(): # Only jump while on the floor
		var mouse_direction = position + get_global_mouse_position()
		mouse_direction.angle()
		print(raytrace(position, mouse_direction))
		velocity.y = JUMP_VELOCITY

	# Allow for air movement control, don't check for on floor
	if Input.is_action_just_pressed("left") && velocity.x == 0:
		velocity.x = -RUN_ACCEL
		
	if Input.is_action_just_pressed("right") && velocity.x == 0:
		velocity.x = RUN_ACCEL
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction == 1 && velocity.x < TOP_SPEED:
		velocity.x += RUN_ACCEL * delta
	elif direction == -1 && velocity.x > -TOP_SPEED:
		velocity.x -= RUN_ACCEL * delta
	else:
		# Gradually slows down when no inputs given
		velocity.x = move_toward(velocity.x, 0, AIR_RESISTANCE * delta)

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
		
