extends Control


func _on_start_button_gui_input(event: InputEvent) -> void:

	if event is InputEventMouseButton:
		print('start')

func _on_credits_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_tree().change_scene_to_file("res://UI/credits.tscn")


func _on_quit_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_tree().quit()
