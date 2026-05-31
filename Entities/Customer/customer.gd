extends Entity2D
class_name Customer

var possibleTypes := 4
@export_range(1, 4, 1) var type

@onready var sprite: Sprite2D = $Sprite2D
@onready var btnContainer: HBoxContainer = $Menu/BtnContainer
@onready var menu: Panel = $Menu

@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D

var walkingToChair := false
var drinking := false

var targetChair: Chair

var showMenu := false

func _draw() -> void:
	var path = str("res://assets/characters/drinkers/drinker-", str(int(type)), ".png")
	sprite.texture = load(path)
	
	speed = 25
	
	menu.hide()
	if PlayerDatas.selectedCustomer == self:
		#menu.show()
		PlayerDatas.pickingChair = true
	else:
		#menu.hide()
		PlayerDatas.pickingChair = false

func _ready() -> void:
	SignalBus.chairPicked.connect(_on_chair_picked)

	for possibleType in range(possibleTypes):
		var btn = Button.new()
		btn.text = str(possibleType + 1)
		btn.pressed.connect(func(): type = possibleType + 1; queue_redraw())
		btnContainer.add_child(btn)

func _physics_process(_delta: float) -> void:
	var direction = to_local(navigationAgent.get_next_path_position())
	velocity = direction
	
	move_and_slide()

func _on_clickable_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		#showMenu = !showMenu
		PlayerDatas.selectedCustomer = null if PlayerDatas.selectedCustomer == self else self
		queue_redraw()

func _on_chair_picked(chair: Chair) -> void:
	print(chair)
	targetChair = chair
	navigationAgent.target_position = chair.global_position
