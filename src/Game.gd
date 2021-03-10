extends Node2D

var points = 0
var secs:float = 0.0
var mins = 0
var playerAlive = true
var playerWon = false

func addPoints(value):
	points += value
	$GUI.setScore(points)
	
func playerDied():
	playerAlive = false
	
func playerWon():
	playerWon = true
	
func _process(delta):
	if playerAlive and not playerWon:
		secs += delta
		if floor(secs) >= 60:
			mins += 1
			secs -= 60
		$GUI.setTime(mins,floor(secs))
		
func _input(event):
	if event.is_action_pressed("reset"):
		get_tree().change_scene("res://Game.tscn")
