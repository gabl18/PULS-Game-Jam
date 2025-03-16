extends Node2D
class_name Notification

@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")

@export var animation_player: AnimationPlayer

signal _continue

var done := false

func play_sfx(sound_path: String):
	sfx_player.stream = load(sound_path)
	sfx_player.play()

func _ready() -> void:
	animation_player.play('pop_up')
	play_sfx("res://assets/Audio/Sfx/notification.ogg")


func _on_nine_patch_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		animation_player.play('click')
		play_sfx("res://assets/Audio/Sfx/lvl_done.ogg")
		done = true

func __continue(_n):
	if done:
		_continue.emit()
