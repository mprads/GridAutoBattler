extends Node2D

@export var unit_object: PackedScene

@onready var tile_controller = $"../TileController"

var party: Array[Unit] = []

func _ready() -> void:
	#party = Party.get_party()
	party.push_back(UnitPool.get_random())

	for unit in party:
		var unit_instance = unit_object.instantiate()
		var player_party = get_tree().get_first_node_in_group("PlayerParty")
		unit_instance.set_unit_type(unit)
		player_party.add_child(unit_instance)
		unit_instance.global_position = Vector2(58, 87)
