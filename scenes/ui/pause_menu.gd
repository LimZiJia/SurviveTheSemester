extends CanvasLayer

@export var volume_menu_scene: PackedScene

@onready var master_volume_slider := %MasterVolumeSlider as HSlider
@onready var music_volume_slider := %MusicVolumeSlider as HSlider
@onready var sfx_volume_slider := %SFXVolumeSlider as HSlider
@onready var resume_button := %ResumeButton as Button
@onready var restart_button := %RestartButton as Button
@onready var return_button := %ReturnButton as Button

func _ready() -> void:
	get_tree().paused = true
	
	master_volume_slider.value = VolumeManager.master_volume
	music_volume_slider.value = VolumeManager.music_volume
	sfx_volume_slider.value = VolumeManager.sfx_volume
	
	master_volume_slider.value_changed.connect(on_master_volume_slider_value_changed)
	music_volume_slider.value_changed.connect(on_music_volume_slider_value_changed)
	sfx_volume_slider.value_changed.connect(on_sfx_volume_slider_value_changed)
	
	resume_button.pressed.connect(on_resume_button_pressed)
	restart_button.pressed.connect(on_restart_button_pressed)
	return_button.pressed.connect(on_return_button_pressed)


func on_resume_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func on_restart_button_pressed() -> void:
	get_tree().paused = false
	Events.game_restarted.emit()
	queue_free()


func on_volume_button_pressed() -> void:
	visible = false
	var volume_menu_instance := volume_menu_scene.instantiate() as CanvasLayer
	add_child(volume_menu_instance)
	
	volume_menu_instance.closed.connect(on_volume_menu_closed)


func on_volume_menu_closed() -> void:
	visible = true


func on_return_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/start_screen.tscn")
	queue_free()


func on_master_volume_slider_value_changed(value: float) -> void:
	VolumeManager.set_master_volume(value)

func on_music_volume_slider_value_changed(value: float) -> void:
	VolumeManager.set_music_volume(value)


func on_sfx_volume_slider_value_changed(value: float) -> void:
	VolumeManager.set_sfx_volume(value)
