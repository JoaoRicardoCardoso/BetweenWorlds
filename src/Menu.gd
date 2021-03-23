extends Node2D

var game_scene = load("res://Game.tscn")

var selected = null

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_down") or event.is_action_pressed("ui_up"):
		if selected == null and event.is_action_pressed("ui_down"):
			$PlayButton.grab_focus()
			selected = "play"
		elif selected == null and event.is_action_pressed("ui_up"):
			$ExitButton.grab_focus()
			selected = "exit"
		elif selected == "play":
			$ExitButton.grab_focus()
			selected = "exit"
		elif selected == "exit":
			$PlayButton.grab_focus()
			selected = "play"
	elif event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_shoot"):
		if selected == "play":
			play()
		elif selected == "exit":
			exit()
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func play():
	Global.lives = 3
	get_tree().change_scene_to(game_scene)
	
func exit():
	get_tree().quit()

func _on_PlayButton_pressed():
	play()

func _on_ExitButton_pressed():
	exit()

func _on_PlayButton_mouse_entered():
	$PlayButton.grab_focus()
	selected = "play"

func _on_ExitButton_mouse_entered():
	$ExitButton.grab_focus()
	selected = "exit"

func _on_PlayButton_mouse_exited():
	if selected == "play":
		$PlayButton.release_focus()
		selected == null

func _on_ExitButton_mouse_exited():
	if selected == "exit":
		$ExitButton.release_focus()
		selected == null
