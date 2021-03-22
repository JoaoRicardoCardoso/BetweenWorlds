extends Control

export var movement_margin = Vector2(50,50)
onready var PowerBar = get_node_or_null("MarginContainer/VBoxContainer/PowerBar/Gauge")
onready var HealthBar = get_node_or_null("MarginContainer/VBoxContainer/HealthBar/Gauge")
onready var timeM = get_node_or_null("MarginContainer/VBoxContainer/HealthBar/Time/Background/TimeM")
onready var timeS = get_node_or_null("MarginContainer/VBoxContainer/HealthBar/Time/Background/TimeS")
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
	PowerBar.set_value(value)
	
func setHealthGauge(value):
	HealthBar.set_value(value)
	
func setCursorAmmo(value):
	var textBox = $MarginContainer/VBoxContainer/Ammo/CursorAmmo/Background/Number
	textBox.text = String(value)
	
func setVSAmmo(value):
	var textBox = $MarginContainer/VBoxContainer/Ammo/VSAmmo/Background/Number
	textBox.text = String(value)
	
func setScore(value):
	var textBox = $MarginContainer/VBoxContainer/HealthBar/Score/Background/Score
	textBox.text = String(value)
	
func setTime(mins, secs):
	if secs < 10:
		timeS.text = "0" + String(secs)
	else:
		timeS.text = String(secs)
	if mins < 10:
		timeM.text = "0" + String(mins)
	else:
		timeM.text = String(mins)
	
func activateCoffee():
	PowerBar.modulate.g = 0
	
func deactivateCoffee():
	PowerBar.modulate.g = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

