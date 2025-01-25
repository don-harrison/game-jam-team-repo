extends Node

#Store signals in this file so there is a single source for signal management.
# emitted when the slime collides with anything damageable
signal slime_collision(slime_body: CharacterBody2D, other_body: DamageablePhysicsObject, slime_velocity: Vector2)
signal slime_bounce(normal: Vector2)
