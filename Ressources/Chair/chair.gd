extends StaticBody2D
class_name Chair

var available := true

@onready var highlight: Node2D = $AvailableHighlight
@onready var highlightParticles: CPUParticles2D = $AvailableHighlight/CPUParticles2D

func _ready() -> void:
	highlightParticles.emitting = false

func _process(_delta: float) -> void:
	if PlayerDatas.pickingChair and available:
		highlightParticles.emitting = true
	else:
		highlightParticles.emitting = false

func _on_available_highlight_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if PlayerDatas.pickingChair and event is InputEventMouseButton and event.pressed:
		SignalBus.chairPicked.emit(self)
		PlayerDatas.selectedCustomer = null
		PlayerDatas.pickingChair = false
