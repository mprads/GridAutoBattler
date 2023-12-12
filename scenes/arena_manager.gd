extends Node2D

@export var unit_scene: PackedScene

@onready var tile_controller = $"../TileController"

var resource_party: Array[Unit] = []
var party: Array[Node2D] = []
var selected_unit: Node2D

func _ready() -> void:
	#party = Party.get_party()
	resource_party = UnitPool.get_all()

	_generate_party()

	selected_unit = party[0]

func _process(delta: float) -> void:
	if selected_unit:
		pass
	pass


func _generate_party():
	var count = 0
	for unit in resource_party:
		var unit_instance = _generate_unit(unit)
		var player_party = get_tree().get_first_node_in_group("PlayerParty")
		unit_instance.global_position = tile_controller.convert_id_to_world_position(Vector2i(0, count), "player")
		tile_controller.update_tile_data(Vector2i(0, count), "unit", "player", unit_instance)

		player_party.add_child(unit_instance)
		party.push_back(unit_instance)
		count += 1


func _generate_unit(unit: Unit) -> Node2D:
	var unit_instance = unit_scene.instantiate()
	unit_instance.set_unit_type(unit)
	return unit_instance

