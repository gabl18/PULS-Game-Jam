extends Control
@onready var level_container: Node2D = %Level_Container
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer
@onready var music_bus_id = AudioServer.get_bus_index("Music")
@onready var sfx_bus_id = AudioServer.get_bus_index("SFX")
@onready var crack_texture: TextureRect = $CrackTexture
@onready var notification_container: Control = $Notification_Container
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var monitor_transition: TextureRect = $Monitor_Transition
@onready var cutscene_container: Control = $Cutscene_Container
@onready var crack_player: AudioStreamPlayer = $CrackPlayer

const NOTIFICATION = preload("res://UI/notification.tscn")
const CUTSCENE_1 = preload("res://UI/cutscene1.tscn")

@export var levels : Array[PackedScene]
@export var cracks: Array[Texture2D]

var notification_instance: Notification
var level_instance: Level
var cutscene_instance: Cutscene


func play_sfx(sound_path: String):
	sfx_player.stream = load(sound_path)
	sfx_player.play()
	
	#sfx_player.connect("finished", sfx_player.queue_free)  # Löscht sich nach Abspielen selbst
	
func _ready() -> void:
	AudioServer.set_bus_volume_db(music_bus_id, linear_to_db(0.05))
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, true)
	AudioServer.set_bus_effect_enabled(music_bus_id, 2, true)
	await play_transition_off()
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, false)
	AudioServer.set_bus_effect_enabled(music_bus_id, 2, false)
	play_level(0)
	
func play_transition_off():
	monitor_transition.visible = true
	animation_player.play('monitor_zap')
	play_sfx("res://assets/Audio/Sfx/old_off.ogg")
	await animation_player.animation_finished
	monitor_transition.visible = false

func play_transition_on():
	monitor_transition.visible = true
	animation_player.play('monitor_zap_start')
	play_sfx("res://assets/Audio/Sfx/on_off.ogg")
	await animation_player.animation_finished
	monitor_transition.visible = false
	

func play_level(index:int):
	
	#### GAMETIME
	load_level(levels[index])
	
	if level_instance.crack == -1:
		crack_texture.hide()
	else:
		crack_texture.show()
		crack_texture.texture = cracks[level_instance.crack]
		crack_player.play()
		
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
	
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, true)
	AudioServer.set_bus_effect_enabled(music_bus_id, 2, true)
	if level_instance.cutscene:
		await play_transition_off()
	else: 
		await play_transition_off()
		play_transition_on()
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, false)
	AudioServer.set_bus_effect_enabled(music_bus_id, 2, false)
	
	#### Cut Scene
	# The Levels have a property "Cut Scene", this should be true when a cutscene (the punching one) should be played
	if level_instance.cutscene:
		cutscene_instance = CUTSCENE_1.instantiate()
		cutscene_container.add_child(cutscene_instance)

		await cutscene_instance._continue
		cutscene_instance.queue_free()
		await play_sfx("res://assets/Audio/Sfx/error.ogg")
		
		play_transition_on()
	
	#####NEXT LEVEL
	play_level(index + 1)
	
func load_level(level:PackedScene):
	unload_level()
	level_instance = level.instantiate()

	level_container.add_child(level_instance)
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, true)
	AudioServer.set_bus_effect_enabled(music_bus_id, 2, true)
	monitor_transition.visible = true
	animation_player.play('monitor_zap_start')
	play_sfx("res://assets/Audio/Sfx/on_off.ogg")
	await animation_player.animation_finished
	await sfx_player.finished
	monitor_transition.visible = false
	AudioServer.set_bus_effect_enabled(music_bus_id, 1, false)
	AudioServer.set_bus_effect_enabled(music_bus_id, 2, false)
	
func unload_level():
	if (is_instance_valid(level_instance)):
		level_instance.queue_free()
