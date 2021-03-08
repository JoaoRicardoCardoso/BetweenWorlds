extends Enemy
class_name RangedEnemy

#Instanceable Objects
var Bullet = load("res://Projectiles/LinearBullet.tscn")

export var shot_cooldown:float = 1.0
export var aggro_range = 1000

var shot_counter = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func calculate_velocity(velocity, delta):
	return Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot(direction):
	var b_instance = Bullet.instance()
	b_instance.init(direction, collision_mask) #damage layer 0, ignore layer 5
	owner.add_child(b_instance)
	b_instance.position = position
	b_instance.damage = damage

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	shot_counter -= delta
	if shot_counter <= 0:
		var player = get_parent().get_parent().get_node_or_null("Player")
		if player != null:
			var player_direction = player.position - position
			if player_direction.length() < aggro_range:
				player_direction = player_direction.normalized()
				shoot(player_direction)
				shot_counter = shot_cooldown


func _on_Area2D_area_entered(area):
	pass


func _on_Area2D_body_entered(body):
	body.damage(damage)
