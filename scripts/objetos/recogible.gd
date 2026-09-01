class_name Recogible
extends Area3D

@export var item: DatosItem
@export var cantidad: int = 1

@onready var malla: MeshInstance3D = $Malla
@onready var luz: OmniLight3D = $Luz
@onready var interactuable: Interactuable = $Interactuable

var altura_inicial: float = 0.0
var tiempo: float = 0.0

func _ready() -> void:
	altura_inicial = malla.position.y
	interactuable.texto_interaccion = "[E] Recoger " + item.nombre
	interactuable.interactuado.connect(_al_interactuar)

func _process(delta: float) -> void:
	tiempo += delta
	malla.position.y = altura_inicial + sin(tiempo * 2.0) * 0.08
	malla.rotate_y(delta * 1.2)
	luz.light_energy = 0.6 + sin(tiempo * 3.0) * 0.2

func _al_interactuar(jugador: Node3D) -> void:
	var inv: Inventario = jugador.get_node_or_null("Inventario") as Inventario
	if not inv:
		return
	if inv.agregar_item(item, cantidad):
		jugador.interactuable_actual = null
		jugador.prompt_interaccion_cambiado.emit("")
		queue_free()
