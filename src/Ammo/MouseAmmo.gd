extends "res://Ammo/Collectable.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func pick_up(body):
	body.add_CursorAmmo(10)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
