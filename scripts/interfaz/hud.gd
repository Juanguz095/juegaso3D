class_name HUD
extends CanvasLayer

@onready var barra_salud: ProgressBar = $ContenedorHUD/Margen/Contenido/Inferior/SaludContainer/BarraSalud
@onready var etiqueta_salud: Label = $ContenedorHUD/Margen/Contenido/Inferior/SaludContainer/EtiquetaSalud
@onready var etiqueta_arma: Label = $ContenedorHUD/Margen/Contenido/Inferior/ArmaContainer/EtiquetaArma
@onready var etiqueta_municion: Label = $ContenedorHUD/Margen/Contenido/Inferior/ArmaContainer/EtiquetaMunicion
@onready var etiqueta_prompt: Label = $ContenedorHUD/Centro/EtiquetaPrompt
@onready var panel_dialogo: PanelContainer = $ContenedorHUD/Margen/Contenido/PanelDialogo
@onready var etiqueta_hablante: Label = $ContenedorHUD/Margen/Contenido/PanelDialogo/Margen/VBox/EtiquetaHablante
@onready var etiqueta_texto_dialogo: Label = $ContenedorHUD/Margen/Contenido/PanelDialogo/Margen/VBox/EtiquetaTexto
@onready var boton_continuar: Button = $ContenedorHUD/Margen/Contenido/PanelDialogo/Margen/VBox/BotonContinuar
@onready var barra_stamina: ProgressBar = $ContenedorHUD/Margen/Contenido/Inferior/SaludContainer/BarraStamina

var lineas_actuales: Array[String] = []
var indice_linea: int = 0
var jugador_ref: CharacterBody3D = null

func _ready() -> void:
	panel_dialogo.visible = false
	etiqueta_prompt.text = ""
	boton_continuar.pressed.connect(_avanzar_dialogo)

func conectar_jugador(jugador: CharacterBody3D) -> void:
	jugador_ref = jugador
	var salud: ComponenteSalud = jugador.get_node_or_null("ComponenteSalud") as ComponenteSalud
	if salud:
		salud.salud_cambiada.connect(actualizar_salud)
		actualizar_salud(salud.salud_actual, salud.salud_maxima)

	if jugador.has_signal("arma_cambiada"):
		jugador.arma_cambiada.connect(actualizar_arma)
	if jugador.has_signal("municion_actualizada"):
		jugador.municion_actualizada.connect(actualizar_municion)
	if jugador.has_signal("prompt_interaccion_cambiado"):
		jugador.prompt_interaccion_cambiado.connect(actualizar_prompt)
	if jugador.has_signal("stamina_cambiada"):
		jugador.stamina_cambiada.connect(actualizar_stamina)

func _input(event: InputEvent) -> void:
	if panel_dialogo.visible and (event.is_action_pressed("interactuar") or event.is_action_pressed("ui_accept")):
		get_viewport().set_input_as_handled()
		_avanzar_dialogo()

func actualizar_salud(actual: float, maxima: float) -> void:
	barra_salud.max_value = maxima
	barra_salud.value = actual
	etiqueta_salud.text = "SALUD: %d / %d" % [int(actual), int(maxima)]

func actualizar_arma(nombre_arma: String, municion: int, municion_max: int) -> void:
	etiqueta_arma.text = nombre_arma.to_upper()
	etiqueta_municion.text = "%d / %d" % [municion, municion_max]

func actualizar_municion(municion: int, municion_max: int) -> void:
	etiqueta_municion.text = "%d / %d" % [municion, municion_max]

func actualizar_prompt(texto: String) -> void:
	etiqueta_prompt.text = texto

func mostrar_dialogo(hablante: String, lineas: Array[String]) -> void:
	lineas_actuales = lineas
	indice_linea = 0
	etiqueta_hablante.text = hablante
	panel_dialogo.visible = true
	_mostrar_linea_actual()

func _mostrar_linea_actual() -> void:
	if indice_linea < lineas_actuales.size():
		etiqueta_texto_dialogo.text = lineas_actuales[indice_linea]
		if indice_linea == lineas_actuales.size() - 1:
			boton_continuar.text = "[E] Terminar conversación"
		else:
			boton_continuar.text = "[E] Siguiente"
	else:
		cerrar_dialogo()

func _avanzar_dialogo() -> void:
	indice_linea += 1
	if indice_linea < lineas_actuales.size():
		_mostrar_linea_actual()
	else:
		cerrar_dialogo()

func cerrar_dialogo() -> void:
	panel_dialogo.visible = false
	if jugador_ref and jugador_ref.has_method("establecer_en_dialogo"):
		jugador_ref.establecer_en_dialogo(false)

func actualizar_stamina(actual: float, maxima: float) -> void:
	barra_stamina.max_value = maxima
	barra_stamina.value = actual
