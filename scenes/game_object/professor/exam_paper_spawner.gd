extends CharacterBody2D

@export var exam_paper_scene: PackedScene

var difficulty: int = 1
var dir := Vector2.RIGHT

@onready var velocity_component := $VelocityComponent as VelocityComponent


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	velocity_component.accelerate_in_direction(dir)
	velocity_component.move(self)


func start(difficulty: int) -> void:
	dir = dir.rotated(randf_range(0, TAU))
	$AnimationPlayer.play("enter")


func spawn() -> void:
	var entities = get_tree().get_first_node_in_group("entities_layer") as Node2D
	if entities == null:
		return
	
	var exam_paper_instance := exam_paper_scene.instantiate() as CharacterBody2D
	entities.add_child(exam_paper_instance)
	
	exam_paper_instance.global_position = self.global_position
	exam_paper_instance.set_difficulty(difficulty)
	
	queue_free()
