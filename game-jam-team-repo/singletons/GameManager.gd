extends Node

#Manager for Game global events
@onready var lvl_mechanics_testing: Node = $"."
@onready var slime: Slime = $Slime
@onready var pause_menu: Control = $"Pause Menu"

var is_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	SignalManager.main_menu.connect(main_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(_event):
	if(Input.is_action_just_pressed("escape")):
		SignalManager.paused.emit(!is_paused)

func main_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn");
	
func level_select():
	get_tree().change_scene_to_file("res://scenes/level_select.tscn");
