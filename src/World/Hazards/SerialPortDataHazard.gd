extends Hazard
class_name SerialPortDataHazard

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var direction = Vector2(0,0)
var speed = 0

func init(direction_vector, instance_speed, is_in_first_dimension):
	direction = direction_vector
	speed = instance_speed
	init_collisions(is_in_first_dimension)
	
func calculate_velocity(velocity, delta):
	return direction * speed * delta

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
