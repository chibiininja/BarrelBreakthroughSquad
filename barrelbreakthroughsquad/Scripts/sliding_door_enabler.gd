extends Node2D

@onready var sliding_door_enabler: Area2D = $SlidingDoorEnabler
@onready var sliding_door_disabler: Area2D = $SlidingDoorDisabler
var enabler_emitted: bool = false
var disabler_emitted: bool = false

func _ready() -> void:
	sliding_door_enabler.body_entered.connect(_enable)
	sliding_door_disabler.body_entered.connect(_disable)
	SignalBus.play_again.connect(_reset)

func _reset():
	enabler_emitted = false
	disabler_emitted = false

func _enable(body: Node2D):
	if body.is_in_group("player") and not enabler_emitted:
		SignalBus.enable_sliding_doors.emit()
		enabler_emitted = true

func _disable(body: Node2D):
	if body.is_in_group("player") and not disabler_emitted:
		SignalBus.disable_sliding_doors.emit()
		disabler_emitted = true
