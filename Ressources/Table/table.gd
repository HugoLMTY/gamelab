extends TableEntity2D

@export var hasCloth := false

@export var chairsCount := 2
@export var maxChairs := 2

@onready var sprite: Sprite2D = $Sprite2D

@onready var menu: Panel = $Menu
@onready var chairCountContainer: HBoxContainer = $Menu/Control/ChairsCountContainer

@onready var leftChair: StaticBody2D = $"Chairs/Left Chair"
@onready var rightChair: StaticBody2D = $"Chairs/Right Chair"

var showMenu := false

const defaultRegion = Rect2(0, 128, 32, 32)
const clothRegion = Rect2(0, 96, 32, 32)

var chairs: Array[StaticBody2D] = []
func _ready() -> void:
	chairs = [
		leftChair,
		rightChair,
	]
	super.drawChairButtons(chairCountContainer, maxChairs, func(count: int) -> void:
		chairsCount = count
		queue_redraw()
	)
	
func _draw() -> void:
	sprite.region_rect = defaultRegion if !hasCloth else clothRegion
	if showMenu:
		menu.show()
	else:
		menu.hide()
	super.drawChairs(chairs, chairsCount, maxChairs)

func _on_oui_pressed() -> void:
	hasCloth = true
	queue_redraw()

func _on_non_pressed() -> void:
	hasCloth = false
	queue_redraw()

func _on_clickable_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		showMenu = !showMenu
		queue_redraw()
