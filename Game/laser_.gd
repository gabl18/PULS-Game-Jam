extends RayCast2D

@export var line: Line2D

var change = false
var max_bounce = 10

var collisions: Array
var old_collisions: Array

var on:bool

func _process(delta):
	old_collisions = collisions.duplicate()
	collisions.clear()
	line.clear_points()
	clear_exceptions()

	if on:
		#
		var start_pos = global_position
		line.global_position = global_position
		line.add_point(line.to_local(global_position))

		target_position = Vector2.RIGHT * 10000  # Ray direction
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
			
			if collider.has_signal('laser_collided') and collider not in collisions:

				collisions.append(collider)
			
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
			target_position = to_local(collision_point + reflection_vector * 10000)

			force_raycast_update()
			
			remove_exception(prev)
			
		global_position = start_pos
		

	for x in collisions.filter(func(item): return item not in old_collisions):
		x.laser_collided.emit(self,true)

	for x in old_collisions.filter(func(item): return item not in collisions):
		x.laser_collided.emit(self,false)
