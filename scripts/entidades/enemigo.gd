class_name Enemigo
extends CharacterBody3D

enum Estado { INACTIVO, PERSECUCION, ATAQUE, DORMIDO, MUERTO }

@export var nombre_enemigo: String = "Estudiante Hostil"
@export var velocidad: float = 3.5
@export var rango_deteccion: float = 14.0
@export var rango_ataque: float = 1.8
@export var dano_ataque: float = 15.0
@export var cadencia_ataque: float = 1.2
@export var duracion_dormido: float = 10.0

@onready var componente_salud: ComponenteSalud = $ComponenteSalud
@onready var malla: MeshInstance3D = $Malla
@onready var colision: CollisionShape3D = $CollisionShape3D
@onready var etiqueta_estado: Label3D = $EtiquetaEstado

var estado_actual: Estado = Estado.INACTIVO
var jugador: CharacterBody3D = null
var tiempo_ultimo_ataque: float = 0.0
var tiempo_restante_dormido: float = 0.0
var gravedad: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
var material_original: StandardMaterial3D = null

func _ready() -> void:
	componente_salud.murio.connect(_al_morir)
	componente_salud.dano_recibido.connect(_al_recibir_dano)
	if malla.material_override:
		material_original = malla.material_override.duplicate()
		malla.material_override = material_original
	_actualizar_indicador_estado("")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravedad * delta

	if estado_actual == Estado.MUERTO:
		move_and_slide()
		return

	if estado_actual == Estado.DORMIDO:
		velocity.x = move_toward(velocity.x, 0.0, velocidad)
		velocity.z = move_toward(velocity.z, 0.0, velocidad)
		tiempo_restante_dormido -= delta
		
		# Animación de texto Zzz
		var puntos: int = int(Time.get_ticks_msec() / 400) % 4
		_actualizar_indicador_estado("Zzz" + ".".repeat(puntos))
		
		if tiempo_restante_dormido <= 0.0:
			_despertar()
		move_and_slide()
		return

	_buscar_jugador()

	match estado_actual:
		Estado.INACTIVO:
			velocity.x = move_toward(velocity.x, 0.0, velocidad)
			velocity.z = move_toward(velocity.z, 0.0, velocidad)
			if jugador and global_position.distance_to(jugador.global_position) <= rango_deteccion:
				estado_actual = Estado.PERSECUCION
				_actualizar_indicador_estado("!")

		Estado.PERSECUCION:
			if not jugador:
				estado_actual = Estado.INACTIVO
				_actualizar_indicador_estado("")
				return
			
			var dist: float = global_position.distance_to(jugador.global_position)
			if dist > rango_deteccion * 1.3:
				estado_actual = Estado.INACTIVO
				_actualizar_indicador_estado("")
			elif dist <= rango_ataque:
				estado_actual = Estado.ATAQUE
			else:
				var dir: Vector3 = (jugador.global_position - global_position).normalized()
				dir.y = 0
				velocity.x = dir.x * velocidad
				velocity.z = dir.z * velocidad
				look_at(Vector3(jugador.global_position.x, global_position.y, jugador.global_position.z), Vector3.UP)

		Estado.ATAQUE:
			velocity.x = move_toward(velocity.x, 0.0, velocidad)
			velocity.z = move_toward(velocity.z, 0.0, velocidad)
			if jugador:
				var dist: float = global_position.distance_to(jugador.global_position)
				if dist > rango_ataque:
					estado_actual = Estado.PERSECUCION
				else:
					_intentar_atacar()

	move_and_slide()

func _buscar_jugador() -> void:
	if not jugador:
		var nodos: Array[Node] = get_tree().get_nodes_in_group("jugador")
		if not nodos.is_empty():
			jugador = nodos[0] as CharacterBody3D

func _intentar_atacar() -> void:
	var tiempo_actual: float = Time.get_ticks_msec() / 1000.0
	if tiempo_actual - tiempo_ultimo_ataque >= cadencia_ataque and jugador:
		tiempo_ultimo_ataque = tiempo_actual
		var salud_jugador: ComponenteSalud = jugador.get_node_or_null("ComponenteSalud") as ComponenteSalud
		if salud_jugador:
			salud_jugador.recibir_dano(dano_ataque)

func recibir_impacto(_dano: float, es_no_letal: bool, _punto_impacto: Vector3) -> void:
	if estado_actual == Estado.MUERTO:
		return

	if es_no_letal:
		_dormir()
	else:
		_parpadear_rojo()

func _dormir() -> void:
	estado_actual = Estado.DORMIDO
	tiempo_restante_dormido = duracion_dormido
	velocity = Vector3.ZERO
	# Se acuesta en el suelo
	malla.rotation.z = deg_to_rad(85)
	malla.position = Vector3(0, 0.35, 0)
	colision.rotation.z = deg_to_rad(85)
	colision.position = Vector3(0, 0.35, 0)
	etiqueta_estado.position = Vector3(0, 1.0, 0)
	if material_original:
		material_original.albedo_color = Color(0.2, 0.45, 0.75)

func _despertar() -> void:
	estado_actual = Estado.INACTIVO
	# Se levanta
	malla.rotation.z = 0
	malla.position = Vector3(0, 0.9, 0)
	colision.rotation.z = 0
	colision.position = Vector3(0, 0.9, 0)
	etiqueta_estado.position = Vector3(0, 2.1, 0)
	_restaurar_color()
	_actualizar_indicador_estado("")

func _al_recibir_dano(_cantidad: float) -> void:
	if estado_actual == Estado.INACTIVO:
		estado_actual = Estado.PERSECUCION
		_actualizar_indicador_estado("!")

func _parpadear_rojo() -> void:
	if material_original:
		material_original.albedo_color = Color(1.0, 0.1, 0.1)
		await get_tree().create_timer(0.12).timeout
		_restaurar_color()

func _restaurar_color() -> void:
	if material_original and estado_actual != Estado.MUERTO and estado_actual != Estado.DORMIDO:
		material_original.albedo_color = Color(0.85, 0.2, 0.2)

func _actualizar_indicador_estado(texto: String) -> void:
	if etiqueta_estado:
		etiqueta_estado.text = texto

func _al_morir() -> void:
	estado_actual = Estado.MUERTO
	velocity = Vector3.ZERO
	malla.rotation.z = deg_to_rad(90)
	malla.position = Vector3(0, 0.25, 0)
	colision.rotation.z = deg_to_rad(90)
	colision.position = Vector3(0, 0.25, 0)
	colision.disabled = true
	_actualizar_indicador_estado("X_X")
	if material_original:
		material_original.albedo_color = Color(0.2, 0.2, 0.2)
