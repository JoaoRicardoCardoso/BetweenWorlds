extends Actor
class_name Player

#GUI Controller
var GUI = null

#Instanceable Objects
var Bullet1 = load("res://Projectiles/MouseBullet.tscn")
var Bullet2 = load("res://Projectiles/VSCodeBullet.tscn")

#Base variables
export var running_speed = 10000
export var jumping_speed = 600

#Dash variables
export var dash_speed = 12000
export var dash_duration:float = 0.5
export var dash_slowdown:float = 0.1
export var dash_cooldown:float = 0.1

var dash_counter = 0
var dash_direction = 0

#Stomp variables
export var stomp_velocity = 600

var stomp_flag = false

#Wall Slide variables
export var wall_slide_velocity = 800
export var wall_jump_velocity_y = 800
export var wall_jump_velocity_x = 300

var wall_collisions_left = 0
var wall_collisions_right = 0
var wall_jump_flag = false

var changed_world = false
var energy = 100
export var change_world_cooldown:float = 1.0
var change_world_counter:float = 0
var coffee_counter:float = 0
var stackoverflow_counter:float = 0

#Shooting variables
export var CursorAmmo = 20
export var VSAmmo = 5

####################################################
#Dash functions
func calculate_dash_velocity(input_direction, delta):
	var out = Vector2(0,0)
	if is_on_floor() and Input.is_action_just_pressed("ui_dash") and dash_counter <= 0:
		dash_direction = input_direction.x
		dash_counter = dash_duration + dash_slowdown + dash_cooldown
	if dash_counter > 0:
		if dash_counter > dash_cooldown and dash_direction == -input_direction.x:
			dash_counter = dash_cooldown
		if dash_counter > dash_cooldown + dash_slowdown:
			out.x += dash_direction * dash_speed * delta
		elif dash_counter > dash_cooldown:
			out.x += dash_direction * dash_speed * delta * (dash_counter - dash_cooldown) / dash_slowdown
		dash_counter -= delta
	return out
	
##########################################################
#Stomp functions
func calculate_stomp(velocity, input_direction):
	if is_on_floor() and stomp_flag:
		stomp_flag = false
		
	if not is_on_floor() and input_direction.y > 0 and not stomp_flag and Input.is_action_just_pressed("ui_dash"):
		velocity.x = 0
		velocity.y += stomp_velocity
		stomp_flag = true
		
	return velocity
	
#########################################################
#Wall slide/jump functions
func _on_right_Area2D_body_entered(body):
	wall_collisions_right += 1

func _on_left_Area2D_body_entered(body):
	wall_collisions_left += 1

func _on_right_Area2D_body_exited(body):
	wall_collisions_right -= 1

func _on_left_Area2D_body_exited(body):
	wall_collisions_left -= 1

func calculate_wall_interaction(velocity, input_direction, delta):
	var out = velocity
	
	if is_on_floor():
		wall_jump_flag = false
	
	if is_on_wall() and not is_on_floor() and velocity.y >= 0:
		out.y = wall_slide_velocity * delta
		wall_jump_flag = false
	
	if Input.is_action_just_pressed("ui_jump") and not is_on_floor() and not wall_jump_flag:
		if wall_collisions_left > 0 and wall_collisions_right == 0:
			out.y -= wall_jump_velocity_y
			out.x += wall_jump_velocity_x
		
		if wall_collisions_right > 0 and wall_collisions_left == 0:
			out.y -= wall_jump_velocity_y
			out.x -= wall_jump_velocity_x
	
	return out
	
#########################################################
#Base physics functions
func calculate_velocity(velocity, delta):
	var out = velocity
	
	var input_direction = Vector2(0,0)
	input_direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_direction.x != 0:
		orientation.x = input_direction.x
	
	if abs(velocity.x) <= running_speed:
		out.x = delta * running_speed * input_direction.x
		
	out += calculate_dash_velocity(input_direction, delta)
	
	out = calculate_stomp(out, input_direction)
	
	if velocity.y < 0 and (Input.is_action_just_released("ui_jump") or is_on_ceiling()):
		out.y = 0
		
	out.y += delta * gravity
	
	if is_on_floor() and Input.is_action_just_pressed("ui_jump"):
		out.y = -jumping_speed
	out = calculate_wall_interaction(out, input_direction, delta)
	
	if (health != 0):
		setAnimation(out, input_direction)
	else:
		return Vector2(0,0)
	
	return out

###########################################################

func _physics_process(delta):
	._physics_process(delta)
	GUI.update_position(position)

###########################################################

