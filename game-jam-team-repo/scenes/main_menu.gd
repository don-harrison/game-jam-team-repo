extends Control

var options = ["Level Select", "Quit"]
const UI_FONT_SETTINGS = preload("res://Assets/fonts/ui_font_settings.tres")
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
		if(label.text == "Level Select"):
			get_tree().change_scene_to_file("res://scenes/level_select.tscn")
		if(label.text == "Quit"):
			get_tree().quit()
