extends Control

@onready var level_container: Node2D = %Level_Container

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var music_bus_id = AudioServer.get_bus_index("Music")


@export var levels : Array[PackedScene]

var level_instance: Level


func _ready() -> void:
	play_level(0)
 	audio_player.volume_db = linear_to_db(0.5)
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, false)
	AudioServer.set_bus_effect_enabled(music_bus_id, 2, false)
	
func play_level(index:int):
	
	load_level(levels[index])
	
	await level_instance.finished_level

	## Congrats Scene
	
	play_level(index + 1)
	
func load_level(level:PackedScene):
	unload_level()
	level_instance = level.instantiate()

	level_container.add_child(level_instance)
	
func unload_level():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
