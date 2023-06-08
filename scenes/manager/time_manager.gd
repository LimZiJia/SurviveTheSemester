extends Node

var seconds := 0.0


func _process(delta: float):
	seconds += delta


# Returns the time elapsed in seconds
func get_time_elapsed() -> float:
	return seconds
