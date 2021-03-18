extends Object
class_name RoomNode

var type = ""
var adj = []
var coords = Vector2(0,0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func expand(probability):
	var out = []
	var rand = RandomNumberGenerator.new()
	var available_expansions
	if type == "start" or "final":
		return out
	else:
		available_expansions = 3 - adj.size()
	
	
	for i in range(available_expansions):
		var value = rand.randf_range(0, 1)
		if value < probability and available_expansions > 0:
			var new_node = RoomNode.new()
			new_node.adj.push_back(self)
			adj.push_back(new_node)
			out.push_back(new_node)
		
	return out
	
func init():
	var children
	if type != "start":
		children = adj
	else:
		var parent = adj[0]
		var expansion_direction = coords - parent.coords
		children = adj.slice(1,adj.size())
		
		if children.size() == 0:
			type += "long "
		if expansion_direction.x > 0 and expansion_direction.y == 0:
			type += "right"
		elif expansion_direction.x == 0 and expansion_direction.y > 0:
			type += "left"
	
	var rand = RandomNumberGenerator.new()
	for c in children:
		var is_right = rand.randi_range(0,1)
		c.coords = coords + Vector2(is_right, 1 - is_right)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
