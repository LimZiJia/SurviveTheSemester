extends MarginContainer

signal selected

@onready var name_label := %NameLabel as Label
@onready var description_label := %DescriptionLabel as Label


func _ready() -> void:
	gui_input.connect(on_gui_input)

func set_buff(buff: Buff) -> void:
	name_label.text = buff.name
	description_label.text = buff.description


func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		selected.emit()
