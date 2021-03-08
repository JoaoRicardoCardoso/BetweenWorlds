extends Control

export var movement_margin = Vector2(50,50)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current_position = Vector2(0,0)

func update_position(new_position):
	var position = get_position()
	
	if new_position.x > position.x + movement_margin.x:
		position.x += new_position.x - position.x - movement_margin.x
	if new_position.x < position.x - movement_margin.x:
		position.x += new_position.x - position.x + movement_margin.x
	if new_position.y > position.y + movement_margin.y:
		position.y += new_position.y - position.y - movement_margin.y
	if new_position.y < position.y - movement_margin.y:
		position.y += new_position.y - position.y + movement_margin.y
		
	_set_position(position)
	
func setPowerGauge(value):
	get_node("MarginContainer/VBoxContainer/PowerBar/Gauge").set_value(value)
	
func setHealthGauge(value):
	get_node("MarginContainer/VBoxContainer/HealthBar/Gauge").set_value(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
