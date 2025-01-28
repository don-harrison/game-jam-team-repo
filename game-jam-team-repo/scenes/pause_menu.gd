extends Control

var options = ["Resume", "Main Menu", "Quit"]
@onready var pause_menu: Control = $"."
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const UI_FONT_SETTINGS = preload("res://Assets/fonts/ui_font_settings.tres")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.paused.connect(game_paused)
	
	for option in options:
		var label = Label.new()
		label.text = option
		label.label_settings = UI_FONT_SETTINGS
		label.mouse_filter = Control.MOUSE_FILTER_PASS  # Ensure the label can receive mouse events
		var callback1 = _on_label_mouse_entered.bind(label)
		var callback2 = _on_label_mouse_exited.bind(label)
		var callback3 = _on_label_gui_input.bind(label)

		label.connect("mouse_entered", callback1)
		label.connect("mouse_exited", callback2)
		label.connect("gui_input", callback3)
		#label_signal.connect()
		v_box_container.add_child(label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_label_mouse_entered(label: Label):
	label.scale += Vector2(.25,.25)
	
func _on_label_mouse_exited(label: Label):
	label.scale -= Vector2(.25,.25)

func _on_label_gui_input(event: InputEvent, label: Label):
	if(Input.is_action_just_pressed("left_mouse_click")):
		if(label.text == "Resume"):
			game_paused(false)
		if(label.text == "Main Menu"):
			SignalManager.main_menu.emit()
		if(label.text == "Quit"):
			get_tree().quit()

func game_paused(is_paused: bool) -> void:
	get_tree().paused = !get_tree().paused
	pause_menu.visible = !pause_menu.visible
