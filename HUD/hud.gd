extends CanvasLayer

@onready var dashCooldownBar: ProgressBar = $Actions/DashCooldownBar

func _ready() -> void:
	show()

func _process(_delta: float) -> void:
	var available = PlayerDatas.cooldowns.dash / PlayerDatas.dashCooldown * 100
	dashCooldownBar.value = available
