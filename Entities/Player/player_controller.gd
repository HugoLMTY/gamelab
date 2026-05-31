extends Entity2D
class_name PlayerController

@onready var playerSprite: Sprite2D = $Sprite2D

@onready var dashParticles: CPUParticles2D = $DashPaticles 
@onready var weapon: StaticBody2D = $Weapon

@export var dashSpeed := 420
@export var dashCooldown := 0.5

var timeouts = {
	"dash": 0.0
}

func _physics_process(delta: float) -> void:
	var directionX = Input.get_axis("left", "right")
	var directionY = Input.get_axis("up", "down")
	direction = Vector2(directionX, directionY)

	moveTo(direction, delta)
	
	if abs(direction.x):
		playerSprite.flip_h = direction.x < 0
	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"): weapon.attack()
	if Input.is_action_pressed("shift"): dash()

	for to in timeouts:
		timeouts	[to] -= delta

func dash() -> void:
	if timeouts.dash > 0 or stunned: return
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "rotation", deg_to_rad(360 * lastDirection.x), 0.5)
	#tween.tween_property(self, "scale", 0.8, 0.5)

	impulseVelocity += lastDirection.normalized() * dashSpeed
	dashParticles.emitting = true

	timeouts.dash = dashCooldown
