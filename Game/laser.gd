extends Node2D

@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D

var change = false
var direction: Vector2 = Vector2.RIGHT

func _process(delta: float) -> void:
	line.clear_points()
	
	if change or true:
		line.add_point(Vector2.ZERO)
		
		ray.global_position = line.global_position
		
		ray.target_position = direction*100000
		ray.force_raycast_update()
		
		var prev = null
		
		while true:
			if not ray.is_colliding():
				var pt = ray.global_position + ray.target_position
				line.add_point(line.to_local(pt))
				break
			
			var coll = ray.get_collider()
			var pt = ray.get_collision_point()
			
			line.add_point(line.to_local(pt))
			
			if not coll.is_in_group("Mirrors"):
				break
			
			var normal = ray.get_collision_normal()
			
			if normal == Vector2.ZERO:
				break
				
			if prev != null:
				prev.set_collision_mask_value(5,true)
				prev.set_collision_mask_value(4,true)
				prev.set_collision_layer_value(5,true)
				prev.set_collision_layer_value(4,true)
				
			prev = coll
			prev.set_collision_mask_value(5,false)
			prev.set_collision_mask_value(4,false)
			prev.set_collision_layer_value(5,false)
			prev.set_collision_layer_value(4,false)
			
			ray.global_position = pt
			ray.target_position = ray.target_position.bounce(normal)
			ray.force_raycast_update()
			
			prev.set_collision_mask_value(5,true)
			prev.set_collision_mask_value(4,true)
			prev.set_collision_layer_value(5,true)
			prev.set_collision_layer_value(4,true)
