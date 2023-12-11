extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var unit_type: Unit


func _ready() -> void:
	if unit_type == null:
		return

	_set_texture()


func set_unit_type(type: Unit) -> void:
	if unit_type != null:
		return

	unit_type = type

func _set_texture() -> void:
	sprite_2d.texture = unit_type.sprite
