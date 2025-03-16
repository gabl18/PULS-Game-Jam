extends Node
class_name LightComponent
@export var sprite: Sprite2D
@export var texture_off: Texture2D
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
var texture_on: Texture2D

var on := false

	
func _ready() -> void:
	texture_on = sprite.texture
	sprite.texture = texture_off
	add_to_group('Lights')
	
func _collision_laser(entered:bool):
	on = entered
	if entered:
		sprite.texture = texture_on
		sfx_player.stream = load("res://assets/Audio/Sfx/collect-5.ogg")
		sfx_player.play()
	else:
		sprite.texture = texture_off
