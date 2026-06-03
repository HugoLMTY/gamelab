extends Node2D
class_name InteractiveZone

@export var collisionBox: CollisionShape2D
@onready var menu : Panel = %InteractionMenu

signal interacted

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !collisionBox: return
	show()
	menu.hide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and menu.visible:
		emit_signal("interacted")

func _on_body_entered(body: Node2D) -> void:
	if body is not Player: return
	menu.show()

func _on_body_exited(body: Node2D) -> void:
	if body is not Player: return
	menu.hide()

func _on_interaction_menu_interacted() -> void:
	emit_signal("interacted")
