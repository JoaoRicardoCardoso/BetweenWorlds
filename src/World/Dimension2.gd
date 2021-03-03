extends Node2D

func _input(event):
	if event.is_action_pressed("change_world"):
		visible = not visible
