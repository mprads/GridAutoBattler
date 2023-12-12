extends Node2D

@onready var player_tile_map: TileMap = $"../PlayerTileMap"
@onready var enemy_tile_map: TileMap = $"../EnemyTileMap"

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

var ground_source = 0
var ground_layer = 0
var ground_atlas = Vector2i(0, 0)


var tile_maps: Dictionary
var grids: Dictionary = {
		"player": {},
		"enemy": {}
	}


func _ready() -> void:
	tile_maps = {
		"player": player_tile_map,
		"enemy": enemy_tile_map
	}

	_generate_map(4, 4, player_tile_map, grids["player"])
	_generate_map(4, 4, enemy_tile_map, grids["enemy"])


func _generate_map(x: int, y: int, map, grid) -> void:
	for i in x:
		for j in y:
			grid[str(Vector2i(i, j))] = {
				"unit": null
			}
			map.set_cell(ground_layer, Vector2i(i, j), ground_source, ground_atlas)


func convert_world_position_to_id(pos: Vector2, tile_map: String) -> Vector2i:
	if tile_map == null:
		return Vector2i(0,0)

	return tile_maps[tile_map].local_to_map(pos)


func convert_id_to_world_position(id: Vector2i, tile_map: String) -> Vector2:
	if tile_map == null:
		return Vector2(0,0)

	#Need to account for the displacement of the tilemap and half of a tile
	return tile_maps[tile_map].global_position + tile_maps[tile_map].map_to_local(id) - Vector2(0, 16)


func update_tile_data(id: Vector2i, key: String, grid: String, value ) -> void:
	grids[grid][str(id)][key] = value
