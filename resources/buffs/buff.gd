class_name Buff
extends Resource

@export var id: String
@export var name: String
@export_multiline var description: String

# If non-zero, represents the maximum quantity the buff can be acquired,
# else, the buff can be acquired unlimited times.
@export var max_quantity: int = 0

# Represents the buffs that can be acquired once this buff is acquired.
@export var unlock_pool: Array[Buff]
