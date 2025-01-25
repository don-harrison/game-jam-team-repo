extends AnimationTree

@onready var slime: Slime = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.slime_bounce.connect(slime_bounce)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_animation_parameters(delta)

func slime_bounce(normal: Vector2):
	#floor bounce
	if(normal.y == -1):	
		pass
		#var state_machine:AnimationNodeStateMachine = self["tree_root"]
		#state_machine.start
	#wall bounce
	else:	
		pass

func update_animation_parameters(delta: float):
	#print(slime.velocity)
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
