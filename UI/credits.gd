extends Control
@onready var credits: Control = $"."


func _on_back_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_tree().change_scene_to_file('res://UI/menu.tscn')

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		credits.visible = !credits.visible
