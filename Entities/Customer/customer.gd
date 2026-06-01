extends Entity2D
class_name Customer

var possibleTypes := 4
@export_range(1, 4, 1) var type

@onready var sprite: Sprite2D = $Sprite2D
@onready var btnContainer: HBoxContainer = $Menu/BtnContainer
@onready var menu: Panel = $Menu

@onready var consumingTimer: Timer = %ConsumationTimer
@onready var drikingProgressBar: ProgressBar = %ConsumationProgressBar

@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D

var order := {"beer": 0}

var consuming := false
var leavingTavern := false

var showMenu := false

var toggleTimer := Timer.new()

func _process(_delta: float) -> void:
	if consuming: drikingProgressBar.value = consumingTimer.time_left / consumingTimer.wait_time * 100

func _draw() -> void:
	var path = str("res://assets/characters/drinkers/drinker-", str(int(type if type else 1)), ".png")
	sprite.texture = load(path)
	
	speed = 25
	
	menu.hide()
	PlayerDatas.pickingChair = PlayerDatas.selectedCustomer == self

func _ready() -> void:
	get_node("%ClickableZone").show()
	
	drikingProgressBar.hide()

	SignalBus.chairPicked.connect(_on_chair_picked)
	toggleTimer.timeout.connect(func():
		if type >= possibleTypes:
			type = 1
		else:
			type += 1
		queue_redraw()
		toggleTimer.start(1)
	)
	add_child(toggleTimer)
	#toggleTimer.start(1)

	for possibleType in range(possibleTypes):
		var btn = Button.new()
		btn.text = str(possibleType + 1)
		btn.pressed.connect(func(): type = possibleType + 1; queue_redraw())
		btnContainer.add_child(btn)

func _physics_process(_delta: float) -> void:
	if consuming and !leavingTavern: return

	direction = to_local(navigationAgent.get_next_path_position())
	velocity = direction
	move_and_slide()

func _on_clickable_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		PlayerDatas.selectedCustomer = null if PlayerDatas.selectedCustomer == self else self
		queue_redraw()

func _on_chair_picked(chair: Chair) -> void:
	if chair.chairReached.is_connected(_on_chair_reached):
		chair.chairReached.disconnect(_on_chair_reached)

	chair.chairReached.connect(_on_chair_reached)
	navigationAgent.target_position = chair.global_position
	
func _on_chair_reached(chair: Chair) -> void:
	leavingTavern = false
	consuming = true

	chair.available = false
	chair.remove_from_group("available-chairs")
	
	position = chair.global_position
	position.y -= 17
	
	drikingProgressBar.show()
	
	if consumingTimer.timeout.is_connected(_on_consuming_end):
		consumingTimer.timeout.disconnect(_on_consuming_end)
	consumingTimer.timeout.connect(_on_consuming_end.bind(chair))
	consumingTimer.start()
	
func _on_consuming_end(chair: Chair):
	consumingTimer.stop()

	chair.available = true
	chair.assignedCustomer = null
	chair.add_to_group("available-chairs")
	
	drikingProgressBar.hide()
	leavingTavern = true

	var exitArea = get_tree().get_first_node_in_group("exit-areas")
	if !exitArea: return

	navigationAgent.target_position = exitArea.global_position
