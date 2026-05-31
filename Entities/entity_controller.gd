extends CharacterBody2D
class_name Entity2D

@export var speed := 100.0
@export var acceleration := 1200.0
@export var friction := 1500.0

var direction := Vector2(0, 0)
var lastDirection := Vector2(1, 0)
var moveVelocity := Vector2(0, 0)
var impulseVelocity := Vector2(0, 0)

var stunned := false
var stunDuration := 0.5
var stunTimer := Timer.new()

func _ready() -> void:
	add_child(stunTimer)
	stunTimer.timeout.connect(func () -> void: stunned = false)

func moveTo(targetDirection: Vector2, delta: float) -> void:
	var inputDirection = targetDirection.normalized() if targetDirection.length_squared() > 1 else targetDirection
	var targetVelocity = Vector2.ZERO if stunned else inputDirection * speed
	var velocityChange = acceleration if targetVelocity.length_squared() > 0 else friction
	
	moveVelocity = moveVelocity.move_toward(targetVelocity, velocityChange * delta)
	impulseVelocity = impulseVelocity.move_toward(Vector2.ZERO, friction * delta)
	velocity = moveVelocity + impulseVelocity
	
	if inputDirection.length_squared() > 0:
		lastDirection = inputDirection

func stun () -> void:
	stunned = true
	stunTimer.start(stunDuration)
	
func bump(bumpDirection: Vector2 = Vector2(1, 1), force: Vector2 = Vector2(2, 2)) -> void:
	impulseVelocity += bumpDirection * force * 200

func takeDamage(origin: Vector2, _damages: int = 1) -> void:
	var offset = Vector2(position.x - origin.x, position.y - origin.y)
	var bumpDirection = Vector2(
		1 if offset.x > 0 else -1,
		1 if offset.y > 0 else -1
	)
	
	#hitstop()
	stun()
	bump(bumpDirection)


func hitstop (duration := 0.1) -> void:
	Engine.time_scale = 0.05
	await get_tree().create_timer(duration, false, false, true).timeout
	Engine.time_scale = 1
	pass
