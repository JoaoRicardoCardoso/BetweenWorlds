extends "res://Ammo/Ammo.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func pick_up(body):
	var player = AudioStreamPlayer.new()
	get_tree().current_scene.add_child(player)
	player.stream = load("res://assets/sound/sfx/leather_inventory.wav")
	player.volume_db = -20
	player.play()
	body.add_CursorAmmo(10)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
