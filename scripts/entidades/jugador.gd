class_name Jugador
extends CharacterBody3D

signal arma_cambiada(nombre_arma: String, municion: int, municion_max: int)
signal municion_actualizada(municion: int, municion_max: int)
signal prompt_interaccion_cambiado(texto: String)
signal dialogo_iniciado(hablante: String, lineas: Array[String])
signal estado_agachado_cambiado(agachado: bool)

@export var velocidad_caminar: float = 5.0
@export var velocidad_correr: float = 8.0
@export var velocidad_agachado: float = 2.5
@export var fuerza_salto: float = 4.5
@export var sensibilidad_raton: float = 0.002
@export var armas: Array[DatosArma] = []
@export_group("Agacharse")
@export var altura_de_pie: float = 1.8
@export var altura_agachado: float = 1.0
@export var velocidad_transicion_crouch: float = 8.0
@export_group("Trepar")
@export var distancia_trepar: float = 1.5
@export var altura_max_trepar: float = 2.5
@export var velocidad_trepar: float = 3.0

@onready var pivote_camara: Node3D = $PivoteCamara
@onready var camara: Camera3D = $PivoteCamara/Camara3D
@onready var rayo_interaccion: RayCast3D = $PivoteCamara/Camara3D/RayoInteraccion
@onready var rayo_disparo: RayCast3D = $PivoteCamara/Camara3D/RayoDisparo
@onready var malla_arma: MeshInstance3D = $PivoteCamara/Camara3D/MallaArma
@onready var componente_salud: ComponenteSalud = $ComponenteSalud
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var malla_cuerpo: MeshInstance3D = $MallaCuerpo
@onready var rayo_trepar: RayCast3D = $RayoTrepar

var gravedad: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
var indice_arma_actual: int = 0
var puede_disparar: bool = true
var tiempo_ultimo_disparo: float = 0.0
var interactuable_actual: Interactuable = null
var en_dialogo: bool = false
var tiempo_fin_dialogo: float = 0.0
var raton_capturado: bool = true
var esta_agachado: bool = false
var altura_objetivo: float = 1.8
var esta_trepando: bool = false
var objetivo_trepar: Vector3 = Vector3.ZERO

func _ready() -> void:
	_asegurar_mapeo_entradas()
	capturar_raton(true)
	_inicializar_armas()
	_actualizar_datos_arma_ui()
	componente_salud.murio.connect(_al_morir)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and raton_capturado and not en_dialogo:
		rotate_y(-event.relative.x * sensibilidad_raton)
		pivote_camara.rotate_x(-event.relative.y * sensibilidad_raton)
		pivote_camara.rotation.x = clamp(pivote_camara.rotation.x, deg_to_rad(-85), deg_to_rad(85))

	if event.is_action_pressed("ui_cancel"):
		capturar_raton(not raton_capturado)

	if event is InputEventMouseButton and event.pressed and not raton_capturado:
		capturar_raton(true)

	if en_dialogo:
		return

	if event.is_action_pressed("arma_1"):
		cambiar_arma(0)
	elif event.is_action_pressed("arma_2"):
		cambiar_arma(1)

	if event.is_action_pressed("interactuar"):
		_ejecutar_interaccion()

	if event.is_action_pressed("recargar"):
		recargar()

func _physics_process(delta: float) -> void:
	_procesar_agacharse(delta)
	_procesar_trepar(delta)

	if not esta_trepando and not is_on_floor():
		velocity.y -= gravedad * delta

	if en_dialogo:
		velocity.x = move_toward(velocity.x, 0.0, velocidad_caminar)
		velocity.z = move_toward(velocity.z, 0.0, velocidad_caminar)
		move_and_slide()
		return

	if esta_trepando:
		move_and_slide()
		return

	if is_on_floor() and Input.is_action_just_pressed("saltar") and not esta_agachado:
		velocity.y = fuerza_salto

	var velocidad_actual: float = _obtener_velocidad_actual()
	var input_dir: Vector2 = Input.get_vector("mover_izquierda", "mover_derecha", "mover_adelante", "mover_atras")
	var direccion: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direccion != Vector3.ZERO:
		velocity.x = direccion.x * velocidad_actual
		velocity.z = direccion.z * velocidad_actual
	else:
		velocity.x = move_toward(velocity.x, 0.0, velocidad_actual)
		velocity.z = move_toward(velocity.z, 0.0, velocidad_actual)

	move_and_slide()
	_comprobar_interaccion()

	if Input.is_action_pressed("disparar") and raton_capturado and not en_dialogo:
		disparar()

