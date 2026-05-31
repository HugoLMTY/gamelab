extends Entity2D
class_name EnemyController

@onready var sprite: Sprite2D = $Sprite2D
@onready var visionHitbox: Area2D = $Vision
@onready var hostilityTimer: Timer = $Hostility

var rng = RandomNumberGenerator.new()

var target: PlayerController

var wandering := false
var wanderDirection := Vector2(0, 0)
@export var wanderDuration := 3.0
var wanderTimer := Timer.new()

var hostile := false
@export var hostileDuration := 10


func _ready() -> void:
	super._ready()
	wanderDuration = rng.randf_range(1, 10)
	add_child(wanderTimer)
	wanderTimer.timeout.connect(toggleWander)
	toggleWander()

func _physics_process(delta: float) -> void:
	var currentDirection = Vector2(0, 0)

	if false and hostile and target:
		currentDirection = Vector2(
			1 if target.position.x > position.x else -1,
			1 if target.position.y > position.y else -1
		)
	elif wandering:
		currentDirection = wanderDirection

	if abs(currentDirection.x) > 0:
		sprite.flip_h = currentDirection.x < 0

	moveTo(currentDirection, delta)
	move_and_slide()

func toggleWander() -> void:
	if !wandering:
		findWanderDirection()
	wandering = !wandering
	wanderTimer.start(wanderDuration)
	
func findWanderDirection() -> void:
	wanderDirection = Vector2(
		1 if rng.randf_range(-1, 1) > 0 else -1,
		1 if rng.randf_range(-1, 1) > 0 else -1
	)

func _on_vision_body_entered(body: Node2D) -> void:
	#if body is not PlayerController: return
	if body is not Entity2D: return
	
	var player = get_tree().get_first_node_in_group("player")
	if !player: return
	
	if body is PlayerController or body is EnemyController and body.hostile:
		hostile = true
		hostilityTimer.start(hostileDuration)
		target = player


func _on_hostility_timeout() -> void:
	hostile = false


func _on_collision_body_entered(body: Node2D) -> void:
	if body is not PlayerController: return
	
	body.takeDamage(position)
