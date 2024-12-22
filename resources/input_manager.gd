extends Node

# Sinal para enviar os inputs processados
signal input_received(action: String)

# Configurações
var swipe_threshold = 50  # Distância mínima para considerar um swipe
var start_touch_position = Vector2.ZERO
var touch_start_time = 0.0
var max_tap_duration = 0.3  # Duração máxima para considerar um toque simples (em segundos)
var touch_detected = false  # Para rastrear se houve movimento após o toque

func _input(event):
	# Reconhecer início de toque
	if event is InputEventScreenTouch and event.pressed:
		start_touch_position = event.position
		touch_start_time = Time.get_ticks_msec() / 1000.0
		touch_detected = false

	# Detectar movimento de arrasto
	elif event is InputEventScreenDrag:
		var swipe_vector = event.position - start_touch_position
		if swipe_vector.length() > swipe_threshold:
			touch_detected = true  # Marcamos que o toque foi um arrasto
			if abs(swipe_vector.x) > abs(swipe_vector.y):
				if swipe_vector.x > 0:
					emit_signal("input_received", "right")
				else:
					emit_signal("input_received", "left")
			else:
				if swipe_vector.y > 0:
					emit_signal("input_received", "down")
				else:
					emit_signal("input_received", "up")
			start_touch_position = event.position

	# Detectar término do toque
	elif event is InputEventScreenTouch and not event.pressed:
		var touch_duration = (Time.get_ticks_msec() / 1000.0) - touch_start_time
		# Verificar se é um toque rápido (sem arrasto)
		if touch_duration <= max_tap_duration and not touch_detected:
			emit_signal("input_received", "select")
		start_touch_position = Vector2.ZERO

	# Reconhecer inputs tradicionais (teclado ou gamepad)
	for action in ["up", "down", "left", "right", "select"]:
		if Input.is_action_just_pressed(action):
			emit_signal("input_received", action)
