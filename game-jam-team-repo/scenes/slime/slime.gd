extends CharacterBody2D
class_name Slime

const TOP_SPEED = 2000.0
const RUN_ACCEL = 500.0
const JUMP_VELOCITY = -330.0
const AIR_RESISTANCE = 3.0
const DEFORMATION_AMOUNT = .8
const FRICTION = 1
const MAX_HEALTH = 3
@onready var arrow: Sprite2D = $Arrow
@onready var debug_line: Node2D = $DebugLine
@onready var health: Node = $Health
@onready var grapple: Node2D = $Grapple
@onready var slime_animation_player: AnimationPlayer = $Slime_AnimationPlayer
var jumping: bool = false

func _ready() -> void:
	health.max_health = MAX_HEALTH
	
func _process(delta: float) -> void:
	rotate_arrow_pointer()
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
		jumping = false

		if(last_collision.get_normal().y == -1 || last_collision.get_normal().x == 1 || last_collision.get_normal().x == -1):
			SignalManager.slime_bounce.emit(last_collision.get_normal())
	# Add the gravity.
	velocity += get_gravity() * delta
		
	if Input.is_action_just_pressed("left_mouse_click"):
		var raytrace_vector: Vector2 = get_global_mouse_position() - global_position
		var end_raytrace_point: Vector2 = get_global_mouse_position() + raytrace_vector.normalized() * 50
		var hit_position = raytrace(global_position, end_raytrace_point)
		grapple.attach_grapple(hit_position)
	grapple.move_towards_grapple()
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if(!jumping):
			jumping = true # Only jump while on the floor
			velocity.y = JUMP_VELOCITY
		grapple.set_grapple_point(Vector2.ZERO)

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
	var result_bounce: Vector2 = friction_vector * FRICTION - deformation_vector * DEFORMATION_AMOUNT
	
	return result_bounce

func raytrace(origin: Vector2, end: Vector2) -> Vector2:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(origin, end, 1)
		query.exclude = [self, self.get_child(1)]
		var result = space_state.intersect_ray(query)
		var res_position = Vector2(0,0)
		
		#Why isnt the result populating when its from underneath a tile
		#print(result)
		if result.has('position'):
			res_position = result.position
		return res_position

func rotate_arrow_pointer() -> void:
	var mouse_direction = get_local_mouse_position()
	arrow.rotation = mouse_direction.angle()


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
