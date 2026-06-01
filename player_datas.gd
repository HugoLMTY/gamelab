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

func add_to_inventory(item: String) -> void:
	if inventory[item]:
		inventory[item] += 1
	else:
		inventory[item] = 1
	emit_signal("inventoryUpdated")
