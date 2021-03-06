extends Actor
class_name Enemy

export var speed = 1000
export var damage = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func calculate_velocity(velocity, delta):
	var out = velocity
	out.y += delta * gravity
	
	if is_on_wall():
		orientation.x *= -1
		
	out.x = orientation.x * speed * delta
	
	return out

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	orientation.x *= -1


func _on_Area2D_body_entered(body):
	body.damage(damage)
