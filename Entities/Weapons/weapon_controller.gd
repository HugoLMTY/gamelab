extends StaticBody2D

@export var holder: Entity2D
@onready var attackCooldownTimer: Timer = $AttackCooldown
@onready var collisionHitbox: Area2D = $CollisionHitbox
@onready var sprite: Sprite2D = $Sprite2D

var canAttack := true
@export var attackCooldown := 0.1


func _physics_process(delta: float) -> void:
	rotation = (get_global_mouse_position() - global_position).angle() + deg_to_rad (90)
	#sprite.flip_h = rotation > 3 or rotation < 0
	if !holder:
		return
	
	#position = Vector2(
	#	10 if holder.lastDirection.x > 0 else -10,
	#	10
	#)
	#rotation = rad_to_deg(1 if holder.lastDirection.x > 0 else -1)
	pass

func attack() -> void:
	#sprite.set_visible(true)
	#collisionHitbox.monitoring = true
	canAttack = false
	attackCooldownTimer.start(attackCooldown)
	var attackTween := get_tree().create_tween()
	attackTween.tween_property(sprite, "rotation", Vector2(1, 0), 0.1)

func _on_attack_cooldown_timeout() -> void:
	canAttack = true
	#sprite.set_visible(false)
	#collisionHitbox.monitoring = false


func _on_collision_hitbox_body_entered(body: Node2D) -> void:
	print(body)

	if body is not Entity2D: return
	if body is PlayerController: return

	body.takeDamage(position)
