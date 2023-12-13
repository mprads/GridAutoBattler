extends Node

signal unit_selected(unit: Node2D)
signal left_click_released()


func emit_unit_selected(unit: Node2D) -> void:
	unit_selected.emit(unit)


func emit_left_click_released() -> void:
	left_click_released.emit()
