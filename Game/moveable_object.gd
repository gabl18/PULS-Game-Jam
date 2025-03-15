@tool
extends CharacterBody2D

@export var rotateable: bool = true
@export var moveable: bool = true

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

var dragged = false
var offset: Vector2
var target_position: Vector2
var drag_speed: float = 30.0  # Adjust for faster/slower movement
var rotate_speed: float = 5.0  # Adjust for faster/slower rotation
var is_rotating: bool = false
var rotation_offset: float = 0.0  # Stores the initial rotation offset

func _ready() -> void:
	laser_collided.connect(_handle_lasers)
	
	if light_component:
		laser_collision_changed.connect(light_component._collision_laser)

func _handle_lasers(laser,entered:bool):
	if entered:
		if not (laser_component and laser == laser_component.laser):
				
			colliding_lasers.append(laser)
		else:
			print(1)
	else:
		if laser in colliding_lasers:
			colliding_lasers.erase(laser)
	
	is_laser_colliding = colliding_lasers.size() != 0

func _process(delta: float) -> void:
	if dragged and moveable:
		
		# Calculate the target position (mouse position + offset)
		target_position = get_global_mouse_position() + offset

		# Move smoothly toward the target position
		var motion = (target_position - global_position) * drag_speed * delta
		move_and_collide(motion)

	if is_rotating and rotateable:
		# Rotate to face the mouse cursor with an offset
		rotate_toward_mouse(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and moveable:
			if not event.is_pressed():
				# Stop dragging when the left mouse button is released
				dragged = false
				set_collision_mask_value(1,false)
		elif event.button_index == MOUSE_BUTTON_RIGHT and rotateable:#
			if  not event.is_pressed():
				# Start rotating when the right mouse button is pressed
				is_rotating = false


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and moveable:
			if event.is_pressed():
				# Start dragging when the left mouse button is pressed
				dragged = true
				set_collision_mask_value(1,true)
				offset = global_position - get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_RIGHT and rotateable:
			if event.is_pressed():
				# Start rotating when the right mouse button is pressed
				is_rotating = true
				# Calculate the initial rotation offset
				var mouse_position = get_global_mouse_position()
				var direction = (mouse_position - global_position).normalized()
				rotation_offset = rotation - direction.angle()

func rotate_toward_mouse(delta: float) -> void:
	# Calculate the direction to the mouse cursor
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - global_position).normalized()

	# Calculate the target rotation angle with the offset
	var target_rotation = direction.angle() + rotation_offset

	# Smoothly interpolate toward the target rotation
	rotation = lerp_angle(rotation, target_rotation, rotate_speed * delta)

	# Apply collision detection during rotation
	move_and_collide(Vector2.ZERO)
