extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var open: AudioStreamPlayer = $open
@onready var close: AudioStreamPlayer = $close
var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	rng = RandomNumberGenerator.new()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		animated_sprite_2d.play("open")
		collision_shape_2d.position = Vector2(7.5, 7.5)
		open.pitch_scale = rng.randf_range(0.9, 1.1)
		open.play()

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		animated_sprite_2d.play("close")
		collision_shape_2d.position = Vector2(7.5, -7.5)
		close.pitch_scale = rng.randf_range(0.9, 1.1)
		close.play()
