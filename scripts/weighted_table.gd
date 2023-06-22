class_name WeightedTable

var items: Array[Dictionary] = []
var total_weight: int = 0

func add_item(item, weight: int) -> void:
	items.append({ "item": item, "weight": weight} )
	total_weight += weight

func pick_item():
	var chosen_weight = randi_range(1, total_weight)
	for item in items:
		chosen_weight -= item.weight
		if chosen_weight <= 0:
			return item.item