func capturar_raton(capturar: bool) -> void:
	raton_capturado = capturar
	if capturar:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _inicializar_armas() -> void:
	if armas.is_empty():
		var arma1: DatosArma = load("res://recursos/armas/pistola_policial.tres")
		var arma2: DatosArma = load("res://recursos/armas/tranquilizante.tres")
		if arma1:
			armas.append(arma1.duplicate())
		if arma2:
			armas.append(arma2.duplicate())

func cambiar_arma(indice: int) -> void:
	if indice >= 0 and indice < armas.size():
		indice_arma_actual = indice
		_actualizar_datos_arma_ui()
		_actualizar_modelo_arma()

func _actualizar_modelo_arma() -> void:
	if indice_arma_actual < armas.size():
		var arma: DatosArma = armas[indice_arma_actual]
		if malla_arma:
			var mat: StandardMaterial3D = StandardMaterial3D.new()
			mat.albedo_color = arma.color_arma
			malla_arma.material_override = mat

func disparar() -> void:
	if indice_arma_actual >= armas.size():
		return

	var arma: DatosArma = armas[indice_arma_actual]
	var tiempo_actual: float = Time.get_ticks_msec() / 1000.0

	if tiempo_actual - tiempo_ultimo_disparo < arma.cadencia:
		return

	if arma.municion_actual <= 0:
		recargar()
		return

	tiempo_ultimo_disparo = tiempo_actual
	arma.municion_actual -= 1
	municion_actualizada.emit(arma.municion_actual, arma.municion_maxima)

	# Retroceso visual sutil
	pivote_camara.rotation.x += deg_to_rad(1.0)

	# Raycast de impacto
	rayo_disparo.target_position = Vector3(0, 0, -arma.alcance)
	rayo_disparo.force_raycast_update()

	if rayo_disparo.is_colliding():
		var objetivo: Object = rayo_disparo.get_collider()
		if objetivo is Node:
			var salud: ComponenteSalud = objetivo.get_node_or_null("ComponenteSalud") as ComponenteSalud
			if salud:
				salud.recibir_dano(arma.dano)
			if objetivo.has_method("recibir_impacto"):
				objetivo.recibir_impacto(arma.dano, arma.es_no_letal, rayo_disparo.get_collision_point())

func recargar() -> void:
	if indice_arma_actual >= armas.size():
		return
	var arma: DatosArma = armas[indice_arma_actual]
	arma.municion_actual = arma.municion_maxima
	municion_actualizada.emit(arma.municion_actual, arma.municion_maxima)

func _comprobar_interaccion() -> void:
	if rayo_interaccion.is_colliding():
		var colision: Object = rayo_interaccion.get_collider()
		if colision is Interactuable and colision.activo:
			if interactuable_actual != colision:
				interactuable_actual = colision
				prompt_interaccion_cambiado.emit("[E] " + colision.obtener_texto())
			return
		elif colision is Node:
			var inter: Interactuable = colision.get_node_or_null("Interactuable") as Interactuable
			if inter and inter.activo:
				if interactuable_actual != inter:
					interactuable_actual = inter
					prompt_interaccion_cambiado.emit("[E] " + inter.obtener_texto())
				return

	if interactuable_actual != null:
		interactuable_actual = null
		prompt_interaccion_cambiado.emit("")

func _ejecutar_interaccion() -> void:
	var tiempo_actual: float = Time.get_ticks_msec() / 1000.0
	if tiempo_actual - tiempo_fin_dialogo < 0.35:
		return
	if interactuable_actual != null:
		interactuable_actual.interactuar(self)

func _actualizar_datos_arma_ui() -> void:
	if indice_arma_actual < armas.size():
		var arma: DatosArma = armas[indice_arma_actual]
		arma_cambiada.emit(arma.nombre, arma.municion_actual, arma.municion_maxima)

func establecer_en_dialogo(valor: bool) -> void:
	en_dialogo = valor
	if not valor:
		tiempo_fin_dialogo = Time.get_ticks_msec() / 1000.0
	capturar_raton(not valor)

func _al_morir() -> void:
	print("El jugador ha caído.")

