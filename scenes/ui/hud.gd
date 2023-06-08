extends CanvasLayer

@onready var blood = $Blood
@onready var statuses = $Statuses


func update_health(frac_cur_health: float) -> void:
	blood.update_health(frac_cur_health)
	statuses.update_health(frac_cur_health)
