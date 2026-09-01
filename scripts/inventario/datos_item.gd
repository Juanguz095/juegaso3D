class_name DatosItem
extends Resource

enum TipoItem { ARMA, MUNICION, BOTIQUIN, GADGET, EVIDENCIA, ESPECIAL }

@export var nombre: String = "Item"
@export var descripcion: String = ""
@export var tipo: TipoItem = TipoItem.ESPECIAL
@export var icono: Texture2D = null
@export var apilable: bool = false
@export var cantidad_maxima: int = 1
@export var usable: bool = false
@export var equipable: bool = false
