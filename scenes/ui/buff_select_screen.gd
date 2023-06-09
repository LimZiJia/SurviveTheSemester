extends CanvasLayer

signal buff_selected(buff: Buff)

@export var buff_card_scene: PackedScene

@onready var card_container := %CardContainer as HBoxContainer


func _ready() -> void:
	get_tree().paused = true

func set_buffs(buffs: Array[Buff]) -> void:
	for buff in buffs:
		var card_instance := buff_card_scene.instantiate() as Node
		card_container.add_child(card_instance)
		card_instance.set_buff(buff)
		card_instance.selected.connect(on_buff_selected.bind(buff))


func on_buff_selected(buff: Buff) -> void:
	buff_selected.emit(buff)
	get_tree().paused = false
	queue_free()
