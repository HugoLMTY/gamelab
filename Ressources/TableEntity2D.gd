extends StaticBody2D
class_name TableEntity2D

func drawChairButtons(container: HBoxContainer, maxChairs: int, on_count_change: Callable) -> void:
	for chairIndex in range(maxChairs + 1):
		var button = Button.new()
		button.text = str(chairIndex)
		button.pressed.connect(on_count_change.bind(chairIndex))
		container.add_child(button)

func drawChairs(chairs: Array[StaticBody2D], chairsCount: int, maxChairs: int) -> void:
	for chairIndex in range(maxChairs):
		var targetChair = chairs[chairIndex]
		if chairIndex + 1 <= chairsCount:
			targetChair.show()
			targetChair.set_collision_layer(1)
		else:
			targetChair.hide()
			targetChair.set_collision_layer(0)
