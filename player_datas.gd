extends Node

signal inventoryUpdated
var inventory: Dictionary[String, int] = {"beer": 0}

var selectedCustomer: Customer
var pickingChair := false # may have differents actions idk yet

var dashCooldown := 0.5

var cooldowns = {
	"dash": 0.0
}

func _process(delta: float) -> void:
	for cooldown in cooldowns:
		cooldowns[cooldown] -= delta

func dash() -> void:
	PlayerDatas.cooldowns.dash = PlayerDatas.dashCooldown

func add_to_inventory(item: String, quantity := 1) -> void:
	if inventory[item]:
		inventory[item] += quantity
	else:
		inventory[item] = quantity
	emit_signal("inventoryUpdated")

func take_from_inventory(item: String, quantity := 1) -> bool:
	var hasEnoughItem = inventory[item] >= quantity
	if hasEnoughItem:
		inventory[item] -= quantity
		emit_signal("inventoryUpdated")
	return hasEnoughItem
