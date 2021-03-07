extends Actor

#Base variables
export var running_speed = 10000
export var jumping_speed = 10000

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
var change_world_cooldown:float = 1.0
var change_world_counter:float = change_world_cooldown
var powerup_counter:float = 0


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

func _on_left_Area2D2_body_entered(body):
	wall_collisions_left += 1

func _on_right_Area2D_body_exited(body):
	wall_collisions_right -= 1

func _on_left_Area2D2_body_exited(body):
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
	
	return out

func _physics_process(delta):
	var new_velocity = calculate_velocity(current_velocity, delta)
	
	current_velocity = move_and_slide(new_velocity, Vector2.UP) 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	powerup_counter -= delta*50
	powerup_counter = max(powerup_counter,0)
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
	if powerup_counter > 0:
		energy = 100
	get_node("GUI/MarginContainer/VBoxContainer/PowerBar/Gauge").set_value(energy)
	if (energy == 0):
		_change_world(false)

#########################################################
#Changing colision mask if appropriate
func _input(event):
	if event.is_action_pressed("change_world"):
		if (not changed_world and not energy == 0) or changed_world:
			if change_world_counter == change_world_cooldown:
				_change_world(not changed_world)

func _change_world(flag: bool):
	if flag != changed_world:
		if changed_world:
			self.set_name("True")
		else:
			self.set_name("False")
		changed_world = flag
		change_world_counter = 0
		for n in range(1,5):
			set_collision_mask_bit(n, not get_collision_mask_bit(n))
		$Area2D3.set_collision_mask_bit(1, get_collision_mask_bit(1))
		$Area2D3.set_collision_mask_bit(2, get_collision_mask_bit(2))
		$Area2D3.set_collision_mask_bit(5, get_collision_mask_bit(1))
		$Area2D3.set_collision_mask_bit(6, get_collision_mask_bit(2))
	
#########################################################
func _on_Area2D3_body_entered(body):
	if body.name == "PowerUp":
		powerup_counter = 200
		body.queue_free()
	else: 
		print("DEAD") #create animation
		running_speed = 0
		jumping_speed = 0
		if $CollisionShape2D/Sprite != null:
			$CollisionShape2D/Sprite.queue_free()
	
