extends AnimationTree

@onready var slime: Slime = $".."
var last_bounce_normal: Vector2
var state
enum {
	DEFAULT,
	WALL_BOUNCE,
	FLOOR_BOUNCE,
	IDLE
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.slime_bounce.connect(slime_bounce)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	state = DEFAULT
	update_animation_parameters(delta)

func slime_bounce(normal: Vector2):
	last_bounce_normal = normal
	print(last_bounce_normal)
	#floor bounce
	if(normal.y == -1):	
		#if slime.velocity.y > 15 && slime.velocity.y < -15:
		state = FLOOR_BOUNCE
	#wall bounce
	if(normal.x == -1):
		print(last_bounce_normal)
		self["parameters/Wall_Bounce/blend_position"] = last_bounce_normal
		state = WALL_BOUNCE

	if(normal.x == 1):
		print(last_bounce_normal)
		self["parameters/Wall_Bounce/blend_position"] = last_bounce_normal
		state = WALL_BOUNCE

func update_animation_parameters(delta: float):
	self.active = true
	
	self["parameters/Jump/blend_position"] = Vector2(slime.velocity.x,slime.velocity.y)
	self["parameters/Fall/blend_position"] = Vector2(slime.velocity.x,slime.velocity.y)
	
	if slime.velocity.y < 15:
		self["parameters/conditions/jump"] = true
		self["parameters/conditions/fall"] = false
		self["parameters/conditions/idle"] = false
		
	if slime.velocity.y > -15:
		self["parameters/conditions/jump"] = false
		self["parameters/conditions/fall"] = true
		self["parameters/conditions/idle"] = false
		
	if slime.velocity.y < 15 && slime.velocity.y > -15:
		self["parameters/conditions/jump"] = false
		self["parameters/conditions/fall"] = false
		self["parameters/conditions/idle"] = true
