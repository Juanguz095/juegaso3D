class_name Inventario
extends Node

signal item_agregado(item: DatosItem, cantidad: int)
signal item_eliminado(item: DatosItem, cantidad: int)
signal inventario_cambiado()
signal item_equipado(item: DatosItem)
signal item_desequipado(item: DatosItem)

@export var capacidad: int = 20

var slots: Array[Dictionary] = []
var item_equipado_actual: DatosItem = null

func _ready() -> void:
	slots.clear()

func agregar_item(item: DatosItem, cantidad: int = 1) -> bool:
	if item == null:
		return false

	if item.apilable:
		for slot in slots:
			if slot.item == item:
				var cantidad_total: int = slot.cantidad + cantidad
				if cantidad_total <= item.cantidad_maxima:
					slot.cantidad = cantidad_total
					inventario_cambiado.emit()
					item_agregado.emit(item, cantidad)
					return true
				else:
					var espacio: int = item.cantidad_maxima - slot.cantidad
					slot.cantidad = item.cantidad_maxima
					cantidad -= espacio

	if slots.size() >= capacidad:
		return false

	slots.append({"item": item, "cantidad": cantidad})
	inventario_cambiado.emit()
	item_agregado.emit(item, cantidad)
	return true

func eliminar_item(item: DatosItem, cantidad: int = 1) -> bool:
	for i in range(slots.size() - 1, -1, -1):
		if slots[i].item == item:
			if slots[i].cantidad > cantidad:
				slots[i].cantidad -= cantidad
				inventario_cambiado.emit()
				item_eliminado.emit(item, cantidad)
				return true
			elif slots[i].cantidad == cantidad:
				slots.remove_at(i)
				inventario_cambiado.emit()
				item_eliminado.emit(item, cantidad)
				return true
			else:
				cantidad -= slots[i].cantidad
				slots.remove_at(i)
	return false

func tiene_item(item: DatosItem) -> bool:
	for slot in slots:
		if slot.item == item:
			return true
	return false

func obtener_cantidad(item: DatosItem) -> int:
	for slot in slots:
		if slot.item == item:
			return slot.cantidad
	return 0

func usar_item(item: DatosItem) -> bool:
	if not item.usable:
		return false
	if not tiene_item(item):
		return false
	eliminar_item(item, 1)
	return true

func equipar_item(item: DatosItem) -> void:
	if not item.equipable:
		return
	if not tiene_item(item):
		return
	item_equipado_actual = item
	item_equipado.emit(item)

func desequipar_item() -> void:
	if item_equipado_actual:
		var anterior: DatosItem = item_equipado_actual
		item_equipado_actual = null
		item_desequipado.emit(anterior)

func esta_lleno() -> bool:
	return slots.size() >= capacidad

func obtener_slots() -> Array[Dictionary]:
	return slots

func limpiar() -> void:
	slots.clear()
	item_equipado_actual = null
	inventario_cambiado.emit()
