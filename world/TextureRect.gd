extends TextureRect
var grade_arr:Array = [
	preload("res://assets/A+.png"),
	preload("res://assets/A.png"),
	preload("res://assets/B.png"),
	preload("res://assets/C.png"),
	preload("res://assets/D.png"),
	preload("res://assets/F.png")
]

@onready var global := get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global != null:
		var percent:int = int((global.health / global.max_health) * 100)
		if (percent >= 90):
			texture = grade_arr[0]
		elif (percent >= 80):
			texture = grade_arr[1]
		elif (percent >= 70):
			texture = grade_arr[2]
		elif (percent >= 60):
			texture = grade_arr[3]
		elif (percent >= 50):
			texture = grade_arr[4]
		else:
			texture = grade_arr[5]
