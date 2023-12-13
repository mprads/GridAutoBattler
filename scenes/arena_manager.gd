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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		_handle_left_click()

	if event.is_action_released("left_click"):
		_handle_left_click_release()


func _handle_left_click_release() -> void:
	GameEvents.left_click_released.emit()
	var selected_tile = _get_tile_data_from_mouse_pos()

	if !selected_tile:
		return

	if selected_tile["data"]["unit"]:
		return

	var player_tile = tile_controller.convert_world_position_to_id(selected_unit.global_position, "player", Vector2(0, 16))
	var selected_tile_pos = tile_controller.convert_id_to_world_position(Vector2i(selected_tile["id"]), "player", Vector2(0, 16))

	tile_controller.update_tile_data(Vector2i(selected_tile["id"]), "unit", "player", selected_unit)
	tile_controller.update_tile_data(player_tile, "unit", "player", null)
	selected_unit.update_position(selected_tile_pos)

func _handle_left_click() -> void:
	var selected_tile = _get_tile_data_from_mouse_pos()

	if selected_tile["data"].is_empty():
		return

	var tile_has_unit = selected_tile["data"]["unit"]

	if tile_has_unit:
		selected_unit = tile_has_unit
		GameEvents.emit_unit_selected(selected_unit)
		return


func _get_tile_data_from_mouse_pos() -> Dictionary:
	var mouse_position = get_global_mouse_position()
	var selected_tile = tile_controller.convert_world_position_to_id(mouse_position, "player", Vector2(0, 0))
	return tile_controller.get_tile_data(selected_tile, "player")


func _generate_party():
	var count = 0
	for unit in resource_party:
		var unit_instance = _generate_unit(unit)
		var player_party = get_tree().get_first_node_in_group("PlayerParty")
		unit_instance.global_position = tile_controller.convert_id_to_world_position(Vector2i(0, count), "player", Vector2(0, 16))
		tile_controller.update_tile_data(Vector2i(0, count), "unit", "player", unit_instance)

		player_party.add_child(unit_instance)
		party.push_back(unit_instance)
		count += 1


func _generate_unit(unit: Unit) -> Node2D:
	var unit_instance = unit_scene.instantiate()
	unit_instance.set_unit_type(unit)
	return unit_instance

