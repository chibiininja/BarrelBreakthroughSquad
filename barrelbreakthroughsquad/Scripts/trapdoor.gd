extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var player

@onready var dooropen: AudioStreamPlayer = $dooropen
@onready var doorclose: AudioStreamPlayer = $doorclose

var open: bool = false
var rng: RandomNumberGenerator
var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	rng = RandomNumberGenerator.new()
	timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_close_door)

func _process(_delta: float) -> void:
	if player != null and player.dashing:
		collision_shape_2d.disabled = true
		if not open:
			animated_sprite_2d.play("open")
			dooropen.pitch_scale = rng.randf_range(0.9, 1.1)
			dooropen.play()
			open = true

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		player = body

func _on_body_exited(body: Node2D):
	if body.is_in_group("player"):
		player = null
		if open:
			timer.start(2)

func _close_door():
	collision_shape_2d.set_deferred("disabled", false)
	animated_sprite_2d.play("close")
	doorclose.pitch_scale = rng.randf_range(0.9, 1.1)
	doorclose.play()
	open = false
