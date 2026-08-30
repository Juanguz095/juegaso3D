class_name Interactuable
extends Area3D

signal interactuado(jugador: Node3D)

@export var texto_interaccion: String = "Interactuar"
@export var activo: bool = true

func obtener_texto() -> String:
	return texto_interaccion

func interactuar(jugador: Node3D) -> void:
	if activo:
		interactuado.emit(jugador)
