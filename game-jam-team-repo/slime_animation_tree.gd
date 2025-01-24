extends AnimationTree

@onready var slime: Slime = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_animation_parameters(delta)

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
