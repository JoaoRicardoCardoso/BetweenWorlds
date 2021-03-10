extends Area2D

func _on_Coffee1_body_entered(body):
	if (body is Player):
		body.getCoffee()
		get_parent().get_parent().addPoints(100)
		queue_free()
