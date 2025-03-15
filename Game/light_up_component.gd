extends Node2D
class_name LightComponent

var on := false


func _ready() -> void:
	add_to_group('Lights')
	

func _collision_laser(entered:bool):
	on = entered