func _procesar_agacharse(delta: float) -> void:
	if Input.is_action_just_pressed("agacharse") and is_on_floor():
		esta_agachado = not esta_agachado
		estado_agachado_cambiado.emit(esta_agachado)

	altura_objetivo = altura_agachado if esta_agachado else altura_de_pie
	var altura_actual: float = collision_shape.shape.height
	var nueva_altura: float = move_toward(altura_actual, altura_objetivo, velocidad_transicion_crouch * delta)

	if abs(nueva_altura - altura_actual) > 0.01:
		collision_shape.shape.height = nueva_altura
		malla_cuerpo.mesh.height = nueva_altura
		var offset_y: float = nueva_altura / 2.0
		collision_shape.position.y = offset_y
		malla_cuerpo.position.y = offset_y
		pivote_camara.position.y = lerpf(pivote_camara.position.y, nueva_altura - 0.3, delta * velocidad_transicion_crouch)

func _obtener_velocidad_actual() -> float:
	if esta_agachado:
		return velocidad_agachado
	if Input.is_action_pressed("correr"):
		return velocidad_correr
	return velocidad_caminar

func _procesar_trepar(_delta: float) -> void:
	if esta_trepando:
		var direccion_trepar: Vector3 = (objetivo_trepar - global_position).normalized()
		velocity = direccion_trepar * velocidad_trepar

		if global_position.distance_to(objetivo_trepar) < 0.3:
			_finalizar_trepar()
		return

	if Input.is_action_just_pressed("trepar") and not is_on_floor():
		var resultado: Dictionary = _detectar_superficie_trepar()
		if resultado:
			iniciar_trepar(resultado.position)

func _detectar_superficie_trepar() -> Dictionary:
	rayo_trepar.force_raycast_update()

	if rayo_trepar.is_colliding():
		var colision: Node3D = rayo_trepar.get_collider() as Node3D
		if colision:
			var superficie: SuperficieTrepable = _buscar_superficie_trepable(colision)
			if not superficie and colision.get_parent():
				superficie = _buscar_superficie_trepable(colision.get_parent() as Node3D)
			if superficie and superficie.activo:
				return {"position": superficie.global_position + Vector3(0, superficie.altura_destino, 0)}

	return {}

func _buscar_superficie_trepable(nodo: Node3D) -> SuperficieTrepable:
	if nodo is SuperficieTrepable:
		return nodo as SuperficieTrepable
	for hijo in nodo.get_children():
		if hijo is SuperficieTrepable:
			return hijo as SuperficieTrepable
	return null

func iniciar_trepar(posicion: Vector3) -> void:
	esta_trepando = true
	objetivo_trepar = posicion
	velocity = Vector3.ZERO

func _finalizar_trepar() -> void:
	esta_trepando = false
	global_position = objetivo_trepar
	velocity = Vector3.ZERO

func _asegurar_mapeo_entradas() -> void:
	_agregar_tecla("mover_adelante", KEY_W)
	_agregar_tecla("mover_atras", KEY_S)
	_agregar_tecla("mover_izquierda", KEY_A)
	_agregar_tecla("mover_derecha", KEY_D)
	_agregar_tecla("saltar", KEY_SPACE)
	_agregar_tecla("correr", KEY_SHIFT)
	_agregar_tecla("interactuar", KEY_E)
	_agregar_tecla("recargar", KEY_R)
	_agregar_tecla("arma_1", KEY_1)
	_agregar_tecla("arma_2", KEY_2)
	_agregar_tecla("agacharse", KEY_CTRL)
	_agregar_tecla("trepar", KEY_F)
	_agregar_raton("disparar", MOUSE_BUTTON_LEFT)

func _agregar_tecla(accion: StringName, tecla: Key) -> void:
	if not InputMap.has_action(accion):
		InputMap.add_action(accion)
	var ev: InputEventKey = InputEventKey.new()
	ev.physical_keycode = tecla
	ev.pressed = true
	if not InputMap.action_has_event(accion, ev):
		InputMap.action_add_event(accion, ev)

func _agregar_raton(accion: StringName, boton: MouseButton) -> void:
	if not InputMap.has_action(accion):
		InputMap.add_action(accion)
	var ev: InputEventMouseButton = InputEventMouseButton.new()
	ev.button_index = boton
	ev.pressed = true
	if not InputMap.action_has_event(accion, ev):
		InputMap.action_add_event(accion, ev)
