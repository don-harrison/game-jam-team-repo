extends CharacterBody2D

const TOP_SPEED = 500.0
const RUN_ACCEL = 50.0
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 3.0
const DEFORMATION_AMOUNT = .8
const FRICTION = 1
@onready var arrow: Sprite2D = $Arrow
@onready var debug_line: Node2D = $DebugLine
@onready var health: Node = $Health

func _process(delta: float) -> void:
	var mouse_direction = get_local_mouse_position()
	arrow.rotation = mouse_direction.angle()
	#print("angle ", arrow.rotation, "vector", mouse_direction.normalized())

func _physics_process(delta: float) -> void:
	# Get last collision to determine bounces
	var last_collision = move_and_collide(velocity * delta,true)
	if last_collision:
		print("old velocity: ", get_velocity(),
			"\nnormal: ", last_collision.get_normal(),
			"\nbounce: ", calculate_bounce(get_velocity(), last_collision.get_normal()))
		velocity = calculate_bounce(get_velocity(), last_collision.get_normal())
	# Add the gravity.
	velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("left_mouse_click"):
		raytrace(Vector2(0,0), get_global_mouse_position())
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"): # Only jump while on the floor
		velocity.y = JUMP_VELOCITY
		
	# Allow for air movement control, so we don't check for on floor
	# if we are stopped, get initial boost
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

	move_and_collide(velocity * delta)

# implementation of bounce angle from https://stackoverflow.com/questions/573084/how-to-calculate-bounce-angle#:~:text=u%20%3D%20(v%C2%A0%C2%B7%C2%A0n%20/%20n%C2%A0%C2%B7%C2%A0n)%20n%0Aw%20%3D%20v%20%E2%88%92%20u
func calculate_bounce(incoming_vector: Vector2, surface_normal: Vector2):
	#TODO: might need to refactor to allow different materials to have different values for deformation and friction
	var deformation_vector = (incoming_vector.dot(surface_normal) / surface_normal.dot(surface_normal)) * surface_normal
	var friction_vector = incoming_vector - deformation_vector
	return friction_vector * FRICTION - deformation_vector * DEFORMATION_AMOUNT
#cast a circle out in a line and see what point the circle touches
#func circle_trace(radius, distance):
	#var circle = CollisionShape2D.new()
	#circle.shape = CircleShape2D.new()
	#circle.transform
	#	
	
func draw_debug_line(start: Vector2, end: Vector2):
		var line: Line2D = Line2D.new()
		line.z_as_relative = 1
		line.points = [start, end]
		line.width = 1
		debug_line.add_child(line)
		
func raytrace(origin: Vector2, direction: Vector2) -> Vector2:
		if debug_line.get_children().size() > 0:
			debug_line.get_children()[0].queue_free()
			
		var space_state = get_world_2d().direct_space_state
		# use global coordinates, not local to node
		#var minDist = origin + Vector2(20 * direction.normalized().x, 20 * direction.normalized().y)
		var query = PhysicsRayQueryParameters2D.create(origin, direction)
		draw_debug_line(origin, direction)

		var result = space_state.intersect_ray(query)
		var res_position =  Vector2(0,0)
		
		if result.has('position'):
			res_position = result.position
		return res_position
		
