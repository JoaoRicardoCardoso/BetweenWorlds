extends Actor
class_name Enemy

#Instanceable Objects
var Drop = load("res://Ammo/VSCodeAmmo.tscn")

export var speed = 1000
export var damage = 10
export var drop_rate:float = 1.0

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

func drop_item():
	var drop_instance = Drop.instance()
	owner.add_child(drop_instance)
	drop_instance.init(get_collision_layer_bit(7))
	drop_instance.global_position = global_position

func handle_drops():
	var rng = RandomNumberGenerator.new()
	var drop_value = rng.randf_range(0.0, 1.0)
	if drop_value <= drop_rate:
		drop_item()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	orientation.x *= -1


func _on_Area2D_body_entered(body):
	body.damage(damage)
