extends Area2D



func _on_Stackoverflow2_body_entered(body):
	if (body is Player):
		body.getStackoverflow()
		queue_free()
