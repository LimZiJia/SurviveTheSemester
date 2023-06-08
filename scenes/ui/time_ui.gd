extends CanvasLayer

@export var time_manager: Node

@onready var label = %Label

func _process(_delta: float) -> void:
	if time_manager == null:
		return
	
	var time_elapsed = time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(time_elapsed)
	


func format_seconds_to_string(seconds: float) -> String:
	var hours = floor(seconds / 3600)
	var minutes = floor(int(seconds / 60) % 60)
	var remaining_seconds = floor(int(seconds) % 60)
	if hours == 0:
		return "%d:%02d" % [minutes, remaining_seconds]
	else:
		return "%d:%02d:%02d" % [hours, minutes, remaining_seconds]
