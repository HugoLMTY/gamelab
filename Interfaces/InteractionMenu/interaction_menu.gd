extends Panel

signal interacted


func _on_button_pressed() -> void:
	emit_signal("interacted")
