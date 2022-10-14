## Canion.gd
class_name Canion
extends Node2D

## Atributos export
export var proyectil:PackedScene = null
export var cadencia_disparo:float = 0.8
export var velocidad_proyectil:int = 100
export var danio_proyectil:int = 1

## Atributos onready
onready var timer_enfriamiento:Timer = $timer_enfriamiento
onready var disparo_sfx:AudioStreamPlayer2D = $disparoSFX
onready var esta_enfriado:bool = true
onready var esta_disparando:bool = false setget set_esta_disparando

## Atributos
var puntos_disparo:Array = []

## Setters y Getters
func set_esta_disparando(disparando: bool) -> void:
	esta_disparando = disparando

## Metodos
func _ready() -> void:
	almacenar_puntos_disparo()
	timer_enfriamiento.wait_time = cadencia_disparo

#
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if esta_disparando and esta_enfriado:
		disparar()

## Metodos custom
func almacenar_puntos_disparo() -> void:
	for nodo in get_children():
		if nodo is Position2D:
			puntos_disparo.append(nodo)

func disparar() -> void:
	esta_enfriado = false
	disparo_sfx.play()
	timer_enfriamiento.start()
	for punto_disparo in puntos_disparo:
		var new_proyectil:Proyectil = proyectil.instance()
		new_proyectil.crear(
			punto_disparo.global_position,
			get_owner().rotation,
			velocidad_proyectil,
			danio_proyectil
			)
		Eventos.emit_signal("disparo", new_proyectil)
		disparo_sfx.play()


func _on_timer_enfriamiento_timeout() -> void:
	esta_enfriado = true
