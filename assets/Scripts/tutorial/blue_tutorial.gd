extends Node2D

@onready var text_label: RichTextLabel = %TextLabel
@onready var timer: Timer = %Timer
@onready var player: Area2D = %Player
@onready var box: TextureRect = %Box
#@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var animation_player: AnimationPlayer = $Tutorial/AnimationPlayer
@onready var help: Sprite2D = %Help

@onready var esc_key: Sprite2D = %EscKey
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
	"Hello again, I forgot to tell you there are many different children here. ",#0
	"Ahahah. ",#1
	"Just look at the color of the clothes.",
	"You have a list of the children in your pause menu. Try pausing the game       and select the      icon in the bottom right corner.",
	"Okay, let me help you now and then I'll leave you to work",
	"The blue kids will make the opposite move to yours.",#5
	"If you go down, the blue goes up. Try to take her to the door and you will see that she makes the opposite movements to yours.",
	"",
	"Great, you did it! Now you're on your own. See you around."
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
	GameManager.moving = true
	GameManager.endLevel = false
	talk()
	esc_key.hide()
	help.hide()
	
	animation_player.play("seta")
	animation_player.play_backwards("fade")
	
	seta_porta_tutorial.hide()
	GameManager.moves = dicts.max_moves

func _process(delta: float) -> void:

	timer.wait_time = 1.0 / speed
	GameManager.moves = clamp(GameManager.moves, 0, dicts.max_moves)  
	moves.text = str(GameManager.moves)
	
	if Input.is_action_just_pressed("ui_accept") and !finished and !GameManager.paused:
		if not writing:
			talk()
		else:
			skip()

	timer.paused = GameManager.paused

	if show_key:
		esc_key.visible = text_label.visible_characters >= 75
		help.visible = text_label.visible_characters >= 94

		if text_label.visible_characters == -1:
			esc_key.show()
			help.show()
	else:
		esc_key.hide()
		help.hide()

	if current_text_index == 9:
		finished = true
			
			
	if dicts.saved == 1:
		current_text_index = 8
		GameManager.moving = true  
		finished = false
		animation_player.play_backwards("fade")
		talk()
		dicts.saved = 0
		await get_tree().create_timer(5).timeout
		SaveSystem.data.TutBlue = true
		GameManager.moving = false
		GameManager.change_scene("res://assets/Scenes/Levels/cp1_lvl6.tscn")
		Chapter1Music.play()
		


func talk():
	#print(current_text_index)
	timer.start()
	text_label.visible_characters = 0
	text_label.text = texts[current_text_index]
	writing = true
	#animation_player.play("seta")
	if current_text_index == 3:
		show_key = true
	else:
		show_key = false
		

	if current_text_index == 7:
		
		animation_player.play("fade")
		GameManager.moving = false
		finished = true
		#return
	

func skip():
	#if current_text_index == 10 and dicts.saved < 1:
		#return

	timer.stop()
	text_label.visible_characters = -1
	writing = false
	next_text()

func next_text():
	if current_text_index == 7 and dicts.saved < 1:
			
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
