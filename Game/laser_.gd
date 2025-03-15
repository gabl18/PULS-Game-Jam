extends RayCast2D

@export var line: Line2D

var change = false
var max_bounce = 50

func _process(delta):
	
	if change or true:
		clear_exceptions()
		line.clear_points()
		#
		var start_pos = global_position
		line.global_position = global_position
		line.add_point(line.to_local(global_position))

		target_position = Vector2.RIGHT * 1000  # Ray direction
		force_raycast_update()
		
		var prev = null
		var bounce = 0

		while bounce < max_bounce:
			bounce += 1

			if not is_colliding():
				var pt = to_global(target_position)

				line.add_point(line.to_local(pt))
				break

			# Get the collision point and normal
			var collision_point = get_collision_point()
			var collision_normal = get_collision_normal().normalized()
			var collider = get_collider()
			
			# Calculate the incident vector (direction from ray origin to collision point)
			var incident_vector = (collision_point - global_position).normalized()

			# Calculate the correct reflection vector
			var reflection_vector = incident_vector.bounce(collision_normal)

			line.add_point(line.to_local(collision_point))

			
			if not collider.is_in_group("Mirrors"):
				break
				
			if collision_normal == Vector2.ZERO:
				break
			
			if prev != null:
				remove_exception(prev)
				
			prev = collider
			add_exception(prev)
				
			global_position = collision_point
			target_position = to_local(collision_point + reflection_vector * 1000)

			force_raycast_update()
			
			remove_exception(prev)
			
		global_position = start_pos
