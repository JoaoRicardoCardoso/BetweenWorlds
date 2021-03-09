extends Area2D
class_name LinearBullet

export var travel_speed = 1000
export var timeout:float = 1
export var damage = 1

var current_velocity = Vector2(0,0)
var timeout_counter = timeout
var direction_vector = Vector2(0,0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init(direction, mask):
	direction_vector = direction
	collision_mask = mask
	
func disperse():
	queue_free()
	
func calculate_velocity(velocity, delta):
	return direction_vector * travel_speed

func _physics_process(delta):
	if timeout_counter < 0:
		disperse()
		return
	timeout_counter -= delta
	current_velocity = calculate_velocity(current_velocity, delta)
	position += current_velocity * delta
	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Bullet_body_entered(body):
	if body is Actor:
		body.damage(damage)
	disperse()
