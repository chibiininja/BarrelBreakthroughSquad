extends Node2D

const PLATFORMS: Array[PackedScene] = [preload("res://Scenes/platform_1.tscn"), preload("res://Scenes/platform_2.tscn"),\
					preload("res://Scenes/platform_3.tscn"), preload("res://Scenes/platform_4.tscn")]
@onready var timer: Timer = $Timer
var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = RandomNumberGenerator.new()
	timer.timeout.connect(_timeout)


func _timeout():
	var platform = PLATFORMS[rng.randi_range(0,3)].instantiate()
	add_child(platform)
