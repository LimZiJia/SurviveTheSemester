extends Node2D

@export var experience_manager: Node

@onready var progress_bar := $TextureProgressBar as TextureProgressBar

func _ready() -> void:
	progress_bar.value = 0
	
	if experience_manager == null:
		return
	
	experience_manager.experience_updated.connect(on_experience_updated)


func on_experience_updated(current_experience: int, target_experience: int):
	progress_bar.value = current_experience
	progress_bar.max_value = target_experience
