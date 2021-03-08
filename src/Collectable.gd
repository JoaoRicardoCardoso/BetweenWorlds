extends KinematicBody2D

export var gravity = 500

var current_velocity = Vector2(0,0)

func calculate_velocity(velocity, delta):
	var out = velocity
	out.y += gravity * delta
	
	return out
	
func _physics_process(delta):
	var new_velocity = calculate_velocity(current_velocity, delta)
	
	current_velocity = move_and_slide(new_velocity, Vector2.UP) 

	
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func init(first_dimension):
	if first_dimension:
		$Area2D.collision_mask = 1
		collision_mask = 2 + 8 + 32
		collision_layer = 32
	else:
		$Area2D.collision_mask = 1024
		collision_mask = 4 + 16 + 64
		collision_layer = 64


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pick_up(body):
	queue_free()

func _on_Player_body_entered(body):
	if(body is Player):
		pick_up(body)
