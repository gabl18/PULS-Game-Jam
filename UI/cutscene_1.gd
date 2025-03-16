extends Node2D
class_name Cutscene

@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

signal _continue

func play_sfx(sound_path: String):
	sfx_player.stream = load(sound_path)
	sfx_player.play()

func _ready() -> void:
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, true)
	AudioServer.set_bus_effect_enabled(music_bus_id, 3, true)
	play_sfx("res://assets/Audio/Sfx/computing.ogg")
	animation_player.play('pc_smash')
	await animation_player.animation_finished
	play_sfx("res://assets/Audio/Sfx/destroy.ogg")
	await get_tree().create_timer(2).timeout
	_continue.emit()
