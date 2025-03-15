extends Node
class_name LightComponent

@export var sprite: Sprite2D
@export var texture_off: Texture2D
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
	else:
		sprite.texture = texture_off
