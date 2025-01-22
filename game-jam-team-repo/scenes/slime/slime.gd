extends CharacterBody2D
class_name Slime

const TOP_SPEED = 2000.0
const RUN_ACCEL = 500.0
const JUMP_VELOCITY = -400.0
const AIR_RESISTANCE = 3.0
const DEFORMATION_AMOUNT = .8
const FRICTION = 1
const MAX_HEALTH = 3
@onready var arrow: Sprite2D = $Arrow
@onready var debug_line: Node2D = $DebugLine
@onready var health: Node = $Health
@onready var grapple: Node = $Grapple
var grapple_point: Vector2 = Vector2.ZERO
const grapple_spring_constant = .5
const grapple_damping = 1.0

func _ready() -> void:
	health.max_health = MAX_HEALTH
	
func _process(delta: float) -> void:
	var mouse_direction = get_local_mouse_position()
	arrow.rotation = mouse_direction.angle()
	#print("angle ", arrow.rotation, "vector", mouse_direction.normalized())

func _physics_process(delta: float) -> void:
	# Get last collision to determine bounces
	var last_collision = move_and_collide(velocity * delta,true)
	if last_collision:
		var damageable_object_body := last_collision.get_collider() as RigidBody2D
		# do we check here for whether we deal damage or take damage?
		if damageable_object_body && damageable_object_body.get_parent():
			var damageable_object = damageable_object_body.get_parent()
			SignalManager.slime_collision.emit(self, damageable_object_body, velocity)
		velocity = calculate_bounce(get_velocity(), last_collision.get_normal())
	# Add the gravity.
	velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("left_mouse_click"):
		var hit_position = raytrace(global_position, get_global_mouse_position())
		attach_grapple(hit_position)
	move_towards_grapple()
	# Handle jump.
	if Input.is_action_just_pressed("jump"): # Only jump while on the floor
		velocity.y = JUMP_VELOCITY
		grapple_point = Vector2.ZERO
		
	
	# Allow for air movement control, so we don't check for on floor
	# if we are stopped, get initial boost
	#if Input.is_action_just_pressed("left") && velocity.x == 0:
	#	velocity.x = -RUN_ACCEL
		
	#if Input.is_action_just_pressed("right") && velocity.x == 0:
	#	velocity.x = RUN_ACCEL

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

func raytrace(origin: Vector2, end: Vector2) -> Vector2:
		#print("origin: ", origin, " end: ", end)

		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(origin, end, 1)
		query.exclude = [self, self.get_child(1)]
		var result = space_state.intersect_ray(query)
		var res_position = Vector2(0,0)
		
		#Why isnt the result populating when its from underneath a tile
		print(result)
		if result.has('position'):
			res_position = result.position
		return res_position
	
func move_towards_grapple():
	#get relative position of slime to grapple anchor point
	const speed = 50
	if grapple_point != Vector2.ZERO:
		var rel_position = grapple_point - position
		velocity += (rel_position.normalized() * speed)
	
	
	#var gamma: float = .5 * sqrt(4*grapple_spring_constant - grapple_damping**2)
	#if gamma == 0: return
	#var spring_vector: Vector2 = rel_position * (grapple_damping / (2 * gamma)) + velocity * (1/gamma)
	#
	#if(velocity > Vector2.ZERO):
		#velocity += spring_vector
	
func attach_grapple(position: Vector2) -> void:
	if grapple and grapple.get_child_count() > 0:
		grapple.get_children()[0].queue_free()
	
	grapple_point = position
	
	var spring: DampedSpringJoint2D = DampedSpringJoint2D.new()
	var attach_point: Area2D = Area2D.new()
	#var collisionShape = CollisionShape2D.new()
	#var attach_point_collider: CircleShape2D = CircleShape2D.new()
	
	#collisionShape.shape = attach_point_collider
	#attach_point.add_child(collisionShape)
	attach_point.position = position
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://Assets/1-bit-input-prompts-pixel-16/Tiles (Black)/tile_0001.png")
	attach_point.add_child(sprite)
	attach_point.z_index = 4
	get_parent().add_child(attach_point)
	#
	#spring.node_a = self.get_path()
	#spring.node_b = attach_point.get_path()
	#get_parent().add_child(spring)
	
	
