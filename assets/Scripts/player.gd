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
var can_move = true

@onready var ray = $RayCast2d

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	
	
func _process(delta: float) -> void:
	
	pass
	
	
func _unhandled_input(event):
	if moving:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)


func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	#if GameManager.moving != 0:
		#return
		
	if GameManager.checker(dir, ray, inputs, tile_size) == true:
		GameManager.blocked = false
		GameManager.moving += 1
		#GameManager.blocked = false
		GameManager.moves -= 1
		tile_pos = tile_map.local_to_map(transform.get_origin()) 
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		await tween.finished
		GameManager.moving -= 1
	else:
		GameManager.blocked = true
	


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Tilemap") || area.is_in_group("Walls") || area.is_in_group("Kids"):
		GameManager.moving += 1
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", tile_map.map_to_local(tile_pos), 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
			
		await tween.finished
		GameManager.moving -= 1
