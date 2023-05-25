extends Control

@onready var grid = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/GridContainer
@onready var reset_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/ResetButton
@onready var back_button = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton

var target: Button = null
var actions = [
	"move_up", "move_left", "move_down", "move_right", "attack"
]
var events := {}

func _ready() -> void:
	back_button.pressed.connect(go_to_main)
	reset_button.pressed.connect(reset)
	
	for action in actions:
		var label = Label.new()
		label.text = " ".join(action.split("_")).capitalize()
		label.set("size_flags_horizontal", 3)
		grid.add_child(label)
		
		var button = Button.new()
		var event := InputMap.action_get_events(action)[0]
		label.add_theme_font_size_override("font_size", 32)
		button.text = OS.get_keycode_string(event.physical_keycode)
		button.add_theme_font_size_override("font_size", 32)
		button.set("custom_minimum_size", Vector2(210.0, 0.0))
		grid.add_child(button)
		
		button.pressed.connect(_on_button_pressed.bind(button))
		events[button.to_string()] = action


func go_to_main() -> void:
	SceneChanger.change_scene("res://gui/start_screen.tscn")


func reset() -> void:
	InputMap.load_from_project_settings()
	SceneChanger.reload_scene()

func _on_button_pressed(button: Button) -> void:
	button.text = "Press key ..."
	target = button

func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or \
		target == null:
		return
	
	var action = events[target.to_string()]
	
	if key_already_used(event):
		var old_event := InputMap.action_get_events(action)[0]
		target.text = OS.get_keycode_string(old_event.physical_keycode)
		return
	
	target.text = OS.get_keycode_string(event.key_label)
	target = null
	
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)


func key_already_used(event: InputEvent) -> bool:
	for action in actions:
		var action_event = InputMap.action_get_events(action)[0]
		if event.key_label == action_event.physical_keycode:
			return true
	return false
