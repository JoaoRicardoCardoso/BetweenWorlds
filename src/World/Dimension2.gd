extends Node2D

var active = false

func change_state():
	active = not active
	$Background.visible = active
	if (active):
		modulate.a = 1
		set_z_index(-1)
	else:
		modulate.a = 0
		set_z_index(0)
