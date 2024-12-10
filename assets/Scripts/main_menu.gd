extends Control

@onready var stars_container_lvl_1: HBoxContainer = %StarsContainerLvl1
@onready var stars_container_lvl_2: HBoxContainer = %StarsContainerLvl2
@onready var stars_container_lvl_3: HBoxContainer = %StarsContainerLvl3
@onready var character_sprite: Sprite2D = %Sprite2D
@onready var level_1_button: TextureButton = %Level1Button
@onready var level_2_button: TextureButton = %Level2Button
@onready var level_3_button: TextureButton = %Level3Button



var current_level: int = 1 
var levels_positions: Array = []

func update_menu_stars():
	set_stars_visibility(stars_container_lvl_1, SaveSystem.get_stars_for_level("level1"))
	set_stars_visibility(stars_container_lvl_2, SaveSystem.get_stars_for_level("level2"))
	set_stars_visibility(stars_container_lvl_3, SaveSystem.get_stars_for_level("level3"))

func set_stars_visibility(container: HBoxContainer, star_count: int):
	for i in range(container.get_children().size()):
		container.get_child(i).visible = i < star_count


func change_lvl() -> void:
	if Input.is_key_pressed(KEY_SPACE):
		get_tree().change_scene_to_file("res://assets/Scenes/Levels/level_" + str(current_level) + ".tscn")
		 
func _ready() -> void:
	#SaveSystem.reset_stars()
	SaveSystem.load_data()
	update_menu_stars()
	

	levels_positions = [
		level_1_button.position,
		level_2_button.position,
		level_3_button.position
	]
	
	
	update_character_position()


func _process(delta: float) -> void:
	change_lvl()
	if Input.is_action_just_pressed("left"):
		move_character(-1)
		
	elif Input.is_action_just_pressed("right"):
		
		move_character(1)

func move_character(direction: int) -> void:
	current_level = clamp(current_level + direction, 1, levels_positions.size())
	
	update_character_position()

func update_character_position() -> void:
	character_sprite.position = Vector2(levels_positions[current_level - 1].x + 20, levels_positions[current_level - 1].y - 60)

func _on_level_1_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/Levels/level_1.tscn")

func _on_level_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/Levels/level_2.tscn")

func _on_level_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/Scenes/Levels/level_3.tscn")
