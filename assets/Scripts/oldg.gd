extends Node


var blocked = false
signal movement_locked() 
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
		if current_collider.is_in_group("Kids") or current_collider.is_in_group("Player") or current_collider.is_in_group("BlueKid"):
			# Atualiza o RayCast do Kid ou de outros objetos antes de verificar
			if current_collider.has_method("ray"): 
				var child_ray = current_collider.ray
				child_ray.target_position = inputs[dir] * tile_size
				child_ray.force_raycast_update()

			# Verifica se o objeto colidido pode se mover
			if can_object_move(dir, current_collider, inputs, tile_size):
				current_collider = current_collider.ray.get_collider()
			else:
				return false
		elif current_collider.is_in_group("Tilemap") and i == 4:
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
