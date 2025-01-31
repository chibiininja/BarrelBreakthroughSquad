extends Label

var enabled: bool = false
var start: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	SignalBus.finish_game.connect(end_timer)
	SignalBus.play_again.connect(hide_timer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not enabled:
		return
	var time: int = Time.get_ticks_msec() - start
	@warning_ignore("integer_division")
	text = str((time / 60000)) + ":" + ("%02d" % ((time / 1000) % 60)) + ":" + str((time % 1000) / 10)


func start_timer():
	enabled = true
	visible = true
	start = Time.get_ticks_msec()


func end_timer():
	enabled = false


func hide_timer():
	visible = false
