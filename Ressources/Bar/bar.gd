extends StaticBody2D

@onready var menu: Panel = $Menu

var showMenu := false

func _draw() -> void:
	if showMenu:
		menu.show()
	else:
		menu.hide()

func _on_clickable_zone_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		showMenu = !showMenu
		queue_redraw()
