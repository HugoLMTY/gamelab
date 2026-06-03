extends StaticBody2D
class_name Chair

var available := true
var assignedCustomer: Customer

signal chairReached

@onready var highlight: Node2D = $AvailableHighlight
@onready var highlightParticles: CPUParticles2D = $AvailableHighlight/CPUParticles2D

func _ready() -> void:
	highlightParticles.emitting = false
	highlight.show()

func _process(_delta: float) -> void:
	if PlayerDatas.pickingChair and available:
		highlightParticles.emitting = true
	else:
		highlightParticles.emitting = false

func _on_available_highlight_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if !PlayerDatas.pickingChair or !(event is InputEventMouseButton and event.pressed):
		return

	SignalBus.chairPicked.emit(self)
	assignedCustomer = PlayerDatas.selectedCustomer
	PlayerDatas.selectedCustomer = null
	PlayerDatas.pickingChair = false


func _on_available_highlight_body_entered(body: Node2D) -> void:
	if body is not Customer or body != assignedCustomer: return
	
	emit_signal("chairReached", self)

func set_available() -> void:
	available = true
	assignedCustomer = null
	add_to_group("available-chairs")

func set_unavailable() -> void:
	available = false
	remove_from_group("available-chairs")
