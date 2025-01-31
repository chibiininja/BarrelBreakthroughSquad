extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var opened: bool = false
var enabled: bool = false

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.start_dashing.connect(_flip_door)
	SignalBus.enable_sliding_doors.connect(_enable)
	SignalBus.disable_sliding_doors.connect(_reset)
	rng = RandomNumberGenerator.new()
	if opened:
		collision_shape_2d.set_deferred("disabled", true)
		animated_sprite_2d.play("open")
	else:
		collision_shape_2d.set_deferred("disabled", false)
		animated_sprite_2d.play("close")

func _enable():
	enabled = true

func _reset():
	enabled = false

func _flip_door():
	if not enabled:
		return
	if opened:
		SoundGroups.sliding_door_close.pitch_scale = rng.randf_range(0.9, 1.1)
		SoundGroups.sliding_door_close.play()
		collision_shape_2d.set_deferred("disabled", false)
		animated_sprite_2d.play("close")
	else:
		SoundGroups.sliding_door_open.pitch_scale = rng.randf_range(0.9, 1.1)
		SoundGroups.sliding_door_open.play()
		collision_shape_2d.set_deferred("disabled", true)
		animated_sprite_2d.play("open")
	opened = not opened
