extends Node


var blocked = false
var moves = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().change_scene_to_file("res://assets/Scenes/main_menu.tscn")


func checker(dir, ray, inputs, tile_size):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()

	if not ray.is_colliding():
		return true
	var current_collider = ray.get_collider()
	for i in range(5): 
		if current_collider.is_in_group("Kids") or current_collider.is_in_group("Player"):
			var next_ray = current_collider.ray
			next_ray.target_position = inputs[dir] * tile_size
			next_ray.force_raycast_update()
			if next_ray.is_colliding():
				current_collider = next_ray.get_collider()
			else:
				return true
		elif current_collider.is_in_group("Tilemap") and i == 4:
			return false
		elif current_collider.is_in_group("BlueKid") and i == 4:
			return false
			 
		else:
			return false

	return true
	
func can_object_move(dir, obj, inputs, tile_size):
	if not obj.has_method("ray"): 
		return false  # Se o objeto não tem raycast, considera como bloqueado	
	var ray = obj.ray
	# Atualiza o RayCast do objeto para a nova direção
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()	
	return not ray.is_colliding()  # Retorna true se o caminho estiver livre
