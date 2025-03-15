extends Control
@onready var level_container: Node2D = $Level_Container
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var music_bus_id = AudioServer.get_bus_index("Music")

var level_instance

func _ready() -> void:
	load_level(load("res://Game/level0.tscn"))
	audio_player.volume_db = linear_to_db(0.5)
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, false)
	AudioServer.set_bus_effect_enabled(music_bus_id, 2, false)


func load_level(level:PackedScene):
	unload_level()
	level_instance = level.instantiate()

	level_container.add_child(level_instance)
	
func unload_level():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
