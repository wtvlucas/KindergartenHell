extends Control


@onready var help: TextureRect = %Help
@onready var arrow_players: Sprite2D = %ArrowPlayers
@onready var green: TextureRect = %Green
@onready var blue: TextureRect = %Blue
@onready var red: TextureRect = %Red
@onready var orange: TextureRect = %Orange
@onready var tut_label: Label = %TutLabel
@onready var setaback: TextureRect = %Setaback


var positions: Array = []
var option : int = 2

 
func _ready() -> void:
	self.hide()



	positions = [
		setaback,
		green,
		blue,
		red,
		orange
	]
	
	
	update_option_position()


func change_lvl() -> void:
	if Input.is_action_just_pressed("select"):
		if option == 1:
			self.hide()
			get_parent().helping = false
			
	if option == 2:
		tut_label.text = "Green"
	if option == 3:
		tut_label.text = "blue"
	if option == 4:
		tut_label.text = "red"
	if option == 5:
		tut_label.text = "orange"
			

func _process(delta: float) -> void:
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
	var pos = positions[option - 1].position
	var sz = positions[option - 1].size.x / 2
	arrow_players.position = Vector2(pos.x + sz, pos.y - 35)
