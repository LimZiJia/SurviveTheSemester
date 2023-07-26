extends CanvasLayer

signal closed

@onready var master_volume_slider := %MasterVolumeSlider as HSlider
@onready var music_volume_slider := %MusicVolumeSlider as HSlider
@onready var sfx_volume_slider := %SFXVolumeSlider as HSlider
@onready var back_button := %BackButton as Button

func _ready() -> void:
	master_volume_slider.value = VolumeManager.master_volume
	
	master_volume_slider.value_changed.connect(on_master_volume_slider_value_changed)
	back_button.pressed.connect(on_back_button_pressed)
	closed.connect(on_closed)


func on_master_volume_slider_value_changed(value: float) -> void:
	VolumeManager.set_master_volume(value)


func on_back_button_pressed() -> void:
	$AnimationPlayer.play("exit")


func on_closed() -> void:
	queue_free()
