extends Node2D

@export var node_a: PhysicsBody2D
@export var grapple_spring_constant = .5
@export var grapple_damping = 1.0

const move_toward_grapple_speed = 50

var grapple_point = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	#if the grapple point is not the zero vector, move towards grapple point
	if grapple_point != Vector2.ZERO:
		move_towards_grapple()

func set_grapple_point(target: Vector2) -> void:
	grapple_point = target

func move_towards_grapple():
	#get relative position of slime to grapple anchor point
	if grapple_point != Vector2.ZERO:
		var rel_position = grapple_point - global_position
		node_a.velocity += (rel_position.normalized() * move_toward_grapple_speed)
	
	#var gamma: float = .5 * sqrt(4*grapple_spring_constant - grapple_damping**2)
	#if gamma == 0: return
	#var spring_vector: Vector2 = rel_position * (grapple_damping / (2 * gamma)) + velocity * (1/gamma)
	#
	#if(velocity > Vector2.ZERO):
		#velocity += spring_vector
	
func attach_grapple(target: Vector2) -> void:
	if self.get_child_count() > 0:
		self.get_children()[0].queue_free()
	
	grapple_point = target
	
	var spring: DampedSpringJoint2D = DampedSpringJoint2D.new()
	var attach_point: Area2D = Area2D.new()
	attach_point.global_position = grapple_point
	print(grapple_point)
	
	var sprite = Sprite2D.new()
	sprite.texture = preload("res://Assets/1-bit-input-prompts-pixel-16/Tiles (Black)/tile_0001.png")
	attach_point.add_child(sprite)
	attach_point.z_index = 4
	self.add_child(attach_point)
	self.add_child(draw_debug_line(node_a.global_position, grapple_point))
	
	#
	#spring.node_a = self.get_path()
	#spring.node_b = attach_point.get_path()
	#get_parent().add_child(spring)

	
func draw_debug_line(start: Vector2, end: Vector2):
		var line: Line2D = Line2D.new()
		line.z_as_relative = 1
		line.points = [start, end]
		line.width = 1
		return line
		
