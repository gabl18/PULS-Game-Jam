extends Node2D
class_name Notification

@export var animation_player: AnimationPlayer

signal _continue

var done := false

func _ready() -> void:
	animation_player.play('pop_up')

func _on_nine_patch_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		animation_player.play('click')
		done = true

func __continue(_n):
	if done:
		_continue.emit()
