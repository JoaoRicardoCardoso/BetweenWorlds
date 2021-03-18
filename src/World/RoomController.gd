extends Node

export var max_rooms = 10
export var max_path_length = 5
export var probability_decrement = 0.1

var probability = 1.0
var room_nodes = []

func generate():
	var start = RoomNode.new()
	start.type = "start"
	room_nodes.push_back(start)
	
	for i in range(max_path_length):
		var new_node = RoomNode.new()
		room_nodes.push_back(new_node)
		room_nodes[i].adj.push_back(new_node)
	room_nodes[-1].type = "final"
	
	while probability >= 0 and room_nodes.size() < max_rooms:
		for i in range(room_nodes.size()):
			var expanded = room_nodes[i].expand(probability)
			if expanded.size() > 0:
				probability -= probability_decrement
				room_nodes.append(expanded)
	
func initialize():
	for r in room_nodes:
		r.init()
		
	for i in range(1, max_path_length - 1):
		room_nodes[i].init_type()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	generate()
	initialize()
	print(room_nodes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
