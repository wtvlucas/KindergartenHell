extends CanvasLayer


@onready var home: TextureButton = %Home
@onready var restart: TextureButton = %Restart
@onready var arrow: Sprite2D = %Arrow
@onready var back: TextureButton = $Back


var positions: Array = []
var option : int = 1

 
func _ready() -> void:
	#SaveSystem.reset_stars()
	self.hide()
	GameManager.paused = false
	#SaveSystem.load_data()


	positions = [
		back.position,
		home.position,
		restart.position
	]
	
	
	update_option_position()


func change_lvl() -> void:
	if Input.is_action_just_pressed("select"):
		if option == 1:
			get_tree().reload_current_scene()
			self.hide()
			GameManager.paused = false
			GameManager.moving = false
		elif option == 2:
			GameManager.change_scene("res://assets/Scenes/main_menu.tscn")
			SaveSystem.data.last_level = GameManager.current_level
			SaveSystem.save_data()
			Main.stream_paused = false
			Chapter1.stop()
			Chapter2.stop()
			self.hide()
			GameManager.paused = false
			GameManager.unpause()
			GameManager.moving = false
			
		elif option == 3:
			self.hide()
			GameManager.paused = false
			GameManager.moving = false
		

func _process(delta: float) -> void:
	
	if !GameManager.paused:
		return
	change_lvl()
	#print(option)
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("up"):
		move_character(-1)
	elif Input.is_action_just_pressed("right") or Input.is_action_just_pressed("down"):
		move_character(1)


func move_character(direction: int) -> void:
	option = clamp(option + direction, 1, positions.size())
	update_option_position()

func update_option_position() -> void:
	arrow.position = Vector2(positions[option - 1].x + 7, positions[option - 1].y - 35)


func _on_home_pressed() -> void:
	
	GameManager.change_scene("res://assets/Scenes/main_menu.tscn")
	SaveSystem.data.last_level = GameManager.current_level
	self.hide()
	GameManager.paused = false
	GameManager.unpause()


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
	self.hide()
	GameManager.paused = false


func _on_back_pressed() -> void:
	self.hide()
	GameManager.paused = false
