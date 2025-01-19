extends Control

@onready var chapter_1: TextureButton = %Chapter1
@onready var arrow: Sprite2D = %Arrow
@onready var total_stars: Label = %TotalStars
@onready var chapter_2_stars: Label = %Chapter2Stars
@onready var chapter_2_icon: Sprite2D = %Chapter2Icon
@onready var chapter_2_label: Label = %Chapter2Label

@onready var back: TextureRect = %Back

@onready var chpater_3: Control = %Chpater3
@onready var chapter_2: Control = %Chapter2

@onready var chapter_3_stars: Label = %Chapter3Stars
@onready var chapter_3_icon: Sprite2D = %Chapter3Icon
@onready var chapter_3_label: Label = %Chapter3Label




var option_position: Array = []
var current_option: int = 2
var chapter_2_unlocked: bool = false

func _ready() -> void:
	SaveSystem.load_data()
	
	chapter_2_stars.text = str(SaveSystem.get_total_stars()) + chapter_2_stars.text
	
	chapter_3_stars.text = str(SaveSystem.get_total_stars()) + chapter_3_stars.text

	option_position = [
		back,
		chapter_1,
		chapter_2,
		chpater_3
	]
	
	total_stars.text = total_stars.text + str(SaveSystem.get_total_stars()) + "*"
	
	if GameManager.chapter_2_unlocked == true:
		chapter_2_stars.hide()
		chapter_2_icon.set_modulate(Color(1,1,1,1))
		chapter_2_label.set_modulate(Color(1,1,1,1))
		
	if GameManager.chapter_3_unlocked:
		chapter_3_stars.hide()
		chapter_3_icon.set_modulate(Color(1,1,1,1))
		chapter_3_label.set_modulate(Color(1,1,1,1))
	
	update_option_position()

func change_lvl() -> void:
	if Input.is_action_just_pressed("select"):
		if current_option == 1:
			GameManager.change_scene("res://assets/Scenes/main_menu.tscn")
		elif current_option == 2:
			GameManager.change_scene("res://assets/Scenes/chapters/chapter_1.tscn")
		elif current_option == 3:
			if GameManager.chapter_2_unlocked:
				GameManager.change_scene("res://assets/Scenes/chapters/chapter_2.tscn")
		elif current_option == 4:
			if GameManager.chapter_3_unlocked:
				GameManager.change_scene("res://assets/Scenes/chapters/chapter_3.tscn")
			

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
		if next_option == 3 and not GameManager.chapter_2_unlocked:
			continue
		if next_option == 4 and not GameManager.chapter_3_unlocked:
			continue
		current_option = next_option
		break
	update_option_position()


func update_option_position() -> void:
	var target_position = option_position[current_option - 1].position
	var target_size = option_position[current_option - 1].size / 2
	arrow.position = Vector2(target_position.x + target_size.x, target_position.y - 25)
