extends Control

@onready var play: TextureButton = %Play
@onready var chapters: TextureButton = %Chapters
@onready var exit: TextureButton = %Exit
@onready var arrow: Sprite2D = %Arrow
@onready var settings_control: Control = %SettingsControl
@onready var settings: TextureButton = %Settings


var in_volume = false
var option_position: Array = []
var current_option : int = 1

 
func _ready() -> void:
	#SaveSystem.reset_stars()
	SaveSystem.load_data()
#	InputManager.connect("input_received", _on_input_received)



	option_position = [
		play,
		chapters,
		exit,
		settings
	]
	
	
	update_option_position()



func change_lvl() -> void:
	if Input.is_action_just_pressed("select"):
		
		if current_option == 1:
			if !SaveSystem.data.TutGreen:
				Main.stream_paused = true
				GameManager.change_scene("res://assets/Scenes/tutorial/green_tutorial.tscn")
			else:
				var last_lvl = SaveSystem.data.last_level
				if last_lvl.begins_with("cp1"):
					Chapter1Music.play()
				elif last_lvl.begins_with("cp2"):
					Chapter2Music.play()
				elif last_lvl.begins_with("cp3"):
					Chapter3Music.play()
					
				Main.stream_paused = true
				GameManager.change_scene("res://assets/Scenes/Levels/" + last_lvl + ".tscn")
			
		elif current_option == 2:
			GameManager.change_scene("res://assets/Scenes/chapters.tscn")
			
		elif current_option == 3:
			SaveSystem.data.last_level = GameManager.current_level
			SaveSystem.save_data()
			get_tree().quit()
			
		elif current_option == 4:
			settings_control.show()
			in_volume = true
		

func _process(delta: float) -> void:
	if in_volume:
		return
		
	change_lvl()
	#print(current_option)
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("up"):
		move_character(-1)
	elif Input.is_action_just_pressed("right") or Input.is_action_just_pressed("down"):
		move_character(1)
		
	#if Input.is_action_just_pressed("pause"):
		#settings_control.show()
		#in_volume = true


func move_character(direction: int) -> void:
	current_option = clamp(current_option + direction, 1, option_position.size())
	update_option_position()

func update_option_position() -> void:
	var pos = option_position[current_option - 1].position
	var sz = option_position[current_option - 1].size
	arrow.position = Vector2(pos.x - 15, pos.y + sz.y / 2)
