extends CanvasLayer

@onready var dashCooldownBar: ProgressBar = $Actions/DashCooldownBar
@onready var xpProgressBar: ProgressBar = $"Name + XP/XP Bar"

func _ready() -> void:
	show()
	TavernDatas.xpUpdated.connect(func(): xpProgressBar.value = TavernDatas.xp)

func _process(_delta: float) -> void:
	var cooldown = PlayerDatas.cooldowns.dash / PlayerDatas.dashCooldown * 100
	dashCooldownBar.value = cooldown
