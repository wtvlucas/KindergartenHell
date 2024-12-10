extends Node2D

@onready var timer_bar: TextureProgressBar = $Hud/Timer
@onready var timer: Timer = %Timer
@onready var level_complete: Control = $Hud/LevelComplete
@onready var _1_star: TextureRect = $"Hud/LevelComplete/Stars/1star"
@onready var _2_star: TextureRect = $"Hud/LevelComplete/Stars/2star"
@onready var _3_star: TextureRect = $"Hud/LevelComplete/Stars/3star"
@onready var next_level_button: Button = $Hud/LevelComplete/NextLevelButton


var saved = 0
var stars = 0

func _ready() -> void:
	_1_star.hide()
	_2_star.hide()
	_3_star.hide()
	level_complete.hide()
	#SaveSystem.set_stars_for_level("level2", stars)


func _process(delta: float) -> void:
	timer_bar.value = timer.time_left
	prints("total:",SaveSystem.get_total_stars(), "| level1:", SaveSystem.get_stars_for_level("level1"), "| level2:",SaveSystem.get_stars_for_level("level2"), "| level3: ",SaveSystem.get_stars_for_level("level3"), "| saved:", saved, "| stars:", stars)
			
	
		
	if saved == 4:
		timer.set_paused(true)
		if timer.time_left > 40:
			stars = 3
		elif timer.time_left > 20:
			stars = 2
		elif timer.time_left > 0:
			stars = 1
		else:
			stars = 0
		
		if stars == 3:
			_1_star.show()
			_2_star.show()
			_3_star.show()
		elif stars == 2:
			_1_star.show()
			_2_star.show()
		elif stars == 1:
			_1_star.show()
			
		level_complete.show()
		
		if SaveSystem.get_stars_for_level("level2") < stars:
			SaveSystem.set_stars_for_level("level2", stars)
		


func _on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/Levels/level_3.tscn")
