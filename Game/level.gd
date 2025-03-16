extends Node2D
class_name Level

signal finished_level

@export var crack: int
@export var cutscene: bool= false

var wait_timer: Timer

func _process(_delta: float) -> void:
	
	if get_tree().get_nodes_in_group('Lights').all(func(x): return x.on):

		if wait_timer == null:
			
			wait_timer = Timer.new()
			wait_timer.wait_time = 2
			add_child(wait_timer)
			wait_timer.start()
			wait_timer.timeout.connect(_finished)
	else:

		if wait_timer != null:
			wait_timer.stop()
			wait_timer = null
			print('stop')
	
		
func _finished():
	finished_level.emit()
