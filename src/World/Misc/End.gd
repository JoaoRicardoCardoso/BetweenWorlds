extends Hazard

func _ready():
	pass # Replace with function body.

func affect_body(body):
	if body is Player:
		body.win()
		queue_free()

