class_name NivelDemo
extends Node3D

@onready var jugador: Jugador = $Jugador
@onready var npc_kenjo: NPC = $NPC_Kenjo
@onready var hud: HUD = $HUD

func _ready() -> void:
	if hud and jugador:
		hud.conectar_jugador(jugador)

	if npc_kenjo and hud:
		npc_kenjo.conversacion_iniciada.connect(hud.mostrar_dialogo)
