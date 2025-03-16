extends Control
@onready var level_container: Node2D = %Level_Container
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var crack_texture: TextureRect = $CrackTexture
@onready var notification_container: Control = $Notification_Container

const NOTIFICATION = preload("res://UI/notification.tscn")

@export var levels : Array[PackedScene]
@export var cracks: Array[Texture2D]

var notification_instance: Notification
var level_instance: Level

func _ready() -> void:
	play_level(0)
	music_player.volume_db = linear_to_db(0.5)
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, false)
	AudioServer.set_bus_effect_enabled(music_bus_id, 2, false)
	
func play_level(index:int):
	
	#### GAMETIME
	load_level(levels[index])
	
	if level_instance.crack == -1:
		crack_texture.hide()
	else:
		crack_texture.show()
		crack_texture.texture = cracks[level_instance.crack]
	
	
	await level_instance.finished_level

	#### NOTIFICATION
	notification_instance = NOTIFICATION.instantiate()
	notification_container.add_child(notification_instance)
	notification_instance.global_position = Vector2(1198.0,358.0)
	
	await notification_instance._continue
	
	notification_instance.queue_free()
	
	#####SCREEN ZAPING
	# the code is here when the screen should zap 
	# so start the zapping animation here
	# e.g. animation_player.play('zap')
	
	#await animation_player.animation_finished
	
	#### Cut Scene
	# The Levels have a property "Cut Scene", this should be true when a cutscene (the punching one) should be played
	if level_instance.cutscene:
		pass
		# cutscene start here
		# e.g. animation_player.play('cutscene')
		
		#await animation_player.animation_finished
		
		##### SCREEN ZAPPING
		# after the animation it should zap again
		
	
	#####NEXT LEVEL
	play_level(index + 1)
	
func load_level(level:PackedScene):
	unload_level()
	level_instance = level.instantiate()

	level_container.add_child(level_instance)
	
func unload_level():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
