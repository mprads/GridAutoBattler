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


func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		_handle_left_click()

	if event.is_action_released("left_click"):
		GameEvents.left_click_released.emit()


func _handle_left_click() -> void:
	var mouse_position = get_global_mouse_position()

	var selected_tile = tile_controller.convert_world_position_to_id(mouse_position, "player")
	var selected_tile_data = tile_controller.get_tile_data(selected_tile, "player")

	if selected_tile_data.is_empty():
		return

	var tile_has_unit = selected_tile_data["unit"]

	if tile_has_unit:
		selected_unit = tile_has_unit
		GameEvents.emit_unit_selected(selected_unit)
		return


func _handle_right_click() -> void:
	GameEvents.emit_right_click_pressed()


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

