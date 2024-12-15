extends Node

const SAVE_PATH := "user://save.res"

var data := SaveData.new()

func save_data() -> void:
	ResourceSaver.save(data, SAVE_PATH)

func load_data() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		data = ResourceLoader.load(SAVE_PATH)


func _ready() -> void:
	load_data()
	if data:
		GameManager.current_level = data.last_level
	

func set_stars_for_level(level: String, value: int):
	if not data:
		return
	if level in data.stars:
		data.stars[level] = clamp(value, 0, 3)
		print("Estrelas ajustadas:", level, "=", data.stars[level])
		save_data()

func get_stars_for_level(level: String) -> int:
	if not data:
		return 0
	return data.stars.get(level, 0)

func get_total_stars() -> int:
	var total = 0
	for star_count in data.stars.values():
		total += star_count
	return total
	
func reset_stars():
	for level in data.stars.keys():
		data.stars[level] = 0
	print("Todas as estrelas foram resetadas para 0.")
	save_data()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if data:
			data.last_level = GameManager.current_level
			save_data()
			get_tree().quit()
