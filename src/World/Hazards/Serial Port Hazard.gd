extends Node2D

export var is_in_first_dimension = true
export var hazard_length = 1000
export var duration = 1
export var cooldown = 1
export var instance_frequency:float = 1.0
export var instance_speed = 10

#Instanceable Objects
var DataHazard = load("res://World/Hazards/Serial Port Data Hazard.tscn")

var direction = Vector2(0,0)
var counter = 0
var next_instance = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var orientation = $Destructor.global_position - $Instantiator.global_position
	direction = orientation.normalized()
	$Destructor.global_position += direction * hazard_length
	counter = cooldown
	
	if is_in_first_dimension:
		$Destructor.set_collision_mask_bit(9,true)
	else:
		$Destructor.set_collision_mask_bit(19,true)
	
func instantiate():
	var h_instance = DataHazard.instance()
	h_instance.init(direction, instance_speed, is_in_first_dimension) 
	add_child(h_instance)
	h_instance.global_position = $Instantiator.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter -= delta
	if counter >= cooldown:
		if counter < next_instance :
			instantiate()
			next_instance = counter - duration / instance_frequency
	elif counter < 0:
		counter = cooldown + duration
		next_instance = counter

func _on_Destructor_area_entered(area):
	if area is SerialPortDataHazard:
		area.dissipate()
