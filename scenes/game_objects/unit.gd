extends Node2D

signal picked_up_changed(picked)


@onready var sprite_2d: Sprite2D = $Sprite2D

var unit_type: Unit
var previous_position: Vector2
var is_selected: bool = false
var picked_up: bool = false :
	set(b):
		if not b:
			position = previous_position
		picked_up = b
		picked_up_changed.emit(b)


func _ready() -> void:
	GameEvents.left_click_released.connect(_on_left_click_released)
	GameEvents.unit_selected.connect(_on_unit_selected)
	if unit_type == null:
		return

	_set_texture()


func _process(delta) -> void:
	if is_selected:
		if picked_up:
			global_position = get_global_mouse_position()


func set_unit_type(type: Unit) -> void:
	if unit_type != null:
		return

	unit_type = type


func _set_texture() -> void:
	sprite_2d.texture = unit_type.sprite


func _handle_picked_up() -> void:
	picked_up = true
	previous_position = position


func _on_unit_selected(unit: Node2D) -> void:
	if unit == self:
		is_selected = true
		_handle_picked_up()
	else:
		is_selected = false


func _on_left_click_released() -> void:
	if picked_up:
		picked_up = false
