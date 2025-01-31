extends AnimationPlayer

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.start_game.connect(_start_cutscene)
	SignalBus.exited_spawn.connect(_cover_spawn)
	SignalBus.exited_gun.connect(_cover_gun)
	SignalBus.play_again.connect(skip_cutscene)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip") and is_playing() and current_animation == "revolver_beginning":
		stop()
		skip_cutscene()


func skip_cutscene():
	play("revolver_beginning", -1, 1.0, true)
	audio_stream_player.stop()


func _start_cutscene():
	play("revolver_beginning")
	audio_stream_player.play()
	audio_stream_player_2.play()


func _cover_spawn():
	play("cover_bullet")


func _cover_gun():
	play("cover_gun")
