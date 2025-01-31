extends Camera2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	SignalBus.exited_gun.connect(_reset_limits)
	SignalBus.play_again.connect(_play_again)

func set_limits():
	limit_left = -1490
	limit_top = -180
	limit_right = 4585
	limit_bottom = 180
	offset = Vector2(0,0)
	anchor_mode = ANCHOR_MODE_DRAG_CENTER

func _reset_limits():
	set_as_top_level(true)
	position_smoothing_enabled = false
	global_position = Vector2(-1400, 65)
	limit_left = -10000000
	limit_top = -10000000
	limit_right = 10000000
	limit_bottom = 10000000
	offset = Vector2(-2975, -1350)
	zoom = Vector2(0.067, 0.067)
	anchor_mode = ANCHOR_MODE_FIXED_TOP_LEFT

func _play_again():
	set_as_top_level(false)
	position = Vector2(0, 15)
	set_deferred("position_smoothing_enabled", true)
