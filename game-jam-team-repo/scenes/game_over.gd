extends Control

var main_menu = preload("res://scenes/main_menu.tscn")
#var level_1 = preload("res://scenes/levels/level1.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(Input.is_anything_pressed() == true):
		get_tree().change_scene_to_packed(main_menu)
