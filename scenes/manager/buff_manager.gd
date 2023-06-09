extends Node

@export var buff_pool: Array[Buff]
@export var experience_manager: Node
@export var buff_select_screen_scene: PackedScene


var current_buffs = {}

func _ready() -> void:
	experience_manager.level_up.connect(on_level_up)


func on_level_up(_new_level: int) -> void:
	var chosen_buff = buff_pool.pick_random() as Buff
	if chosen_buff == null:
		return
	
	var buff_select_screen_instance = buff_select_screen_scene.instantiate()
	add_child(buff_select_screen_instance)
	buff_select_screen_instance.set_buffs([chosen_buff] as Array[Buff])
	buff_select_screen_instance.buff_selected.connect(on_buff_selected)


func on_buff_selected(buff: Buff) -> void:
	apply_buff(buff)


func apply_buff(buff: Buff) -> void:
	var has_buff = current_buffs.has(buff.id)
	if not has_buff:
		current_buffs[buff.id] = {
			"resource": buff,
			"quantity": 1,
		}
	else:
		current_buffs[buff.id]["quantity"] += 1
	
	GameEvents.emit_buff_added(buff, current_buffs)
