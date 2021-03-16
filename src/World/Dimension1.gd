extends Node2D

var active = true

func change_state():
	active = not active
	#$Background.visible = active
	if (active):		
		modulate.a = 1
		set_z_index(-1)
	else:
		modulate.a = 0.3
		set_z_index(0)
