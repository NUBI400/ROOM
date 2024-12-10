extends Control

@onready var vida = $MarginContainer/VBoxContainer/vidabar

@onready var stamina = $MarginContainer/VBoxContainer/estaminabar

var time_to_wait = 2

var can_start_stimer = true

func _ready():
	pass


func _process(delta):
	vida.value = Global.vidaPlayer
	stamina.value = Global.estaminaplayer
	if Global.can_regen == false && stamina.value != 100 or stamina.value == 0:
		can_start_stimer = true
		if can_start_stimer:
			Global.s_timer += delta
			if Global.s_timer >= time_to_wait:
				Global.can_regen = true
				can_start_stimer = false
				Global.s_timer = 0 

	if stamina.value == 100:
		Global.can_regen = false

	if Global.can_regen == true:
		Global.estaminaplayer += 0.05
		can_start_stimer = false
		Global.s_timer = 0 
