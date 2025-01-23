extends AnimationTree

@onready var slime: Slime = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_animation_parameters()

func update_animation_parameters():
	print(slime.velocity)
	if slime.velocity < Vector2(5, 20):
		self["parameters/conditions/idle"] = true
		self.active = true
	else:
		self["parameters/conditions/idle"] = false
		self.active = false
