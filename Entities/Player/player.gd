extends Entity2D
class_name Player

@onready var playerSprite: Sprite2D = $Sprite2D
@onready var dashParticles: CPUParticles2D = $DashPaticles

@export var dashSpeed := 420

func _physics_process(delta: float) -> void:
	var directionX = Input.get_axis("left", "right")
	var directionY = Input.get_axis("up", "down")
	direction = Vector2(directionX, directionY)

	moveTo(direction, delta)
	
	if abs(direction.x):
		playerSprite.flip_h = direction.x < 0
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("shift"): dash()

func dash() -> void:
	if PlayerDatas.cooldowns.dash > 0 or stunned: return
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(self, "rotation", deg_to_rad(360 * lastDirection.x), 0.5)
	#tween.tween_property(self, "scale", 0.8, 0.5)

	impulseVelocity += lastDirection.normalized() * dashSpeed
	dashParticles.emitting = true

	PlayerDatas.dash()
