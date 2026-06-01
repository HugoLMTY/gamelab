extends Panel

@onready var content: VBoxContainer = %InventoryContent

func _draw() -> void:
	for child in content.get_children():
		content.remove_child(child)

	for item in PlayerDatas.inventory:
		var label = Label.new()
		label.text = str(item, " x", PlayerDatas.inventory[item])
		content.add_child(label)

func _ready() -> void:
	PlayerDatas.inventoryUpdated.connect(func(): queue_redraw())
