extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var label: Label = $CanvasLayer/MarginContainer/Label
var started = false
func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton)and not started:
		started = true
		animation_player.play('Starting_Zoom')
		label.hide()
		
		await animation_player.animation_finished
		animation_player.speed_scale = 0.1
		animation_player.play("Logos_Fading")
		
		await animation_player.animation_finished
		if is_inside_tree():
			pass
		else:
			await tree_entered
		get_tree().change_scene_to_file('res://UI/Main.tscn')

func _ready() -> void:
	texture_rect.scale = Vector2(1,1)
	texture_rect.position = Vector2(0,0)
	$CanvasLayer/TextureRect/Control/JamCred.modulate.a = 0
	$CanvasLayer/TextureRect/Control/Jam.modulate.a = 0
	$CanvasLayer/TextureRect/Control/OurCred.modulate.a = 0
	
	
