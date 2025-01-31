extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $FollowMesh/AnimatedSprite2D
@onready var footsteps: AudioStreamPlayer = $footsteps
@onready var jump: AudioStreamPlayer = $jump
@onready var dash: AudioStreamPlayer = $dash
@onready var land: AudioStreamPlayer = $land
@onready var running_smoke: CPUParticles2D = $FollowMesh/AnimatedSprite2D/RunningSmoke
@onready var jump_smoke: CPUParticles2D = $FollowMesh/AnimatedSprite2D/JumpSmoke
@onready var land_smoke: CPUParticles2D = $FollowMesh/AnimatedSprite2D/LandSmoke


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 600
const DASH_DURATION = 0.3
var can_dash: bool = true
var dashing: bool = false
var decelerate: bool = false
var dash_direction: Vector2
var timer: Timer

var active_areas: Array[MovementInfluence] = []
var external_influence: Vector2

var rng: RandomNumberGenerator

@warning_ignore("unused_signal")

func _ready() -> void:
	animated_sprite_2d.play(&"idle")
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_timeout)
	SignalBus.play_again.connect(_reset_position)
	rng = RandomNumberGenerator.new()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not dashing and can_dash:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			can_dash = false
			dashing = true
			decelerate = false
			var camera = get_viewport().get_camera_2d()
			dash_direction = (camera.get_global_mouse_position() - self.global_position).normalized()
			look_at(camera.get_global_mouse_position())
			rotate(PI/2)
			timer.start(DASH_DURATION)

func _physics_process(delta: float) -> void:	
	# handle dashing override
	if dashing:
		animated_sprite_2d.offset = Vector2(0,16)
		if not decelerate:
			dash.pitch_scale = rng.randf_range(0.8, 1.0)
			dash.play()
			animated_sprite_2d.play(&"dash")
			velocity = dash_direction * DASH_SPEED
			decelerate = true
			SignalBus.start_dashing.emit()
		else:
			velocity = lerp(dash_direction * 100, dash_direction * DASH_SPEED, timer.time_left / DASH_DURATION)
		move_and_slide()
		return
	else:
		animated_sprite_2d.offset = Vector2(0,0)
	
	# Add the gravity.
	if not is_on_floor():
		running_smoke.emitting = false
		var modifier = 1.0
		if Input.is_action_pressed("jump"):
			if velocity.y < -75:
				modifier = 1.4
			elif velocity.y < 75:
				modifier = 1.0
			else:
				modifier = 2.0
		else:
			modifier = 2.5
		velocity += get_gravity() * delta * modifier
		velocity.y = clampf(velocity.y, JUMP_VELOCITY, INF)

	# Handle jump.
	if is_on_floor():
		can_dash = true
		velocity.y = JUMP_VELOCITY if Input.is_action_just_pressed("jump") else 0.0
		if Input.is_action_just_pressed("jump"):
			jump.pitch_scale = rng.randf_range(1.1, 1.3)
			jump.play()
			jump_smoke.emitting = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x += direction * SPEED * 1/6
		velocity.x = clampf(velocity.x, -SPEED + external_influence.x, SPEED + external_influence.x)
		if direction > 0:
			animated_sprite_2d.flip_h = false
			running_smoke.position = Vector2(-10,13)
			running_smoke.direction = Vector2(-1,-0.25)
		else:
			animated_sprite_2d.flip_h = true
			running_smoke.position = Vector2(10,13)
			running_smoke.direction = Vector2(1,-0.25)
	else:
		velocity.x = move_toward(velocity.x, external_influence.x, SPEED * 1/3)

	# animations and sound effects
	if not is_on_floor():
		animated_sprite_2d.play(&"jump")
	else:
		if animated_sprite_2d.animation == "jump":
			land.pitch_scale = rng.randf_range(0.8, 1.0)
			land.play()
			land_smoke.emitting = true
		if direction:
			running_smoke.emitting = true
			animated_sprite_2d.play(&"run")
			if animated_sprite_2d.frame == 2 or animated_sprite_2d.frame == 5:
				footsteps.stream = SoundGroups.FOOTSTEPS[rng.randi_range(0,SoundGroups.FOOTSTEPS.size()-1)]
				footsteps.pitch_scale = rng.randf_range(0.8, 1.0)
				footsteps.play()
		else:
			running_smoke.emitting = false
			animated_sprite_2d.play(&"idle")
	
	
	
	_handle_influences()
	
	move_and_slide()


#region Treadmill
func _handle_influences():
	external_influence = Vector2.ZERO
	for area in active_areas:
		external_influence += area.modifier

func register_area(area: MovementInfluence):
	active_areas.push_back(area)

func unregister_area(area: MovementInfluence):
	var index = active_areas.find(area)
	if index != 1:
		active_areas.remove_at(index)
#endregion

func _timeout():
	if dashing:
		dashing = false
		rotation = 0
		SignalBus.stopped_dashing.emit()

#end of cutscene
func enable():
	process_mode = PROCESS_MODE_INHERIT

#play again
func _reset_position():
	position = Vector2(-1400, 50)
	process_mode = PROCESS_MODE_DISABLED
