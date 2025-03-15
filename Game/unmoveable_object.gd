@tool
extends RigidBody2D

@export var laser_component: LaserComponent
@export var light_component: LightComponent

@export_group('Collision')
@export var with_laser := true:
	
	set(value):
		print(12)
		with_laser = value
		if with_laser:
			is_mirror = false
		set_collision_layer_value(4,value)
		
@export var is_mirror := false:
	set(value):
		is_mirror = value
		if is_mirror:
			add_to_group('Mirrors')
			with_laser = false
		else:
			remove_from_group('Mirrors')
		set_collision_layer_value(5,value)
		
@export var with_objects := true:
	set(value):
		with_objects = value
		set_collision_layer_value(1,value)
	
@warning_ignore('unused_signal')
signal laser_collided(laser,entered:bool)
signal laser_collision_changed(entered:bool)

var colliding_lasers: Array
var is_laser_colliding := false:
	set(value):
		if value != is_laser_colliding:
			laser_collision_changed.emit(value)
		is_laser_colliding = value

func _ready() -> void:
	laser_collided.connect(_handle_lasers)
	
	if light_component:
		laser_collision_changed.connect(light_component._collision_laser)

func _handle_lasers(laser,entered:bool):
	if entered:
		colliding_lasers.append(laser)
	else:
		if laser in colliding_lasers:
			colliding_lasers.erase(laser)
	
	is_laser_colliding = colliding_lasers.size() != 0
