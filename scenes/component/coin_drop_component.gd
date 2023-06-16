class_name CoinDropComponent
extends Node2D

@export var coin_scene: PackedScene
@export var health_component: HealthComponent
@export var money: int = 0

func _ready() -> void:
	if health_component == null:
		return
	
	health_component.dead.connect(on_health_component_dead)


func on_health_component_dead() -> void:
	var coin_instance := coin_scene.instantiate() as Node2D
	
	var entities = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	
	entities.add_child(coin_instance)
	coin_instance.global_position = global_position
	coin_instance.money = money
