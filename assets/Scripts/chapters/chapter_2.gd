extends Control

@onready var arrow: Sprite2D = %Arrow
@onready var level_buttons: Array = [
	%Level1, %Level2, %Level3, %Level4, %Level5,
	%Level6, %Level7, %Level8, %Level9, %Level10,
	%Level11, %Level12, %Level13, %Level14, %Level15
]
@onready var back_button: TextureButton = %BackButton

@onready var star_labels: Array = [
	%Level1/StarsLevel1, %Level2/StarsLevel2, %Level3/StarsLevel3, %Level4/StarsLevel4, %Level5/StarsLevel5,
	%Level6/StarsLevel6, %Level7/StarsLevel7, %Level8/StarsLevel8, %Level9/StarsLevel9, %Level10/StarsLevel10,
	%Level11/StarsLevel11, %Level12/StarsLevel12, %Level13/StarsLevel13, %Level14/StarsLevel14, %Level15/StarsLevel15
]

# Variáveis para a lógica de navegação
var num_columns = 5
var num_rows = 3
var current_level = Vector2(0, 0) # Inicia no botão de retorno (-1 indica posição especial)
var last_row = 0 # Armazena a última linha válida antes de ir para o botão de retorno

func _ready() -> void:
	SaveSystem.load_data()
	update_stars_text()
	update_arrow_position()

func update_stars_text():
	for i in range(star_labels.size()):
		var level_name = "cp2_lvl" + str(i + 1)
		star_labels[i].text = str(SaveSystem.get_stars_for_level(level_name)) + "/3 *"

func change_lvl() -> void:
	if Input.is_action_just_pressed("select"):
		if current_level == Vector2(-1, 0): # Botão de retorno
			GameManager.change_scene("res://assets/Scenes/chapters.tscn")
		else:
			var level_index = (current_level.y * num_columns) + current_level.x
			var level_path = "res://assets/Scenes/Levels/cp2_lvl" + str(level_index + 1) + ".tscn"
			Main.stream_paused = true
			Chapter1.play()
			GameManager.change_scene(level_path)

func _process(delta: float) -> void:
	change_lvl()

	if Input.is_action_just_pressed("left"):
		move_character(Vector2(-1, 0)) # Esquerda
	elif Input.is_action_just_pressed("right"):
		move_character(Vector2(1, 0)) # Direita
	elif Input.is_action_just_pressed("up"):
		move_character(Vector2(0, -1)) # Cima
	elif Input.is_action_just_pressed("down"):
		move_character(Vector2(0, 1)) # Baixo

func move_character(direction: Vector2) -> void:
	if current_level == Vector2(-1, 0): # Botão de retorno
		if direction == Vector2(1, 0): # Indo para a linha que estava
			current_level = Vector2(0, last_row)
	elif current_level.x == 0 and direction == Vector2(-1, 0): # Indo para o botão de retorno
		last_row = current_level.y # Salva a linha antes de ir para o botão de retorno
		current_level = Vector2(-1, 0)
	else:
		# Atualiza a posição lógica do nível
		var new_position = current_level + direction
		current_level.x = clamp(new_position.x, 0, num_columns - 1)
		current_level.y = clamp(new_position.y, 0, num_rows - 1)

		# Evita posições inválidas
		var level_index = int(current_level.y) * num_columns + int(current_level.x)
		if level_index >= level_buttons.size():
			current_level -= direction

	update_arrow_position()

func update_arrow_position() -> void:
	if current_level == Vector2(-1, 0): # Botão de retorno
		arrow.position = Vector2(back_button.position.x + back_button.size.x / 2, back_button.position.y - 25)
	else:
		var level_index = (current_level.y * num_columns) + current_level.x
		if level_index >= 0 and level_index < level_buttons.size():
			var target_position = level_buttons[level_index].position
			var target_size = level_buttons[level_index].size / 2
			arrow.position = Vector2(target_position.x + target_size.x, target_position.y - 25)
