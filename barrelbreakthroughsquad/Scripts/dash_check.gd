extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $oneway/CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var player

@onready var dooropen: AudioStreamPlayer = $dooropen
@onready var doorclose: AudioStreamPlayer = $doorclose

var open: bool = false
var rng: RandomNumberGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	rng = RandomNumberGenerator.new()

func _process(_delta: float) -> void:
	if player != null and player.dashing and not open:
		collision_shape_2d.one_way_collision = true
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
		if animated_sprite_2d.animation == "open":
			collision_shape_2d.set_deferred("one_way_collision", false)
			if dooropen.is_playing():
				dooropen.finished.connect(_close_door)
			else:
				animated_sprite_2d.play("closed")
				doorclose.pitch_scale = rng.randf_range(0.9, 1.1)
				doorclose.play()
				open = false
		if body.global_position.x > animated_sprite_2d.global_position.x:
			SignalBus.exited_spawn.emit()

func _close_door():
	animated_sprite_2d.play("closed")
	doorclose.pitch_scale = rng.randf_range(0.9, 1.1)
	doorclose.play()
	dooropen.finished.disconnect(_close_door)
	open = false
