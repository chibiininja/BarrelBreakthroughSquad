extends TextureButton

@onready var reload: AudioStreamPlayer = $reload
@onready var gunshot: AudioStreamPlayer = $gunshot
var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_hovered)
	button_up.connect(_pressed)
	rng = RandomNumberGenerator.new()

func _hovered():
	reload.pitch_scale = rng.randf_range(0.9, 1.1)
	reload.stream = SoundGroups.RELOAD[rng.randi_range(0, SoundGroups.RELOAD.size()-1)]
	reload.play()

func _pressed():
	SignalBus.start_game.emit()
	visible = false
	gunshot.pitch_scale = rng.randf_range(0.9, 1.1)
	gunshot.play()
