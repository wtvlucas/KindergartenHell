extends Area2D

var animation_speed = 2
var moving = false
var tile_size = 64
@onready var red_kid_sprite: AnimatedSprite2D = $RedKidSprite



var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
var inputs_invert = {
	"right": Vector2.LEFT,
	"left": Vector2.RIGHT,
	"up": Vector2.DOWN,
	"down": Vector2.UP
}

var inverted = false

var last_pos
var tile_pos
@onready var tile_map: TileMap = %TileMap


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

		
	moving = true
	red_kid_sprite.play("walk")
	var moves = inputs_invert[dir] if inverted else inputs[dir]
	
	if !inverted:
		if dir == "right":
			red_kid_sprite.flip_h = true
		elif dir == "left":
			red_kid_sprite.flip_h = false
	else:
		if dir == "right":
			red_kid_sprite.flip_h = false
		elif dir == "left":
			red_kid_sprite.flip_h = true
	
			
		
	ray.target_position = moves * tile_size
	ray.force_raycast_update()

	last_pos = position
	tile_pos = tile_map.local_to_map(transform.get_origin()) 
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + moves * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
	#moving = true
	await tween.finished
	moving = false
	red_kid_sprite.play("idle")
	


func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("Exit"):
		moving = true
		GameManager.moving += 1
		red_kid_sprite.play("walk")
		inverted = !inverted
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", tile_map.map_to_local(tile_pos), 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		
		await tween.finished
		moving = false
		GameManager.moving -= 1
		red_kid_sprite.play("idle")
		#inverted = !inverted
		#print(inverted)
		
	else:
		self.queue_free()
		get_parent().dicts.saved += 1
