extends Node
#TODO: turn this into a weighted table
@export var pool: Array[Unit] = []


func get_random() -> Unit:
	return pool[0]
