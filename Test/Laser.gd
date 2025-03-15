extends RayCast2D

@onready var line_in: Line2D = $IN
@onready var line_normal: Line2D = $Normal
@onready var line_out: Line2D = $Out

func _process(delta):
	line_in.global_position = global_position
	target_position = Vector2.RIGHT * 1000  # Ray direction

	force_raycast_update()

	if is_colliding():
		# Get the collision point and normal
		var collision_point = get_collision_point()
		var collision_normal = get_collision_normal().normalized()

		# Calculate the incident vector (direction from ray origin to collision point)
		var incident_vector = (collision_point - global_position).normalized()

		# Calculate the correct reflection vector
		var reflection_vector = incident_vector.bounce(collision_normal)

		# Output the reflection vector
		print("Reflection Vector: ", reflection_vector)

		# Clear previous lines
		line_in.clear_points()
		line_out.clear_points()
		line_normal.clear_points()

		# Draw incident ray
		line_in.add_point(line_in.to_local(global_position))
		line_in.add_point(line_in.to_local(collision_point))

		# Draw reflected ray
		line_out.add_point(line_out.to_local(collision_point))
		line_out.add_point(line_out.to_local(collision_point + reflection_vector * 1000))

		# Draw normal at the collision point
		line_normal.add_point(line_normal.to_local(collision_point))
		line_normal.add_point(line_normal.to_local(collision_point + collision_normal * 20))  # Make it longer for clarity
