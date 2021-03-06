extends KinematicBody2D
class_name Actor

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var gravity = 500

var current_velocity = Vector2(0,0)
var orientation = Vector2(1,0)

var health = 5

func calculate_velocity(velocity, delta):
	pass
	
func _physics_process(delta):
	var new_velocity = calculate_velocity(current_velocity, delta)
	
	current_velocity = move_and_slide(new_velocity, Vector2.UP) 

func damage(value):
	health -= value
	if health <= 0:
		die()

func die():
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
