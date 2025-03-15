extends Control

@export var credits: Control
@export var options: Control

var menu_visible = false

func _input(event):
	if event.is_action_pressed("Pause_Menu"):
		if menu_visible:
			hide_menu()
		else:
			show_menu()
	elif event.is_action_pressed("Back_Menu"):
		show_menu()

func hide_menu():
	menu_visible = false
	visible = false
	credits.visible = false
	options.visible = false

func show_menu():
	menu_visible = true
	visible = true
	credits.visible = false
	options.visible = false
	
func show_credits():
	visible = false
	credits.visible = true
	options.visible = false
	credits.reset_credits()
	
func show_options():
	visible = false
	credits.visible = false
	options.visible = true

func _on_continue_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		hide_menu()

func _on_options_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		show_options()

func _on_credits_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		show_credits()
 
func _on_back_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		show_menu()
