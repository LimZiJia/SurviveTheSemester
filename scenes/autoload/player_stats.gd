extends Node

@export_range(1.0, 10.0, 0.1) var damage_multiplier := 1.0
@export_range(1.0, 10.0, 0.1) var crit_multiplier := 2.0
@export_range(0.0, 1.0, 0.01) var crit_chance := 0.01


func _ready() -> void:
	GameEvents.buff_added.connect(on_buff_added)


func init_stats() -> void:
	damage_multiplier = 1.0
	crit_multiplier = 2.0
	crit_chance = 0.01


func on_buff_added(buff: Buff, current_buffs: Dictionary) -> void:
	if not buff.id in ["damage", "crit_chance", "crit_damage"]:
		return
	
	if buff.id == "damage":
		damage_multiplier += 0.03
	elif buff.id == "crit_chance":
		crit_chance += 0.01
	elif buff.id == "crit_damage":
		crit_multiplier += 0.2
