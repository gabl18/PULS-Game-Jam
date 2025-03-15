@tool
extends RigidBody2D

@export_group('Collision')
@export var with_laser := true:
	
	set(value):
		with_laser = value
		if with_laser:
			is_mirror = false
		set_collision_layer_value(4,value)
		set_collision_mask_value(4,value)
		
@export var is_mirror := false:
	set(value):
		is_mirror = value
		if is_mirror:
			add_to_group('Mirrors')
			with_laser = false
		else:
			remove_from_group('Mirrors')
		set_collision_layer_value(5,value)
		set_collision_mask_value(5,value)
		
@export var with_objects := true:
	set(value):
		with_objects = value
		set_collision_layer_value(1,value)
