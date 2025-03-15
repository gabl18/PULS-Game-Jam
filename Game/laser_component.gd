extends Node2D
class_name LaserComponent

@onready var laser: RayCast2D = $Laser
@onready var line_2d: Line2D = $Line2D

@export var always_on := true
@export var color: Color = Color('ab3a00')
@export var sprite: Sprite2D
@export var opt_texture_on: Texture2D
@export var opt_texture_off: Texture2D

var texture_on : Texture

func _ready() -> void:
	line_2d.default_color = color
	texture_on = sprite.texture
	if opt_texture_off == null:
		opt_texture_off = texture_on
	if opt_texture_on == null:
		opt_texture_on = texture_on
		
	laser.on = always_on
	if not always_on:
		sprite.texture = opt_texture_off
		
		
func _collision_laser(entered:bool):
	if not always_on:
		if entered:
			sprite.texture = opt_texture_on
			laser.on = true
		else:
			sprite.texture = opt_texture_off
			laser.on = false
