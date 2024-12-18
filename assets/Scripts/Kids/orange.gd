extends Area2D

var animation_speed = 7
var moving = false
var tile_size = 64
@onready var green_kid_sprite: AnimatedSprite2D = $OrangeKidSprite

var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

@onready var ray = $RayCast2d
@onready var tile_map: TileMap = %TileMap

var tile_pos  # Posição atual do personagem no TileMap

func _ready():
	# Snap the posição to the tile grid
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	tile_pos = tile_map.local_to_map(position)  # Define a posição inicial no TileMap

func _unhandled_input(event):
	# Prevent input handling if already moving or blocked
	if moving or GameManager.blocked or GameManager.moving != 0:
		return
	
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			start_movement(dir)

func start_movement(dir):
	# Set the RayCast target position
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()

	# Verifica se o RayCast está colidindo antes de iniciar o movimento
	if ray.is_colliding():
		#move_back()  # Retorna para o tile anterior
		
		return

	# Verifica se o movimento é permitido pelo GameManager
	if GameManager.checker(dir, ray, inputs, tile_size):
		moving = true
		GameManager.moving += 1
		green_kid_sprite.play("walk")
		
		# Define a direção do sprite
		green_kid_sprite.flip_h = (dir == "right")

		# Atualiza o tile_pos antes de iniciar o movimento
		tile_pos = tile_map.local_to_map(position)
		move_in_direction(dir)

func move_in_direction(dir):
	var target_pos = position + inputs[dir] * tile_size
	ray.target_position = (target_pos - position).normalized() * tile_size
	ray.force_raycast_update()

	if ray.is_colliding():
		stop_movement()
		return
		
	Walk.play_random()
	
	# Atualiza o tile_pos
	tile_pos = tile_map.local_to_map(target_pos)

	# Cria o movimento com tween
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_pos, 1.0 / animation_speed).set_trans(Tween.TRANS_SINE)

	# Continua ou finaliza o movimento após o tween
	tween.finished.connect(func():
		if moving:
			move_in_direction(dir)
		else:
			stop_movement())

func move_back():
	# Retorna ao tile_pos anterior com tween
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", tile_map.map_to_local(tile_pos), 1.0 / animation_speed).set_trans(Tween.TRANS_SINE)

	await tween.finished
	stop_movement()

func stop_movement():
	moving = false
	GameManager.moving -= 1
	green_kid_sprite.play("idle")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Exit"):
		self.queue_free()
		SavedChild.play()
		get_parent().dicts.saved += 1
	elif area.is_in_group("Player"):
		move_back()
