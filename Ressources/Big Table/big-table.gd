extends TableEntity2D

@export var hasCloth := false

var maxChairs := 6
@export var chairsCount := 3

@onready var sprite: Sprite2D = $Sprite2D

@onready var menu: Panel = $Menu
@onready var chairCountContainer: HBoxContainer = $Menu/Control/ChairsCountContainer

@onready var topLeftChair: StaticBody2D = $"Top Chairs/Left Chair"
@onready var topCenterChair: StaticBody2D = $"Top Chairs/Center Chair"
@onready var topRightChair: StaticBody2D = $"Top Chairs/Right Chair"
@onready var bottomLeftChair: StaticBody2D = $"Bottom Chairs/Left Chair"
@onready var bottomCenterChair: StaticBody2D = $"Bottom Chairs/Center Chair"
@onready var bottomRightChair: StaticBody2D = $"Bottom Chairs/Right Chair"

var showMenu := false

var chairs: Array[StaticBody2D] = []
func _ready() -> void:
	get_node("%ClickableZone").show()
	chairs = [
		topLeftChair,
		topCenterChair,
		topRightChair,
		bottomLeftChair,
		bottomCenterChair,
		bottomRightChair
	]
	super.drawChairButtons(chairCountContainer, maxChairs, func(count: int) -> void:
		chairsCount = count
		queue_redraw()
	)

func _draw() -> void:
	super.drawChairs(chairs, chairsCount, maxChairs)

func _on_clickable_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if !(event is InputEventMouseButton and event.pressed):
		return
	
	if menu.visible:
		menu.hide()
	else:
		menu.show()

func _on_chairs_pressed(numbers: int) -> void:
	chairsCount = numbers
	queue_redraw()
