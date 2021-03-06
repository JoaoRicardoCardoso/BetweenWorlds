extends Area2D

export var travel_speed = 1000
export var timeout:float = 1
export var damage = 1

var current_velocity = Vector2(0,0)
var timeout_counter = timeout

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init(direction):
	current_velocity = direction * travel_speed
	
func disperse():
	queue_free()

func _physics_process(delta):
	if timeout_counter < 0:
		disperse()
		return
		
	timeout_counter -= delta
	position += current_velocity * delta
	


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayerBullet_body_entered(body):
	if (body is Actor) and not (body is Player):
		body.damage(damage)
		
	queue_free()
