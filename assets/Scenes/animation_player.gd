extends Control

var can_play = true
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !can_play or !animation_player.is_playing():
		return
	can_play = false
	Walk.play_random()
	await get_tree().create_timer(0.1).timeout
	can_play = true
