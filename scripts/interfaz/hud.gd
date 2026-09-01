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
@onready var panel_inventario: PanelContainer = $PanelInventario
@onready var contenedor_items: GridContainer = $PanelInventario/Margen/VBox/ScrollContainer/ContenedorItems
@onready var etiqueta_capacidad: Label = $PanelInventario/Margen/VBox/Pie/EtiquetaCapacidad

var lineas_actuales: Array[String] = []
var indice_linea: int = 0
var jugador_ref: CharacterBody3D = null

func _ready() -> void:
	panel_dialogo.visible = false
	panel_inventario.visible = false
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
	if jugador.has_signal("inventario_abierto"):
		jugador.inventario_abierto.connect(toggle_panel_inventario)
	var inv: Inventario = jugador.get_node_or_null("Inventario") as Inventario
	if inv:
		inv.inventario_cambiado.connect(_actualizar_inventario)

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

func toggle_panel_inventario(abierto: bool) -> void:
	panel_inventario.visible = abierto
	if abierto:
		_actualizar_inventario()

func _actualizar_inventario() -> void:
	for hijo in contenedor_items.get_children():
		hijo.queue_free()
	if not jugador_ref:
		return
	var inv: Inventario = jugador_ref.get_node_or_null("Inventario") as Inventario
	if not inv:
		return
	var slots: Array[Dictionary] = inv.obtener_slots()
	for slot in slots:
		var item: DatosItem = slot.item
		var cantidad: int = slot.cantidad
		var boton: Button = Button.new()
		boton.text = "%s  x%d" % [item.nombre, cantidad]
		boton.custom_minimum_size = Vector2(250, 44)
		var estilo: StyleBoxFlat = StyleBoxFlat.new()
		estilo.bg_color = Color(0.08, 0.07, 0.05, 0.9)
		estilo.border_color = Color(0.6, 0.5, 0.3, 0.5)
		estilo.border_width_left = 1
		estilo.border_width_right = 1
		estilo.border_width_top = 1
		estilo.border_width_bottom = 1
		estilo.content_margin_left = 12
		estilo.content_margin_right = 12
		estilo.content_margin_top = 8
		estilo.content_margin_bottom = 8
		boton.add_theme_stylebox_override("normal", estilo)
		var estilo_hover: StyleBoxFlat = estilo.duplicate()
		estilo_hover.bg_color = Color(0.12, 0.1, 0.06, 0.95)
		estilo_hover.border_color = Color(0.8, 0.7, 0.4, 0.8)
		boton.add_theme_stylebox_override("hover", estilo_hover)
		boton.add_theme_color_override("font_color", Color(0.85, 0.8, 0.65, 1))
		boton.add_theme_color_override("font_hover_color", Color(1, 0.9, 0.6, 1))
		boton.add_theme_font_size_override("font_size", 15)
		contenedor_items.add_child(boton)
	etiqueta_capacidad.text = "ESPACIOS: %d / %d" % [slots.size(), inv.capacidad]
