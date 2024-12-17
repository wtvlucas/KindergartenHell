extends CanvasLayer

var open = false
@onready var restart: TextureRect = %Restart
@onready var home: TextureRect = %Home
@onready var next_level: TextureRect = %NextLevel

@onready var arrow: Sprite2D = %Arrow


var positions: Array = []
var option : int = 3

 
func _ready() -> void:
	positions = [
		restart.position,
		home.position,
		next_level.position
	]
	
	
	#update_option_position()
	
	if get_parent().current_level == "cp1_lvl5":
		option = 2
		
	update_option_position()


func change_lvl() -> void:
	if Input.is_action_just_pressed("select"):
		if option == 1:
			get_tree().reload_current_scene()
			#self.hide()
		elif option == 2:
			get_tree().change_scene_to_file("res://assets/Scenes/main_menu.tscn")
			SaveSystem.data.last_level = GameManager.current_level
			SaveSystem.save_data()
		elif option == 3:
			if get_parent().current_level == "cp1_lvl5":
				if GameManager.chapter_2_unlocked:
					get_tree().change_scene_to_file("res://assets/Scenes/chapters/chapter_2.tscn")
				else:
					print("Chapter 2 está bloqueado!")
			else:
				get_parent().next()
		

func _process(delta: float) -> void:
	if !GameManager.chapter_2_unlocked and get_parent().current_level == "cp1_lvl5":
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
	if GameManager.current_level == "cp1_lvl5":
		var next_option = option + direction
		if next_option >= 1 and next_option <= positions.size():
			if next_option == 3 and not GameManager.chapter_2_unlocked:
				return  # Não permite mover para a opção 3 se bloqueado
			option = next_option
	else:
		option = clamp(option + direction, 1, positions.size())
	
	update_option_position()



func update_option_position() -> void:
	arrow.position = Vector2(positions[option - 1].x + 85, positions[option - 1].y + 130)
