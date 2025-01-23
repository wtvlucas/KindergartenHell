extends CanvasLayer


var failed = false
@onready var restart: TextureRect = %Restart
@onready var home: TextureRect = %Home
@onready var next_level: TextureRect = %NextLevel

@onready var arrow: Sprite2D = %Arrow


var positions: Array = []
var sprites : Array = []
var option : int = 3

 
func _ready() -> void:
	positions = [
		restart.position,
		home.position,
		next_level.position
	]
	
	sprites = [
		restart,
		home,
		next_level
	]
	
	if get_parent().current_level == "cp1_lvl15" or failed == true or get_parent().current_level == "cp2_lvl15":
		option = 2
		
	update_option_position()


func change_lvl() -> void:
	if Input.is_action_just_pressed("select"):
		if option == 1:
			get_tree().reload_current_scene()
			GameManager.endLevel = false
		elif option == 2:
			GameManager.change_scene("res://assets/Scenes/main_menu.tscn")
			Main.stream_paused = false
			Chapter1Music.stop()
			Chapter2Music.stop()
			Chapter3Music.stop()
			SaveSystem.data.last_level = GameManager.current_level
			SaveSystem.save_data()
			GameManager.endLevel = false
		elif option == 3:
			if get_parent().current_level == "cp1_lvl15":
				if GameManager.chapter_2_unlocked:
					GameManager.change_scene("res://assets/Scenes/Levels/cp2_lvl1.tscn")
					
					Chapter1Music.stop()
					Chapter2Music.play()
			elif get_parent().current_level == "cp2_lvl15":
				if GameManager.chapter_3_unlocked:
					GameManager.change_scene("res://assets/Scenes/Levels/cp3_lvl1.tscn")
					
					Chapter1Music.stop()
					Chapter2Music.play()
			elif failed:
				return
			else:
				get_parent().next()
				
			GameManager.endLevel = false
		

func _process(delta: float) -> void:
	#print(failed)
	if (!GameManager.chapter_2_unlocked and get_parent().current_level == "cp1_lvl15"):
		next_level.set_modulate(Color(0.8, 0.8, 0.8, 0.8))
	elif (!GameManager.chapter_3_unlocked and get_parent().current_level == "cp2_lvl15"):
		next_level.set_modulate(Color(0.8, 0.8, 0.8, 0.8))
	elif failed:
		next_level.set_modulate(Color(0.8, 0.8, 0.8, 0.8))
	if !GameManager.endLevel:
		return
	change_lvl()
	#print(option)
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("up"):
		move_character(-1)
	elif Input.is_action_just_pressed("right") or Input.is_action_just_pressed("down"):
		move_character(1)
		
	


func move_character(direction: int) -> void:
	if GameManager.current_level == "cp1_lvl15" or failed:
		var next_option = option + direction
		if next_option >= 1 and next_option <= positions.size():
			if next_option == 3 and (!GameManager.chapter_2_unlocked or failed):
				return 
			option = next_option
	elif GameManager.current_level == "cp2_lvl15":
		var next_option = option + direction
		if next_option >= 1 and next_option <= positions.size():
			if next_option == 3 and (!GameManager.chapter_3_unlocked):
				return 
			option = next_option
	else:
		option = clamp(option + direction, 1, positions.size())
	
	update_option_position()



func update_option_position() -> void:
	arrow.position = Vector2(positions[option - 1].x + sprites[option - 1].get_size().x / 2, positions[option - 1].y + 130)
