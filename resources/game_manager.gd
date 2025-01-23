extends Node

#@onready var anim_player: AnimationPlayer = %AnimPlayer


var blocked = false
var moves = 0
var pause_menu = preload("res://assets/Scenes/pause_menu.tscn")
var paused = false
var menu = pause_menu.instantiate()
var endLevel = false
var chapter_2_unlocked : bool = false
var chapter_3_unlocked : bool = false
var is_input_locked = false 

var colided = false
var colided_played = false

var moving : int = 0
var current_level : String = "cp1_lvl1"

func _ready() -> void:
	add_child(menu)
	if get_tree().current_scene.get_name() == "MainMenu":
		Main.play()


func pause() -> void:
	menu.show()


func unpause() -> void:
	menu.hide()


func _process(delta: float) -> void:
	#print(get_tree().get_current_scene().get_name())
	if get_tree().get_current_scene() != null:
		#print(get_tree().get_current_scene().get_name())
		var current_scene = get_tree().get_current_scene().get_name()
		if Input.is_action_just_pressed("pause") and not current_scene in ["MainMenu", "Chapters", "Chapter1", "Chapter2", "Chapter3"]:
			if endLevel:
				return
			paused = !paused
			if paused:
				pause()
			else:
				unpause()
				
				
	GameManager.moving = clamp(GameManager.moving, 0, 10)  
				
	chapter_2_unlocked = SaveSystem.get_total_stars() >= 38
		
	chapter_3_unlocked = SaveSystem.get_total_stars() >= 76
		
		
	if colided and !colided_played:
		Colided.play_random()
		colided_played = true


func can_all_move():
	return moving == 0  


func checker(dir, ray, inputs, tile_size, blue = false):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if moving != 0:
		return false
	
	if paused or endLevel:
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

var moving_states = {}

func set_moving_state(id: String, state: bool):
	moving_states[id] = state

func is_any_moving() -> bool:
	for key in moving_states.keys():
		if moving_states[key]:
			return true
	return false


func can_object_move(dir, obj, inputs, tile_size):
	if not obj.has_method("ray"): 
		return false 
	var ray = obj.ray

	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	return not ray.is_colliding() 


func change_scene(path: String):
	if is_input_locked:
		return  

	is_input_locked = true  
	var anim_player = LevelChange.get_node("Fade/AnimPlayer") if LevelChange else null
	if anim_player:
		anim_player.play("out")
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(path)
	if anim_player:
		anim_player.play("in")
	is_input_locked = false 


func is_locked() -> bool:
	return is_input_locked

	
