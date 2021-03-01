extends Actor

export var running_speed = 10000
export var jumping_speed = 10000

export var dash_speed = 12000
export var dash_duration:float = 0.5
export var dash_slowdown:float = 0.1
export var dash_cooldown:float = 0.1

var dash_counter = 0
var dash_direction = 0

export var stomp_velocity = 600

var stomp_flag = false

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
	
func calculate_stomp(velocity, input_direction):
	if is_on_floor() and stomp_flag:
		stomp_flag = false
		
	if not is_on_floor() and input_direction.y > 0 and not stomp_flag and Input.is_action_just_pressed("ui_dash"):
		velocity.x = 0
		velocity.y += stomp_velocity
		stomp_flag = true
		
	return velocity

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
	
	return out

func _physics_process(delta):
	var new_velocity = calculate_velocity(current_velocity, delta)
	
	current_velocity = move_and_slide(new_velocity, Vector2.UP) 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
