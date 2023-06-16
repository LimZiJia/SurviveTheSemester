class_name WallCollisionComponent
extends Area2D

func _ready():
	body_entered.connect(on_body_entered)


func on_body_entered(_body: Node2D) -> void:
	var owner_node2d = owner as Node2D
	if owner_node2d != null:
		owner_node2d.queue_free()
