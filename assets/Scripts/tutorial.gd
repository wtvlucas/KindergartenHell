extends CanvasLayer

@onready var text_label: RichTextLabel = %TextLabel
@onready var timer: Timer = %Timer
var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

var writing = false
var speed = 16
var finished
var texts = ["Pressiona a tecla “Espaço” para seguir o dialogo.",
 			"Olá professora Clara, bem-vinda ao Kindergarten Hell!",
			"Precisamos da tua ajuda para guiar as crianças para as portas da escola dando o menor número de passos possíveis.",
			"As portas estão assinaladas com uma seta.",
			"O limite de passos que tens, está no bloco no canto superior esquerdo.",
			"Também tens a tua avaliação em estrelas, que aparece junto ao bloco de passos.", 
			"Tenta dar o menor número de passos possíveis para colecionar todas as estrelas. Isto se quiseres explorar outros locais da escola.",
			"Já agora, as crianças seguem sempre o teu exemplo, tens influência sobre elas.",
			"Usa as setas de movimento para mover a professora e influenciar a criança verde até a porta da escola.",
			]
var current_text_index = 0 # Índice atual do texto no dicionário

func _ready() -> void:
	text_label.visible_characters = 0
	text_label.text = texts[current_text_index]
	talk()

func _process(delta: float) -> void:
	timer.wait_time = 1.0 / speed
	if Input.is_action_just_pressed("ui_accept"):
		if writing == false:
			talk() # Apenas começa a exibir o texto atual
		else:
			skip()

func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			return


func talk():
	timer.start()
	text_label.visible_characters = 0
	text_label.text = texts[current_text_index]
	writing = true

func skip():
	timer.stop()
	text_label.visible_characters = -1
	writing = false
	# Muda para o próximo texto após pular
	next_text()

func next_text():
	# Incrementa o índice do texto e reinicia ao chegar no final
	current_text_index = (current_text_index + 1) % texts.size()

func _on_timer_timeout() -> void:
	if text_label.visible_characters < text_label.text.length():
		text_label.visible_characters += 1 
	else:
		timer.stop()
		writing = false
		# Avança para o próximo texto automaticamente após terminar
		next_text()
