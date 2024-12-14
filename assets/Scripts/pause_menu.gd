extends CanvasLayer

var open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.hide()
	open = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_home_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/main_menu.tscn")
	self.hide()
