extends Node2D

func _on_Player_renamed():
	visible = not visible
	print("1")
	print(visible)
