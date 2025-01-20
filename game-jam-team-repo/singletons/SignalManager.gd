extends Node

#Store signals in this file so there is a single source for signal management.
# emitted when the slime collides with anything
signal slime_collision(other_body: Node2D, slime_velocity: Vector2)

# emitted when something damages the slime
signal slime_is_hit()
