extends Control
class_name CreditsBox

@export var title_color := Color.BLUE_VIOLET
@export var text_color := Color.WHITE
@export var title_font : FontFile = null
@export var text_font : FontFile = null
@export var title_size: int
@export var text_size: int

@export var section_time := 2.0
@export var line_time := 0.3
@export var base_speed := 70
@export var speed_up_multiplier := 10.0

var scroll_speed : float = base_speed
var speed_up := false

@onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"Laser Game"
	],[
		"Programming",
		"Michael",
		"Gabriel"
	],[
		"Art",
		"Gabriel",
		"Michael"
	],[
		"Music",
		"https://tallbeard.itch.io/music-loop-bundle"
	],[
		"Testers",
		"Felix",
		"Noah",
		"Melanie"
	],[
		"Sound Effects",
		"https://pixabay.com/sound-effects/punch-4-84743/",
		"https://pixabay.com/sound-effects/punch-4-84743/",
		"https://pixabay.com/sound-effects/tv-television-on-off-6224/",
		"https://pixabay.com/sound-effects/heavy-beam-weapon-7052/",
		"https://pixabay.com/sound-effects/wood-crack-4-88688/",
		"https://pixabay.com/sound-effects/windows-error-sound-effect-35894/",
		"https://pixabay.com/sound-effects/pc-startup-with-broken-hdd-2-25314/",
		"https://pixabay.com/sound-effects/notification-2-269292/",
		"https://pixabay.com/sound-effects/tv-off-91795/",
		"https://pixabay.com/sound-effects/old-pc-monitor-switch-off-8575/",
		"https://beepyeah.itch.io/8-bit-sfx-pack"
	],[
		"Tools used",
		"Godot Engine",
		"https://godotengine.org/license",
		"",
		"Aseprite",
		"https://www.aseprite.org/"
	],[
		"Font",
		"https://rugikong.itch.io/montjuic"
	],[
		"Tutorials",
		"https://www.youtube.com/watch?v=Mgk5eAvzo8k",
		"https://www.youtube.com/watch?v=Mgk5eAvzo8k"
	],[
		"Made for PULS GAME JAM",
		"https://itch.io/jam/puls-game-jam"
	],[
		"",
		"",
		"THANKS FOR PLAYING"
	]
]



func _process(delta):
	scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.set_global_position(l.get_global_position() - Vector2(0, scroll_speed))
			if l.get_global_position().y < l.get_line_height():
				lines.erase(l)
				l.queue_free()


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		if title_font != null:
			new_line.set("theme_override_fonts/font", title_font)
		new_line.set("theme_override_colors/font_color", title_color)
		if title_size != null:
			new_line.set("theme_override_font_sizes/font_size", title_size)
	
	else:
		if text_font != null:
			new_line.set("theme_override_fonts/font", text_font)
		new_line.set("theme_override_colors/font_color", text_color)
		if text_size != null:
			new_line.set("theme_override_font_sizes/font_size", text_size)
	
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _input(event):

	if event.is_action_pressed("Credits_Speed_Up"):
		speed_up = true
	
	if event.is_action_released("Credits_Speed_Up"):
		speed_up = false
