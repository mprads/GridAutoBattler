extends Node2D

@onready var player_tile_map: TileMap = $"../PlayerTileMap"
@onready var enemy_tile_map: TileMap = $"../EnemyTileMap"

var ground_source = 0
var ground_layer = 0
var ground_atlas = Vector2i(0, 0)

var hover_source = 1
var hover_layer = 1
var attack_atlas = Vector2i(1, 0)
var selected_atlas = Vector2i(2, 0)

var mouse_layer = 2
var mouse_atlas = Vector2i(0, 0)

var last_mouse_pos: Vector2

var tile_maps: Dictionary
var grids: Dictionary = {
		"player": {},
		"enemy": {}
	}


func _ready() -> void:
	GameEvents.unit_selected.connect(_on_unit_selected)
	tile_maps = {
		"player": player_tile_map,
		"enemy": enemy_tile_map
	}

	_generate_map(4, 4, player_tile_map, grids["player"])
	_generate_map(4, 4, enemy_tile_map, grids["enemy"])


func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

	if mouse_pos != last_mouse_pos:
		last_mouse_pos = mouse_pos
		_update_mouse_hover(mouse_pos)


func _generate_map(x: int, y: int, map, grid) -> void:
	for i in x:
		for j in y:
			grid[str(Vector2i(i, j))] = {
				"unit": null
			}
			map.set_cell(ground_layer, Vector2i(i, j), ground_source, ground_atlas)


func _update_mouse_hover(mouse_pos: Vector2) -> void:
	var player_pos = tile_maps["player"].local_to_map(mouse_pos - tile_maps["player"].global_position)
	var enemy_pos = tile_maps["enemy"].local_to_map(mouse_pos - tile_maps["enemy"].global_position)

	if grids["player"].has(str(player_pos)):
		tile_maps["player"].clear_layer(mouse_layer)
		tile_maps["player"].set_cell(mouse_layer, player_pos, hover_source, mouse_atlas)
	elif grids["enemy"].has(str(enemy_pos)):
		tile_maps["enemy"].clear_layer(mouse_layer)
		tile_maps["enemy"].set_cell(mouse_layer, enemy_pos, hover_source, mouse_atlas)


func clear_layer(layer_name: String, tile_map) -> void:
	match layer_name:
		"ground_layer":
			tile_maps[tile_map].clear_layer(ground_layer)
		"hover_layer":
			tile_maps[tile_map].clear_layer(hover_layer)
		"mouse_layer":
			tile_maps[tile_map].clear_layer(mouse_layer)


func convert_world_position_to_id(pos: Vector2, tile_map: String) -> Vector2i:
	if tile_map == null:
		return Vector2i(0,0)

	#Need to account for displacement of the tile map
	return tile_maps[tile_map].local_to_map(pos - tile_maps[tile_map].global_position + Vector2(0, 16))


func convert_id_to_world_position(id: Vector2i, tile_map: String) -> Vector2:
	if tile_map == null:
		return Vector2(0,0)

	#Need to account for the displacement of the tile map and half of a tile
	return tile_maps[tile_map].global_position + tile_maps[tile_map].map_to_local(id) - Vector2(0, 16)


func get_tile_data(id: Vector2i, grid) -> Dictionary:
	if grids[grid].has(str(id)):
		return grids[grid][str(id)]

	return {}


func update_tile_data(id: Vector2i, key: String, grid: String, value ) -> void:
	grids[grid][str(id)][key] = value


func _on_unit_selected(unit: Node2D) -> void:
	clear_layer("hover_layer", "player")
	tile_maps["player"].set_cell(hover_layer, convert_world_position_to_id(unit.global_position, "player"), hover_source, selected_atlas)
