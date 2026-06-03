extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is Customer and body.leavingTavern:
		body.queue_free()
		TavernDatas.spawn_customer()
