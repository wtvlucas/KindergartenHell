extends AudioStreamPlayer2D

@export var sounds: Array[AudioStream] = [] 



func play_random(from_position: float = 0.0) -> void:
	if sounds.is_empty():
		return
	
	stream = sounds[randi() % sounds.size()]
	self.stream = stream 
	

	play(from_position)
