extends Area2D

var animation_speed = 10
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
var position_history = []  # Histórico das posições visitadas

func _ready():
	# Snap the posição to the tile grid
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	tile_pos = tile_map.local_to_map(position)  # Define a posição inicial no TileMap
	position_history.append(tile_pos)  # Adiciona a posição inicial ao histórico

func _unhandled_input(event):
	# Prevent input handling if already moving or blocked
	if moving or GameManager.blocked:
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
		return

	# Verifica se o movimento é permitido pelo GameManager
	if GameManager.checker(dir, ray, inputs, tile_size):
		moving = true
		green_kid_sprite.play("walk")
		
		# Define a direção do sprite
		green_kid_sprite.flip_h = (dir == "right")

		# Atualiza o tile_pos antes de iniciar o movimento
		tile_pos = tile_map.local_to_map(position)
		position_history.append(tile_pos)  # Adiciona ao histórico antes de mover
		if position_history.size() > 3:
			position_history.pop_front()
  # Mantém apenas as últimas 3 posições
		move_in_direction(dir)
		await get_tree().create_timer(0.1).timeout
		GameManager.moving += 1

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
	position_history.append(tile_pos)  # Atualiza o histórico com a nova posição
	if position_history.size() > 3:
		position_history.pop_front()  # Mantém apenas as últimas 3 posições

	#prints(position_history)

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

	if position_history.size() < 2:
		stop_movement()
		return
		
	moving = false
	green_kid_sprite.play("idle")
	#GameManager.moving = 0
	
	var previous_tile_pos = position_history[-2]  # Penúltima posição no histórico
	var previous_world_pos = tile_map.map_to_local(previous_tile_pos)

	GameManager.moving += 1
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", previous_world_pos, 1.0 / animation_speed).set_trans(Tween.TRANS_SINE)

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
		GameManager.moving -= 1
	else:
		GameManager.colided = true
		#print("colided", tile_pos)
		#print(GameManager.moving)
		move_back()
		
		GameManager.colided = false
		GameManager.colided_played = false
