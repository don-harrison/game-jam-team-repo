extends DamageablePhysicsObject
class_name ShootyEnemy

@onready var slime: Slime = $"../Slime"
@onready var rocket: Rocket = $RocketBody
@onready var my_body: RigidBody2D = $EnemyBody
@onready var shoot_pos: Marker2D = $EnemyBody/ShootPosition

const RELOAD_TIME = 3
var time_since_last_shot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	time_since_last_shot = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_since_last_shot += delta
	if time_since_last_shot >= RELOAD_TIME:
		shoot_at_player()
		time_since_last_shot = 0
	pass

func collide_reciever(slime: CharacterBody2D, collider: Node2D, slime_velocity: Vector2):
	super(slime, collider, slime_velocity)
	print("subclass text")
	
func shoot_at_player() -> void:
	print("Firing at the player! ", slime.global_position)
	rocket.launch_towards(shoot_pos.global_position, slime.global_position)
	
	
