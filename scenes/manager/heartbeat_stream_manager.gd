extends AudioStreamPlayer2D

const LOUDEST_DB: float = 9.0

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.health_healed.connect(on_health_changed)
	GameEvents.health_damaged.connect(on_health_changed)


func on_health_changed(current_health: float, max_health: float) -> void:
	play_changed_tween(current_health / max_health)


func play_changed_tween(frac_cur_health: float) -> void:
	var inv_ratio = 1 - frac_cur_health
	var cur_db = LOUDEST_DB * inv_ratio if inv_ratio > 0.5 else -80.0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "volume_db", cur_db, 0.15)
