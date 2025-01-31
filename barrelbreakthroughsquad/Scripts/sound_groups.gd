extends Node

const FOOTSTEPS: Array[AudioStreamWAV] = [preload("res://Assets/Sound/bullet-casings-1.wav"),\
										preload("res://Assets/Sound/bullet-casings-2.wav"),\
										preload("res://Assets/Sound/bullet-casings-3.wav"),\
										preload("res://Assets/Sound/bullet-casings-4.wav"),\
										preload("res://Assets/Sound/bullet-casings-5.wav"),\
										preload("res://Assets/Sound/bullet-casings-6.wav"),\
										preload("res://Assets/Sound/bullet-casings-7.wav"),\
										preload("res://Assets/Sound/bullet-casings-8.wav"),\
										preload("res://Assets/Sound/bullet-casings-9.wav"),\
										preload("res://Assets/Sound/bullet-casings-10.wav")]

const RELOAD: Array[AudioStreamWAV] = [preload("res://Assets/Sound/reload1.wav"), \
										preload("res://Assets/Sound/reload2.wav"), \
										preload("res://Assets/Sound/reload3.wav"), \
										preload("res://Assets/Sound/reload4.wav"), \
										preload("res://Assets/Sound/reload5.wav"), \
										preload("res://Assets/Sound/reload6.wav"), \
										preload("res://Assets/Sound/reload7.wav"), \
										preload("res://Assets/Sound/reload8.wav")]

var sliding_door_close: AudioStreamPlayer
var sliding_door_open: AudioStreamPlayer

func _ready() -> void:
	sliding_door_close = AudioStreamPlayer.new()
	sliding_door_close.volume_db = -5
	sliding_door_close.stream = preload("res://Assets/Sound/slidingdoor_close.wav")
	get_tree().current_scene.add_child(sliding_door_close)
	sliding_door_open = AudioStreamPlayer.new()
	sliding_door_open.volume_db = -5
	sliding_door_open.stream = preload("res://Assets/Sound/slidingdoor_open.wav")
	get_tree().current_scene.add_child(sliding_door_open)
