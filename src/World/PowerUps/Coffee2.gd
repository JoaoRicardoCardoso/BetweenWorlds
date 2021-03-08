extends Area2D

func _on_Coffee2_body_entered(body):
	if (body is Player):
		body.getCoffee()
		queue_free()
