extends Area2D

var animation_speed = 2
var moving = false
var tile_size = 64
@onready var orange_kid_sprite: AnimatedSprite2D = %OrangeKidSprite

var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

@onready var ray = $RayCast2d
@onready var tile_map: TileMap = %TileMap

func _ready():
	# Snap the position to the tile grid
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2

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

	if GameManager.checker(dir, ray, inputs, tile_size):
		moving = true
		orange_kid_sprite.play("walk")
		
		if dir == "right":
			orange_kid_sprite.flip_h = true
		elif dir == "left":
			orange_kid_sprite.flip_h = false

		# Start the continuous movement
		move_in_direction(dir)
		GameManager.moving += 1

func move_in_direction(dir):
	var target_pos = position + inputs[dir] * tile_size
	
	# Check if the RayCast hits anything
	ray.target_position = (target_pos - position).normalized() * tile_size
	ray.force_raycast_update()
	
	# Stop moving if the RayCast detects an obstacle
	if ray.is_colliding():
		moving = false
		GameManager.moving -= 1
		orange_kid_sprite.play("idle")
		return
	
	# Tween to the next tile
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_pos, 1.0 / animation_speed).set_trans(Tween.TRANS_SINE)

	# Continue moving after tween finishes
	tween.finished.connect(func():
		if moving:
			move_in_direction(dir)
		else:
			GameManager.moving -=1
			orange_kid_sprite.play("idle")
	)
