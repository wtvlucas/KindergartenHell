extends Control

@onready var play: TextureButton = %Play
@onready var chapters: TextureButton = %Chapters
@onready var exit: TextureButton = %Exit
@onready var arrow: Sprite2D = %Arrow



var option_position: Array = []
var current_option : int = 1

 
func _ready() -> void:
	#SaveSystem.reset_stars()
	SaveSystem.load_data()
#	InputManager.connect("input_received", _on_input_received)



	option_position = [
		play.position,
		chapters.position,
		exit.position
	]
	
	
	update_option_position()



func change_lvl() -> void:
	if Input.is_action_just_pressed("select"):
		
		if current_option == 1:
			var last_lvl = SaveSystem.data.last_level
			if last_lvl.begins_with("cp1"):
				Chapter1.play()
			elif last_lvl.begins_with("cp2"):
				Chapter2.play()
				
			Main.stream_paused = true
			get_tree().change_scene_to_file("res://assets/Scenes/Levels/" + last_lvl + ".tscn")
			
		elif current_option == 2:
			get_tree().change_scene_to_file("res://assets/Scenes/chapters.tscn")
			
		elif current_option == 3:
			SaveSystem.data.last_level = GameManager.current_level
			SaveSystem.save_data()
			get_tree().quit()
		

func _process(delta: float) -> void:
	change_lvl()
	#print(current_option)
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("up"):
		move_character(-1)
	elif Input.is_action_just_pressed("right") or Input.is_action_just_pressed("down"):
		move_character(1)


func move_character(direction: int) -> void:
	current_option = clamp(current_option + direction, 1, option_position.size())
	update_option_position()

func update_option_position() -> void:
	arrow.position = Vector2(option_position[current_option - 1].x - 25, option_position[current_option - 1].y + 30)
