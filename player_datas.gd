extends Node

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
