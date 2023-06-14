extends TextureButton

@export var pause_menu_scene: PackedScene

func _ready():
	pressed.connect(on_pressed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		open_pause_menu()


func on_pressed() -> void:
	open_pause_menu()


func open_pause_menu() -> void:
	var pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
