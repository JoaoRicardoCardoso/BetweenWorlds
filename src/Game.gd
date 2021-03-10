extends Node2D

var points = 0
var secs:float = 0.0
var mins = 0
var playerAlive = true

func addPoints(value):
	points += value
	$GUI.setScore(points)
	
func playerDied():
	playerAlive = false
	
func _process(delta):
	if playerAlive:
		secs += delta
		if floor(secs) >= 60:
			mins += 1
			secs -= 60
		$GUI.setTime(mins,floor(secs))
