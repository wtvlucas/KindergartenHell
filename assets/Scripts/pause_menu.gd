extends CanvasLayer

var open = false

func _ready() -> void:
	self.hide()
	open = false

func _process(delta: float) -> void:
	pass


func _on_home_pressed() -> void:
	
	get_tree().change_scene_to_file("res://assets/Scenes/main_menu.tscn")
	SaveSystem.data.last_level = GameManager.current_level
	self.hide()
	GameManager.paused = false
	GameManager.unpause()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()


func _on_back_pressed() -> void:
	self.hide()
	GameManager.paused = false
