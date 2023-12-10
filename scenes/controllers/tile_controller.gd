extends Node2D

@export var player_tile_map: TileMap
@export var enemy_tile_map: TileMap

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]

var ground_source = 0
var ground_layer = 0
var ground_atlas = Vector2i(0, 0)

var player_grid = {}
var enemy_grid = {}


func _ready() -> void:
	generate_map(4, 4, player_tile_map, player_grid)
	generate_map(4, 4, enemy_tile_map, enemy_grid)


func generate_map(x: int, y: int, map, grid) -> void:
	for i in x:
		for j in y:
			grid[str(Vector2i(i, j))] = {
				"occupied": false
			}
			map.set_cell(ground_layer, Vector2i(i, j), ground_source, ground_atlas)
