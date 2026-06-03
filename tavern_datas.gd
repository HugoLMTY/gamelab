extends Node
const CUSTOMER_SCENE := preload("res://Entities/Customer/Customer.tscn")

var xp := 0
var score := 0

signal xpUpdated

var customers: Array[Customer]

func gain_xp(xpAmount: int) -> void:
	xp += xpAmount
	emit_signal("xpUpdated")

func spawn_customer() -> void:
	var spawn = get_tree().get_first_node_in_group("spawn-areas")
	if !spawn:
		return
	
	var npc := CUSTOMER_SCENE.instantiate() as Customer
	add_child(npc)
	
	npc.global_position = spawn.global_position
	npc.type = RandomNumberGenerator.new().randf_range(1, 4)
