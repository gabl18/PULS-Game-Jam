extends Node2D
class_name Level

signal finished_level


func _process(_delta: float) -> void:
	if get_tree().get_nodes_in_group('Lights').all(func(x): return x.on):
		finished_level.emit()
		
