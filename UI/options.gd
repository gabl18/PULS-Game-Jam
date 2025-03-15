extends Control

@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var options: Control = $"."

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(music_bus_id, value < .05)


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_id, linear_to_db(value))
	AudioServer.set_bus_mute(sfx_bus_id, value < .05)



func _on_back_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		get_tree().change_scene_to_file('res://UI/menu.tscn')

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		options.visible = !options.visible
