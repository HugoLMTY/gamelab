extends Entity2D
class_name Customer

var possibleTypes := 4
@export_range(1, 4, 1) var type

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationPlayer = %AnimationPlayer
@onready var orderContainer: VBoxContainer = %OrderContainer
@onready var menu: Panel = %OrderMenu

@onready var consumingTimer: Timer = %ConsumationTimer
@onready var drinkingProgressBar: ProgressBar = %ConsumationProgressBar

@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D
@onready var interactiveZone: InteractiveZone = $InteractiveZone

var orderManager := OrderManager.new()

var goingToChair := false
var awaitingOrder := false
var consuming := false
var leavingTavern := false

func _ready() -> void:
	get_node("%ClickableZone").show()
	
	_draw_menu()
	
	menu.hide()
	interactiveZone.hide()
	drinkingProgressBar.hide()

	SignalBus.chairPicked.connect(_on_chair_picked)
	orderManager.orderUpdated.connect(_draw_menu)
	orderManager.orderFilled.connect(_on_order_filled)

func _process(_delta: float) -> void:
	if consuming: drinkingProgressBar.value = consumingTimer.time_left / consumingTimer.wait_time * 100

func _draw() -> void:
	var path = str("res://assets/characters/drinkers/drinker-", str(int(type if type else 1)), ".png")
	sprite.texture = load(path)
	
	speed = 25
	PlayerDatas.pickingChair = PlayerDatas.selectedCustomer == self
	
func _draw_menu() -> void:
	for item in orderManager.order:
		var orderItem: Dictionary = orderManager.order.get(item, {})
		if orderItem.is_empty(): continue
		if orderItem.get("waiting", 0) <= 0: continue
		
		for child in orderContainer.get_children():
			orderContainer.remove_child(child)
		
		var label = Label.new()
		label.text = str(item, " x", orderItem.get("waiting", 0))
		orderContainer.add_child(label)

func _physics_process(_delta: float) -> void:
	if !goingToChair and !leavingTavern: return

	direction = to_local(navigationAgent.get_next_path_position())
	velocity = direction
	move_and_slide()

func _on_clickable_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if !(event is InputEventMouseButton and event.pressed):
		return
		
	if awaitingOrder:
		if menu.visible:
			menu.hide()
		else:
			menu.show()
	else:
		PlayerDatas.selectedCustomer = null if PlayerDatas.selectedCustomer == self else self
		queue_redraw()

func _on_chair_picked(chair: Chair) -> void:
	if chair.chairReached.is_connected(_on_chair_reached):
		chair.chairReached.disconnect(_on_chair_reached)
	chair.chairReached.connect(_on_chair_reached)
	
	if consumingTimer.timeout.is_connected(_on_consuming_end):
		consumingTimer.timeout.disconnect(_on_consuming_end)
	consumingTimer.timeout.connect(_on_consuming_end.bind(chair))

	goingToChair = true
	navigationAgent.target_position = chair.global_position

func _on_chair_reached(chair: Chair) -> void:
	chair.set_unavailable()
	position = chair.global_position
	position.y -= 17

	goingToChair = false
	awaitingOrder = true
	interactiveZone.show()

func _on_order_filled() -> void:
	awaitingOrder = false
	consuming = true
	animator.play("drinking")

	interactiveZone.hide()
	drinkingProgressBar.show()

	consumingTimer.start()

func _on_consuming_end(chair: Chair) -> void:
	animator.play("RESET")
	consumingTimer.stop()
	drinkingProgressBar.hide()
	
	chair.set_available()
	TavernDatas.gain_xp(10)

	go_to_exit()

func go_to_exit() -> void:
	leavingTavern = true

	var exitArea = get_tree().get_first_node_in_group("exit-areas")
	if !exitArea: return

	navigationAgent.target_position = exitArea.global_position


func _on_interactive_zone_interacted() -> void:
	if !awaitingOrder:
		return

	for item in orderManager.possibleItems:
		var orderItem: Dictionary = orderManager.order.get(item, {})
		if orderItem.is_empty() or orderItem.get("waiting", 0) <= 0:
			continue
		
		if PlayerDatas.inventory.get(item, 0) <= 0:
			continue
			
		PlayerDatas.take_from_inventory(item)
		orderManager.add_item_to_order(item)
