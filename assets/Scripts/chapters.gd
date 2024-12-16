extends Control

@onready var chapter_1: TextureButton = %Chapter1
@onready var chapter_2: TextureButton = %Chapter2
@onready var arrow: Sprite2D = %Arrow
@onready var back: TextureButton = %BackButton
@onready var total_stars: Label = %TotalStars
@onready var chapter_2_stars: Label = %Chapter2Stars
@onready var chapter_2_icon: Sprite2D = %Chapter2Icon
@onready var chapter_2_label: Label = %Chapter2Label




var option_position: Array = []
var current_option: int = 2
var chapter_2_unlocked: bool = false

func _ready() -> void:
	SaveSystem.load_data()

	option_position = [
		back.position,
		chapter_1.position,
		chapter_2.position
	]
	
	total_stars.text = total_stars.text + str(SaveSystem.get_total_stars()) + "*"
	
	if SaveSystem.get_total_stars() >= 10:
		chapter_2_unlocked = true
		chapter_2_stars.hide()
		chapter_2_icon.set_modulate(Color(1,1,1,1))
		chapter_2_label.set_modulate(Color(1,1,1,1))
	
	update_option_position()

func change_lvl() -> void:
	if Input.is_action_just_pressed("select"):
		if current_option == 1:
			get_tree().change_scene_to_file("res://assets/Scenes/main_menu.tscn")
		elif current_option == 2:
			get_tree().change_scene_to_file("res://assets/Scenes/chapters/chapter_1.tscn")
		elif current_option == 3:
			if chapter_2_unlocked:
				get_tree().change_scene_to_file("res://assets/Scenes/chapters/chapter_2.tscn")
			else:
				print("Chapter 2 está bloqueado!")

func _process(delta: float) -> void:
	change_lvl()
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("up"):
		move_character(-1)
	elif Input.is_action_just_pressed("right") or Input.is_action_just_pressed("down"):
		move_character(1)

func move_character(direction: int) -> void:
	var next_option = current_option
	while true:
		next_option += direction
		if next_option < 1 or next_option > option_position.size():
			break
		if next_option == 3 and not chapter_2_unlocked:
			continue
		current_option = next_option
		break
	update_option_position()

func update_option_position() -> void:
	arrow.position = Vector2(option_position[current_option - 1].x + 5, option_position[current_option - 1].y - 15)
