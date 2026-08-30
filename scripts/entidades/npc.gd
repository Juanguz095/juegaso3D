class_name NPC
extends CharacterBody3D

signal conversacion_iniciada(hablante: String, lineas: Array[String])

@export var nombre_npc: String = "Kenjo (PNP)"
@export var lineas_dialogo: Array[String] = [
	"Kervin, llegaste a tiempo al I.E.S. Simón Bolívar.",
	"Tu misión encubierta es investigar la distribución de la sustancia NOVA.",
	"Mantén tu cobertura como 'Pepito'. Dispones de dos armas en tu equipo.",
	"Presiona [1] para la Pistola Policial y [2] para el Dardo Tranquilizante.",
	"Neutraliza a los sospechosos en el patio y recopila evidencias. ¡Buena suerte!"
]

@onready var interactuable: Interactuable = $Interactuable

func _ready() -> void:
	interactuable.texto_interaccion = "Hablar con " + nombre_npc
	interactuable.interactuado.connect(_al_interactuar)

func _al_interactuar(jugador: Node3D) -> void:
	conversacion_iniciada.emit(nombre_npc, lineas_dialogo)
	if jugador.has_method("establecer_en_dialogo"):
		jugador.establecer_en_dialogo(true)
