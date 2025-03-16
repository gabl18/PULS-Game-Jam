extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play('pop_up')

func _on_nine_patch_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		animation_player.play('click')
