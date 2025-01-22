extends Control


@onready var slider: HSlider = %Slider

var bus_index: int

func _ready() -> void:
	slider.value = SaveSystem.data.volume
	self.hide()
	bus_index = AudioServer.get_bus_index("Master")
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, slider.value)
	#SaveSystem.data.volume = slider.value
	if !get_parent().in_volume:
		return

	if Input.is_action_just_pressed("left"):
		slider.value -= 1
		SaveSystem.save_data()
		SaveSystem.data.volume = slider.value
	elif Input.is_action_just_pressed("right"):
		slider.value += 1
		SaveSystem.save_data()
		SaveSystem.data.volume = slider.value
		
	if Input.is_action_just_pressed("pause"):
		get_parent().in_volume = false
		self.hide()
		
		
	
