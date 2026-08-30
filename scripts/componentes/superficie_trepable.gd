class_name SuperficieTrepable
extends Node3D

@export var activo: bool = true
@export var altura_destino: float = 2.5
@export var texto_interaccion: String = "Trepar"
@export var color_trepable: Color = Color(0.2, 0.7, 0.3, 1)

func _ready() -> void:
	_aplicar_color()

func _aplicar_color() -> void:
	var padre: Node3D = get_parent() as Node3D
	if not padre:
		return
	var malla: MeshInstance3D = padre.get_node_or_null("MeshInstance3D") as MeshInstance3D
	if malla and malla.mesh:
		var mat: StandardMaterial3D = StandardMaterial3D.new()
		mat.albedo_color = color_trepable
		malla.material_override = mat
