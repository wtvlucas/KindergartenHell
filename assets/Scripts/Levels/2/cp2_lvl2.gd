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
@onready var completed_label: Label = $Hud/LevelComplete/CompletedLabel

var level = 2
var lvl_str = "cp2_lvl"
var current_level = lvl_str + str(level)

var dicts : Dictionary = {
	max_moves = 20,
	need_to_save = 2,
	saved = 0,
	stars = 0,
	
	treestars = 8,
	twostars = 4,
	onestar = 0,
}

var last_stars: int = 0  
var sound_played: bool = false

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
	var next = lvl_str + str(level + 1)
	print(next)
	get_tree().change_scene_to_file("res://assets/Scenes/Levels/" + next + ".tscn")
	GameManager.endLevel = false

func show_end() -> void:
	if dicts.saved == dicts.need_to_save:
		GameManager.endLevel = true
			
		if !sound_played:
			if dicts.stars == 0:
				Failed.play()
				sound_played = true
			else:
				Victory.play()
				sound_played = true
			
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
		
	elif GameManager.moves == 0:
		GameManager.endLevel = true
		completed_label.text = "Failed!\n You reached the maximum ammount of steps..."
		get_node("Hud").failed = true
		if !sound_played:
			Failed.play()
			sound_played = true
		level_complete.show()

		
