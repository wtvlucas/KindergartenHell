extends Area2D

var animation_speed = 2
var moving = false
var tile_size = 64
var can_move = false

var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
var tile_pos
@onready var tile_map: TileMap = %TileMap


@onready var ray = $RayCast2d

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	#GameManager.connect("movement_locked", self, "_on_movement_locked")
	
func _unhandled_input(event):
	if moving or GameManager.blocked:
		return
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)
			
func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	tile_pos = tile_map.local_to_map(transform.get_origin()) 
	#if !ray.get_collider().is_in_group("Tilemap"):
	
	
	if GameManager.checker(dir, ray, inputs, tile_size) == true and !GameManager.blocked:
		
		
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
		


func _on_area_entered(area: Area2D) -> void:
	#if area.is_in_group("Kids") || area.is_in_group("Player") :
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", tile_map.map_to_local(tile_pos), 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
	moving = true
	
	await tween.finished
	moving = false
		
	if area.is_in_group("Exit"):
		self.queue_free()
		get_parent().saved += 1
