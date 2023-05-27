extends Control

@onready var grid = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer
@onready var reset_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/ResetButton
@onready var back_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/VBoxContainer/BackButton

var button_pressed: Button = null
var actions := [
	"move_up", "move_left", "move_down", "move_right", "attack"
]
var button_action_dict: Dictionary

func _ready() -> void:
	back_button.pressed.connect(go_to_main)
	reset_button.pressed.connect(reset)
	
	# Add all actions into the scene grid
	for action in actions: 
		var label = Label.new()
		label.add_theme_font_size_override("font_size", 32)
		label.set("size_flags_horizontal", 3)
		label.text = " ".join(action.split("_")).capitalize()
		grid.add_child(label)
		
		var button = Button.new()
		button.add_theme_font_size_override("font_size", 32)
		button.set("custom_minimum_size", Vector2(210.0, 0.0))
		button.text = get_key(action)
		grid.add_child(button)
		
		button.pressed.connect(_on_button_pressed.bind(button))
		button_action_dict[button.to_string()] = action


func go_to_main() -> void:
	SceneChanger.change_scene("res://gui/start_screen.tscn")

# Resets all actions to their original input keys
func reset() -> void:
	InputMap.load_from_project_settings()
	SceneChanger.reload_scene()

func _on_button_pressed(button: Button) -> void:
	button.text = "Press key ..."
	button_pressed = button

# Remaps the input key of an action if an action is selected. If the
# selected input key is already assigned to another action, it does not
# remap and displays its original input key.
func _input(event: InputEvent) -> void:
	if (button_pressed == null or not event is InputEventKey
		or not event.pressed):
		return
	
	var action = button_action_dict[button_pressed.to_string()]
	
	if key_is_active(event):
		button_pressed.text = get_key(action)
		return
	
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	button_pressed.text = get_key(action)
	button_pressed = null

# Returns true if the current InputEventKey is already assigned to another action
func key_is_active(event: InputEventKey) -> bool:
	for action in actions:
		var action_event = InputMap.action_get_events(action)[0]
		if event.key_label == action_event.physical_keycode:
			return true
	return false

# Returns the string representation of the input key mapped to the action
func get_key(action: StringName) -> StringName:
	var event: InputEventKey = InputMap.action_get_events(action)[0]
	return OS.get_keycode_string(event.physical_keycode)
