extends Area2D

@export var id: int
var used: bool = false
var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_body_entered)
	SignalBus.play_again.connect(_reset)
	rng = RandomNumberGenerator.new()

func _body_entered(body: Node2D):
	if body.is_in_group("player") and not used:
		SignalBus.choose_path.emit(id)
		SoundGroups.sliding_door_close.pitch_scale = rng.randf_range(0.9, 1.1)
		SoundGroups.sliding_door_close.play()
		used = true

func _reset():
	used = false
