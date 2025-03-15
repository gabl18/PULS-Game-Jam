extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var label: Label = $CanvasLayer/MarginContainer/Label
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_player2: AudioStreamPlayer = $AudioStreamPlayer2
@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")

var started = false
func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton)and not started:
		started = true
		
		AudioServer.set_bus_effect_enabled(music_bus_id, 1, false)
		audio_player.volume_db = linear_to_db(0.5)
		audio_player2.play()
		#AudioServer.set_bus_effect_enabled(bus_index, 0, true)
		animation_player.speed_scale = 0.1
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
	audio_player.volume_db = linear_to_db(0.25)
	animation_player.speed_scale = 1
	animation_player.play('flicker')
	
	
