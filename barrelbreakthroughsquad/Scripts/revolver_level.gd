extends Node2D

const FULLSCREEN_BULLET_CURSOR = preload("res://Assets/bullet_cursor_fullscreen.png")
const WINDOWED_BULLET_CURSOR = preload("res://Assets/bullet_cursor_windowed.png")
@onready var bullet_spawn_cover: Sprite2D = $BulletSpawnCover
@onready var revolver_exterior: Sprite2D = $RevolverExterior
@onready var canvas_layer: CanvasLayer = $CanvasLayer
var initial_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bullet_spawn_cover.visible = true
	revolver_exterior.visible = true
	canvas_layer.visible = true
	get_tree().root.size_changed.connect(_resized)
	initial_size = Vector2i(640, 360)
	_resized()

func _resized():
	if DisplayServer.window_get_size() <= initial_size:
		Input.set_custom_mouse_cursor(WINDOWED_BULLET_CURSOR)
	else:
		Input.set_custom_mouse_cursor(FULLSCREEN_BULLET_CURSOR)
