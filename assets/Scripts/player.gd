extends Area2D

var animation_speed = 2
var moving = false
var tile_size = 64
var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
var last_pos
var tile_pos
@onready var tile_map: TileMap = %TileMap
var can_move = false

@onready var ray = $RayCast2d

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	
	
func _process(delta: float) -> void:
	print(can_move)
	#pass
	
	
func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
			
			
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	
	#checker(dir)
	if GameManager.checker(dir, ray, inputs, tile_size) == true:
		GameManager.blocked = false
		GameManager.moves += 1
		tile_pos = tile_map.local_to_map(transform.get_origin()) 
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
	else:
		GameManager.blocked = true
	

	
	
func checker(dir) -> void:
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if ray.is_colliding():
		if ray.get_collider().is_in_group("Kids"):
			var kid = ray.get_collider()
			if kid.ray.is_colliding():
				if kid.ray.get_collider().is_in_group("Kids"):
					var kid2 = kid.ray.get_collider()
					if kid2.ray.is_colliding():
						if kid2.ray.get_collider().is_in_group("Kids"):
							var kid3 = kid2.ray.get_collider()
							if kid3.ray.is_colliding():
								if kid3.ray.get_collider().is_in_group("Kids"):
									var kid4 = kid3.ray.get_collider()
									if kid4.ray.is_colliding():
										if kid4.ray.get_collider().is_in_group("Tilemap"):
											print("TTT")
											can_move = false
									else:
										print("22")
										can_move = true
								else:
									can_move = false
							else: 
								print("e")
								can_move = true
					else:
						print("d")
						can_move = true
				
			else:
				print("b")
				can_move = true
	else:
		print("a")
		can_move = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Tilemap") || area.is_in_group("Walls") || area.is_in_group("Kids"):
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", tile_map.map_to_local(tile_pos), 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
			
		await tween.finished
		moving = false
