extends Area2D

var animation_speed = 2
var moving = false
var tile_size = 64
@onready var tile_map: TileMap = %TileMap
@onready var blue_kid_sprite: AnimatedSprite2D = %BlueKidSprite


var inputs = {
	"left": Vector2.RIGHT,
	"right": Vector2.LEFT,
	"down": Vector2.UP,
	"up": Vector2.DOWN
}
var last_move
var last_pos
var tile
var tile_pos

@onready var ray = $RayCast2d

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	
func _unhandled_input(event):
	if moving or GameManager.blocked or GameManager.moving != 0:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
			
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	#if GameManager.moving != 0:
		#return 
	tile_pos = tile_map.local_to_map(transform.get_origin()) 
	if GameManager.checker(dir, ray, inputs, tile_size, true) == true:
		moving = true
		blue_kid_sprite.play("walk")
		
		if dir == "left":
			blue_kid_sprite.flip_h = true
		elif dir == "right":
			blue_kid_sprite.flip_h = false
			

		
		last_pos = position
		#prints(last_pos, tile_pos)
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)

		await tween.finished
		moving = false
		blue_kid_sprite.play("idle")

		
		

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Exit"):
		self.queue_free()
		SavedChild.play()
		get_parent().dicts.saved += 1
	
	else:
		moving = true
		GameManager.moving += 1
		blue_kid_sprite.play("walk")
		GameManager.colided = true
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", tile_map.map_to_local(tile_pos), 1.0/animation_speed).set_trans(Tween.TRANS_SINE)

		
		await tween.finished
		moving = false
		GameManager.moving -= 1
		blue_kid_sprite.play("idle")
		GameManager.colided = false
		GameManager.colided_played = false
