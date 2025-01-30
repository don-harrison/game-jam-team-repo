extends Control

var options = []
const UI_FONT_SETTINGS = preload("res://Assets/fonts/ui_font_settings.tres")
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
const level_directory = "res://scenes/levels/"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir = DirAccess.open(level_directory)
	if dir:
		for file_name in dir.get_files():
			options.append(file_name.replace(".tscn", ""))
	options.append("Back")
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
		if(label.text == "Back"):
			SignalManager.main_menu.emit()
		else:
			get_tree().change_scene_to_file("res://scenes/levels/%s.tscn" % label.text)
