extends Control

@onready var credits_box: CreditsBox = $CreditsBox2

const creditsbox_res = preload("res://addons/CREDITS/GodotCredits.tscn")

func reset_credits():
	
	credits_box.queue_free()
	credits_box = creditsbox_res.instantiate()
	add_child(credits_box)
