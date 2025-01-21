extends Node2D

@onready var text_label: RichTextLabel = %TextLabel
@onready var timer: Timer = %Timer
@onready var player: Area2D = %Player
@onready var box: TextureRect = %Box
#@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_player: AnimationPlayer = $Tutorial/AnimationPlayer

@onready var space_key: Sprite2D = %SpaceKey
@onready var moves: Label = %Moves
@onready var seta_porta_tutorial: Sprite2D = %SetaPortaTutorial
@onready var calendar: TextureRect = %Calendar
@onready var stars: HBoxContainer = %Stars



var writing = false
var speed = 16
var finished = false
var movement_locked = true  
var show_key = false
var texts = [
	"Pressiona a tecla \t para seguir o diálogo.",
	"Olá professora Clara, bem-vinda ao Kindergarten Hell!",
	"Precisamos da tua ajuda para guiar as crianças para as portas da escola dando o menor número de passos possíveis.",
	"As portas estão assinaladas com uma seta.",
	"O limite de passos que tens, está no bloco no canto superior esquerdo.",
	"Também tens a tua avaliação em estrelas, que aparece junto ao bloco de passos.",
	"Tenta dar o menor número de passos possíveis para colecionar todas as estrelas. Isto se quiseres explorar outros locais da escola.",
	"Já agora, as crianças seguem sempre o teu exemplo, tens influência sobre elas.",
	"Usa as setas de movimento para mover a professora e influenciar a criança verde até a porta da escola.",
	"",
	"Boa conseguiste! Estás pronta para o próximo desafio!"
]

var current_text_index = 0

var dicts: Dictionary = {
	max_moves = 99,
	need_to_save = 1,
	saved = 0,
	stars = 3,
	treestars = -2,
	twostars = -2,
	onestar = -2,
}

func _ready() -> void:
	text_label.visible_characters = 0
	text_label.text = texts[current_text_index]
	GameManager.moving = true  # Bloqueia o movimento inicialmente
	talk()
	space_key.hide()
	
	animation_player.play("seta")
	animation_player.play_backwards("fade")
	
	seta_porta_tutorial.hide()
	GameManager.moves = dicts.max_moves

func _process(delta: float) -> void:
	#if current_text_index != 9:
		#animation_player.play("seta")
	timer.wait_time = 1.0 / speed
	GameManager.moves = clamp(GameManager.moves, 0, dicts.max_moves)  
	moves.text = str(GameManager.moves)
	
	if Input.is_action_just_pressed("ui_accept") and !finished and !GameManager.paused:
		if not writing:
			talk()
		else:
			skip()

	timer.paused = GameManager.paused

	# Mostra o espaço para continuar o diálogo
	if show_key and (text_label.visible_characters >= 18 or text_label.visible_characters == -1):
		space_key.show()
	else:
		space_key.hide()

	if current_text_index == 11:
		finished = true
			
			
	if dicts.saved == 1:
		current_text_index = 10
		GameManager.moving = true  
		finished = false
		animation_player.play_backwards("fade")
		talk()
		dicts.saved = 0
		await get_tree().create_timer(5).timeout
		SaveSystem.data.TutGreen = true
		GameManager.moving = false
		GameManager.change_scene("res://assets/Scenes/Levels/cp1_lvl1.tscn")
		


func talk():
	print(current_text_index)
	timer.start()
	text_label.visible_characters = 0
	text_label.text = texts[current_text_index]
	writing = true
	#animation_player.play("seta")
	if current_text_index == 0:
		show_key = true
	else:
		show_key = false
		
	if current_text_index == 3:
		seta_porta_tutorial.show()
		animation_player.play("seta")
	elif current_text_index == 4:
		seta_porta_tutorial.position.x = calendar.position.x + calendar.size.x / 2
		seta_porta_tutorial.show()
		animation_player.play("seta")
	elif current_text_index == 5:
		seta_porta_tutorial.position.x = stars.position.x + stars.size.x / 2
		seta_porta_tutorial.show()
		animation_player.play("seta")
	elif current_text_index == 9:
		
		animation_player.play("fade")
		GameManager.moving = false
		finished = true
		#return
	else:
		seta_porta_tutorial.hide()

func skip():
	#if current_text_index == 10 and dicts.saved < 1:
		#return

	timer.stop()
	text_label.visible_characters = -1
	writing = false
	next_text()

func next_text():
	if current_text_index == 9 and dicts.saved < 1:
			
		animation_player.play("fade")
		GameManager.moving = false
		finished = true
		return

	current_text_index += 1



func _on_timer_timeout() -> void:
	if text_label.visible_characters < text_label.text.length():
		Letter.play()
		text_label.visible_characters += 1
	else:
		timer.stop()
		writing = false
		next_text()
