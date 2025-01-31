extends HBoxContainer

@onready var h_slider: HSlider = $MarginContainer/HSlider
@onready var texture_button: TextureButton = $TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	h_slider.value_changed.connect(_on_value_changed)
	h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	texture_button.toggled.connect(_toggled)
	texture_button.button_pressed = AudioServer.is_bus_mute(0)


func _on_value_changed(value: float):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _toggled(toggled_on: bool):
	AudioServer.set_bus_mute(0, toggled_on)
