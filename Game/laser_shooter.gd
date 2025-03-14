extends CharacterBody2D

@onready var laser: Node2D = $Laser
@export_range(1,50) var x: float = 1

var dragged = false
var offset: Vector2
var target_position: Vector2
var drag_speed: float = 10.0  # Adjust for faster/slower movement
var rotate_speed: float = 5.0  # Adjust for faster/slower rotation
var is_rotating: bool = false
var rotation_offset: float = 0.0  # Stores the initial rotation offset

func _process(delta: float) -> void:
	if dragged:
		# Calculate the target position (mouse position + offset)
		target_position = get_global_mouse_position() + offset

		# Move smoothly toward the target position
		var motion = (target_position - global_position) * drag_speed * delta
		move_and_collide(motion)

	if is_rotating:
		# Rotate to face the mouse cursor with an offset
		rotate_toward_mouse(delta)

		laser.direction = Vector2.RIGHT.from_angle(rotation/100000)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if not event.is_pressed():
				# Stop dragging when the left mouse button is released
				dragged = false
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				# Start rotating when the right mouse button is pressed
				is_rotating = true
				# Calculate the initial rotation offset
				var mouse_position = get_global_mouse_position()
				var direction = (mouse_position - global_position).normalized()
				rotation_offset = rotation - direction.angle()
			else:
				# Stop rotating when the right mouse button is released
				is_rotating = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				# Start dragging when the left mouse button is pressed
				dragged = true
				offset = global_position - get_global_mouse_position()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
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
