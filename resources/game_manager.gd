extends Node


var blocked = false
var moves = 0
var pause_menu = preload("res://assets/Scenes/pause_menu.tscn")
var paused = false
var menu = pause_menu.instantiate()

var current_level : String

func _ready() -> void:
	add_child(menu)

func pause() -> void:
	menu.show()

func unpause() -> void:
	menu.hide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().get_current_scene().get_name() != "MainMenu":
		pause() if !paused else unpause()
		paused = !paused
		
	#prints(current_level)


func checker(dir, ray, inputs, tile_size, blue = false):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	if paused:
		return false
	
	if not ray.is_colliding():
		return true
		
	var current_collider = ray.get_collider()
	
	for i in range(5): 
		if blue:
			if current_collider.is_in_group("RedKid"): 
				return current_collider.inverted
			
			elif current_collider.is_in_group("Kids") or current_collider.is_in_group("Player"):
				return false
				
			elif current_collider.is_in_group("Tilemap"):
				return false
				
			else:
				return true
		
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
		elif current_collider.is_in_group("RedKid"):
			return !current_collider.inverted
			
			 
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
	
	
