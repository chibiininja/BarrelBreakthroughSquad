extends Node2D

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var id: int

var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.choose_path.connect(_close_door)
	SignalBus.play_again.connect(_reset)
	rng = RandomNumberGenerator.new()

func _close_door(_id: int):
	if _id != id:
		collision_shape_2d.set_deferred("disabled", false)
		animated_sprite_2d.play("close")

func _reset():
	collision_shape_2d.disabled = true
	animated_sprite_2d.play("open")
