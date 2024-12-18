extends Node2D

@onready var timer_bar: TextureProgressBar = $Hud/Timer
@onready var timer: Timer = %Timer
@onready var level_complete: Control = $Hud/LevelComplete
@onready var _1_star: TextureRect = $"Hud/LevelComplete/Stars/1star"
@onready var _2_star: TextureRect = $"Hud/LevelComplete/Stars/2star"
@onready var _3_star: TextureRect = $"Hud/LevelComplete/Stars/3star"
@onready var next_level_button: Button = $Hud/LevelComplete/NextLevelButton

@onready var moves: Label = $Hud/Hud/Calendar/Moves

@onready var star: TextureRect = $Hud/Hud/Stars/Star
@onready var star_2: TextureRect = $Hud/Hud/Stars/Star2
@onready var star_3: TextureRect = $Hud/Hud/Stars/Star3


var current_level = "cp1_lvl1"

var dicts : Dictionary = {
	max_moves = 20,
	need_to_save = 1,
	saved = 0,
	stars = 0,
	
	treestars = 13,
	twostars = 9,
	onestar = 5,
}

var last_stars: int = 0  

func _ready() -> void:
	_1_star.hide()
	_2_star.hide()
	_3_star.hide()
	level_complete.hide()
	GameManager.moves = dicts.max_moves
	GameManager.current_level = current_level
	GameManager.endLevel = false
	last_stars = dicts.stars

func _process(delta: float) -> void:
	moves.text = str(GameManager.moves)
	
	GameManager.moves = clamp(GameManager.moves, 0, dicts.max_moves)  
	show_end()
	
	if GameManager.moves > dicts.treestars:
		dicts.stars = 3
	elif GameManager.moves > dicts.twostars:
		dicts.stars = 2
	elif GameManager.moves > dicts.onestar:
		dicts.stars = 1
	else:
		dicts.stars = 0 
		
	
	if dicts.stars < last_stars:
		LooseStar.play() 
	last_stars = dicts.stars  
		
	star.visible = dicts.stars >= 1
	star_2.visible = dicts.stars >= 2
	star_3.visible = dicts.stars >= 3


func next():
	var next = "cp1_lvl2"
	get_tree().change_scene_to_file("res://assets/Scenes/Levels/" + next + ".tscn")

func show_end() -> void:
	if dicts.saved == dicts.need_to_save:
		GameManager.endLevel = true
			
		if SaveSystem.get_stars_for_level(current_level) < dicts.stars:
			SaveSystem.set_stars_for_level(current_level, dicts.stars)
		
		#if total_stars < 10:
			#next_level_button.disabled = true
			#no_stars_label.show()
			#no_stars_label.text = "You only have " + str(total_stars) + "/7 stars to get into 2nd chapter!"
			
		_1_star.visible = dicts.stars >= 1
		_2_star.visible = dicts.stars >= 2
		_3_star.visible = dicts.stars >= 3
			
		level_complete.show()
		


func _on_next_level_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/Levels/cp1_lvl2.tscn")
