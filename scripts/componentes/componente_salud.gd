class_name ComponenteSalud
extends Node

signal salud_cambiada(salud_actual: float, salud_maxima: float)
signal dano_recibido(cantidad: float)
signal curacion_recibida(cantidad: float)
signal murio()

@export var salud_maxima: float = 100.0
var salud_actual: float = 100.0
var esta_muerto: bool = false

func _ready() -> void:
	salud_actual = salud_maxima
	salud_cambiada.emit(salud_actual, salud_maxima)

func recibir_dano(cantidad: float) -> void:
	if esta_muerto or cantidad <= 0.0:
		return
	salud_actual = max(0.0, salud_actual - cantidad)
	salud_cambiada.emit(salud_actual, salud_maxima)
	dano_recibido.emit(cantidad)
	if salud_actual <= 0.0:
		esta_muerto = true
		murio.emit()

func curar(cantidad: float) -> void:
	if esta_muerto or cantidad <= 0.0:
		return
	salud_actual = min(salud_maxima, salud_actual + cantidad)
	salud_cambiada.emit(salud_actual, salud_maxima)
	curacion_recibida.emit(cantidad)

func reiniciar() -> void:
	esta_muerto = false
	salud_actual = salud_maxima
	salud_cambiada.emit(salud_actual, salud_maxima)
