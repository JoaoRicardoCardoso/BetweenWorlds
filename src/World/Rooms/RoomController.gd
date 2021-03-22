extends Node

export var max_rooms = 10
export var max_path_length = 5
export var probability_decrement = 0.2

var probability = 1.0
var room_nodes = []

func generate():
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	var start = RoomNode.new()
	start.type = "start"
	room_nodes.push_back(start)
	
	for i in range(max_path_length):
		var new_node = RoomNode.new()
		new_node.parent = room_nodes[i]
		room_nodes.push_back(new_node)
		room_nodes[i].children.push_back(new_node)
	room_nodes[-1].type = "final"
	
	while probability >= 0 and room_nodes.size() < max_rooms:
		for i in range(room_nodes.size()):
			if room_nodes[i].type != "start" and room_nodes[i].type != "final":
				var available_expansions = 2 - room_nodes[i].children.size()
				for k in range(available_expansions):
					var value = rand.randf_range(0, 1)
					if value < probability:
						var new_node = RoomNode.new()
						new_node.parent = room_nodes[i]
						room_nodes[i].children.push_back(new_node)
		
						probability -= probability_decrement
						room_nodes.push_back(new_node)
			room_nodes[i].init()
	
func initialize():
	for r in room_nodes:
		r.init()
		
	for i in range(room_nodes.size()):
		var iNode = room_nodes[i]
		for k in range(i + 1, room_nodes.size()):
			var kNode = room_nodes[k]
			if iNode.coords == kNode.coords:
				iNode.merge(kNode)
		iNode.init_type()
		
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()
	initialize()
	print(room_nodes)
	room_nodes[0].print_path()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
