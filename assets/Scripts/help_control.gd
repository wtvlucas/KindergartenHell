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
	
	if !get_parent().helping:
		return
		
	if Input.is_action_just_pressed("select"):
		if option == 1:
			self.hide()
			get_parent().helping = false
			
	if option == 2:
		tut_label.text = "It copies your every move. If you walk up, he will walk up. If you walk to the right, he will walk to the right.
						\nNote:
						Child who always gets what he wants by being well-behaved. He always does his homework and has exemplary behavior."
	if option == 3:
		tut_label.text = "It makes the opposite movements to yours. If you go down, he goes up. If you walk to the right, he will go to the left.
						\nNote:
						He's afraid of the stories his grandparents tell. He doesn't like eating soup and feels insecure doing what people tell him. Maybe he believes in the Bag Man that his grandfather talks about so much."
	if option == 4:
		tut_label.text = "It copies all your movements, but if it goes against something, it immediately reverses direction and starts doing the opposite. 
						\nNote:
						Recently, the youngest brother was born. Since then, he has been jealous and a little unsure of what to do. It's bipolar."
	if option == 5:
		tut_label.text = "It copies your movements, but it will travel through all the empty space in front of it until it collides with something.
						\nNote:
						Child who wants to do everything. Full of energy that only the curiosity of innocence can give. He really likes Coca-Cola."
			

func _process(delta: float) -> void:
	if !get_parent().helping:
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
	var pos = positions[option - 1].position
	var sz = positions[option - 1].size.x / 2
	arrow_players.position = Vector2(pos.x + sz, pos.y - 35)
