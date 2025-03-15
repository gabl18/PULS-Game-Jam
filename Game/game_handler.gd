extends Control
@onready var level_container: Node2D = $Level_Container

var level_instance

func _ready() -> void:
	load_level(load("res://Game/level0.tscn"))


func load_level(level:PackedScene):
	unload_level()
	level_instance = level.instantiate()

	level_container.add_child(level_instance)
	
func unload_level():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
