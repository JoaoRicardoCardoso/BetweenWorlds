extends Object
class_name RoomNode

const room_types = ["empty"]

var type = ""
var openings = {"up":false, "down":false, "left":false, "right":false}
var parent = null
var children = []
var coords = Vector2(0,0)

var printed = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var is_right = rand.randi_range(0,1)
	if type == "start":
		is_right = 1
	for c in children:
		if is_right == 1:
			openings["right"] = true
		else:
			openings["down"] = true
		c.coords = coords + Vector2(is_right, 1 - is_right)
		is_right = 1 - is_right
		
	if parent == null:
		return
		
	var expansion_direction = coords - parent.coords
	
	if expansion_direction.x > 0 and expansion_direction.y == 0:
		openings["left"] = true
	elif expansion_direction.x == 0 and expansion_direction.y > 0:
		openings["up"] = true
		
func init_type():
	if not(type == "start" or type == "final"):
		var rand = RandomNumberGenerator.new()
		rand.randomize()
		var type_index = rand.randi_range(0,room_types.size() - 1)
		type = room_types[type_index]
	
func merge(node):
	openings["up"] = openings["up"] || node.openings["up"]
	openings["down"] = openings["down"] || node.openings["down"]
	openings["left"] = openings["left"] || node.openings["left"]
	openings["right"] = openings["right"] || node.openings["right"]
	for c in node.children:
		c.parent = self
		children.push_back(c)
	
	node.parent.children.erase(node)
	node.parent.children.push_back(self)
	children.push_back(node.parent)
	
func print_path():
	if printed:
		return
	print(parent,type, coords,self)
	printed = true
	for c in children:
		c.print_path()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
