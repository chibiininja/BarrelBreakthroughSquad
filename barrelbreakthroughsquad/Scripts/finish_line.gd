extends Area2D

var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		SignalBus.finish_game.emit()

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		if body.global_position.x > global_position.x:
			SignalBus.exited_gun.emit()