func shoot():
	var b_instance = null
	
	if changed_world and VSAmmo > 0:
		b_instance = Bullet2.instance()
		VSAmmo -= 1
		GUI.setVSAmmo(VSAmmo)
	elif not changed_world and CursorAmmo > 0:
		b_instance = Bullet1.instance()
		CursorAmmo -= 1
		GUI.setCursorAmmo(CursorAmmo)
	else:
		return
		
	var bullet_mask = collision_mask 
	if changed_world:
		bullet_mask = bullet_mask | 256
	else:
		bullet_mask = bullet_mask | 128
	b_instance.init(orientation, bullet_mask) #damage layer bit 5, ignore layer bit 0
	owner.add_child(b_instance)
	b_instance.position = position

# Called when the node enters the scene tree for the first time.
func _ready():
	GUI = get_parent().get_node_or_null("GUI")
	health = 100
	max_health = 100
	GUI.setCursorAmmo(CursorAmmo)
	GUI.setVSAmmo(VSAmmo)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	coffee_counter -= delta*50
	coffee_counter = max(coffee_counter,0)
	stackoverflow_counter -= delta*50
	stackoverflow_counter = max(stackoverflow_counter,0)
	if (changed_world):
		change_world_counter += delta*5
		change_world_counter = min(change_world_counter, change_world_cooldown)
		energy -= delta*50
		energy = max(energy,0)
	else:
		change_world_counter += delta*5
		change_world_counter = min(change_world_counter, change_world_cooldown)
		if (change_world_counter == change_world_cooldown):
			energy += delta*25
			energy = min(energy,100)
	if coffee_counter > 0:
		energy = 100
	else:
		GUI.deactivateCoffee()
		
	if stackoverflow_counter == 0:
		$Shield.visible = false
	
	GUI.setPowerGauge(energy)
	
	if (energy == 0):
		_change_world(false)

#########################################################
#Changing colision mask if appropriate
func _input(event):
	if event.is_action_pressed("ui_shoot"):
		shoot()
	if event.is_action_pressed("change_world"):
		if (not changed_world and not energy == 0) or changed_world:
			if change_world_counter == change_world_cooldown:
				_change_world(not changed_world)
				
func setAnimation(velocity, input_direction):
	if input_direction.x < 0:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.offset.x = -7.8
	elif input_direction.x > 0:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.offset.x = 0
	if is_on_floor():
		if input_direction.x == 0:
			$AnimatedSprite.animation = "idle"
			$AnimatedSprite.speed_scale = 1
		else:
			$AnimatedSprite.animation = "run"
			$AnimatedSprite.speed_scale = abs(velocity.x/130)
	else:
		if velocity.y < 0:
			$AnimatedSprite.animation = "jump"
			$AnimatedSprite.speed_scale = 1
		elif velocity.y > 0:
			$AnimatedSprite.animation = "jump_landing"
			$AnimatedSprite.speed_scale = 1
		

func _change_world(flag: bool):
	if flag != changed_world:

		get_parent().get_node_or_null("Dimension1").change_state()
		get_parent().get_node_or_null("Dimension2").change_state()

		if changed_world:
			collision_layer = 1
		else:
			collision_layer = 1024

		changed_world = flag
		change_world_counter = 0
		for n in range(1,5):
			set_collision_mask_bit(n, not get_collision_mask_bit(n))
		$MiddleArea2D.set_collision_mask_bit(1, get_collision_mask_bit(1))
		$MiddleArea2D.set_collision_mask_bit(2, get_collision_mask_bit(2))
		$RightArea2D.set_collision_mask_bit(1, get_collision_mask_bit(1))
		$RightArea2D.set_collision_mask_bit(2, get_collision_mask_bit(2))
		$LeftArea2D.set_collision_mask_bit(1, get_collision_mask_bit(1))
		$LeftArea2D.set_collision_mask_bit(2, get_collision_mask_bit(2))

#########################################################
func getCoffee():
	coffee_counter = 200
	GUI.activateCoffee()
	
func getStackoverflow():
	stackoverflow_counter = 200
	$Shield.visible = true

func damage(value):
	if (stackoverflow_counter == 0):
		health -= value
	health = max(health, 0)
	GUI.setHealthGauge(health)
	if health <= 0:
		die()
		
func die():
	$AnimatedSprite.animation = "dead"
	health = 0
	GUI.setHealthGauge(health)
	get_parent().playerDied()
	
func win():
	get_parent().playerWon()
	queue_free()

func _on_MiddleArea2D_body_entered(body):
	if (body.name) == "TileMap":
		die()

func add_CursorAmmo(value):
	CursorAmmo += value
	GUI.setCursorAmmo(CursorAmmo)
	
func add_VSAmmo(value):
	VSAmmo += value
	GUI.setVSAmmo(VSAmmo)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "dead":
		queue_free()
