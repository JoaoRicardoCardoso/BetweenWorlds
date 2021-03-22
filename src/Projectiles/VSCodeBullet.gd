extends LinearBullet
class_name VSCodeBullet

export var bullet_gravity = 2500
export var vertical_impulse = 1000
export var max_explosion_interval:float = 0.2
export var max_explosion_radius_expansion:float = 10
export var explosion_damage = 3

var exploding = false
var explosion_counter = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init(direction, mask):
	.init(direction,mask)
	$BlastRadius.collision_mask = mask
	current_velocity.y -= vertical_impulse

func calculate_velocity(velocity, delta):
	if exploding:
		return Vector2(0,0)
	var out = velocity
	out.y += bullet_gravity * delta
	out.x = direction_vector.x * travel_speed
	return out

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout_counter = 4

func _on_Bullet_body_entered(body):
	if body is Actor:
		body.damage(damage)	
	exploding = true
	$CollisionShape2D/vscode.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if exploding:
		if explosion_counter >= max_explosion_interval:
			queue_free()
			return
		explosion_counter += delta
		var radius = explosion_counter / max_explosion_interval * max_explosion_radius_expansion
		$BlastRadius.scale.x = radius
		$BlastRadius.scale.y = radius

func _on_BlastRadius_body_entered(body):
	if exploding and body is Actor:
		body.damage(explosion_damage)
