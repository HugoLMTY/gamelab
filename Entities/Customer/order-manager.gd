extends Node
class_name OrderManager


signal orderUpdated
signal orderFilled

var order: Dictionary[String, Dictionary] = {}
var filled := false

var rng = RandomNumberGenerator.new()
var possibleItems = [
	"beer",
]

var exampleOrder := {
	"beer": {
		"requested": 1,
		"filled": 1
	}
} 

func _init() -> void:
	order = generate_order()

	if !orderUpdated.is_connected(check_order_status):
		orderUpdated.connect(check_order_status)

func _ready() -> void:
	if order.is_empty():
		order = generate_order()

func generate_order() -> Dictionary[String, Dictionary]:
	var item = possibleItems[rng.randi_range(0, possibleItems.size() - 1)]
	var quantity = rng.randi_range(1, 3)

	return {
		item: {
			"waiting": quantity,
			"filled": 0
		}
	}

func add_item_to_order(item: String) -> bool:
	var orderItem: Dictionary = order.get(item, {})
	
	if orderItem.is_empty() or orderItem.get("waiting", 0) <= 0:
		return false
	
	orderItem.waiting -= 1
	orderItem.filled += 1
	print(orderItem)
	emit_signal("orderUpdated")
	return true

func check_order_status() -> void:
	var isFilled = true
	
	for item in order:
		if order[item].waiting >= 1:
			isFilled = false
		
	if isFilled:
		filled = true
		emit_signal("orderFilled")

func _on_order_filled() -> void:
	print("filled")
	emit_signal("orderFilled")
