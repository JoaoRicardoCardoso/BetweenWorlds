extends Area2D
class_name Hazard

export var damage = 1
var current_velocity = Vector2(0,0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init_collisions(is_on_first_dimension):
	if is_on_first_dimension:
		collision_layer = 0
		set_collision_layer_bit(9, true)
		collision_mask = 0
		set_collision_mask_bit(0, true)
	else:
		collision_layer = 0
		set_collision_layer_bit(19, true)
		collision_mask = 0
		set_collision_mask_bit(10, true)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func calculate_velocity(velocity, delta):
	return Vector2(0,0)
	
func _physics_process(delta):
	current_velocity = calculate_velocity(current_velocity, delta)
	position += current_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func dissipate():
	queue_free()

func affect_body(body):
	body.damage(damage)

func _on_Hazard_body_entered(body):
	affect_body(body)

func stop_effect_on_body(body):
	pass

func _on_Hazard_body_exited(body):
	stop_effect_on_body(damage)
