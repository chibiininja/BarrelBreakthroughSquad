class_name MovementInfluence
extends Area2D

@export var modifier: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		body.register_area(self)

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		body.unregister_area(self)
