extends Node2D

var points = 0

func addPoints(value):
	points += value
	$GUI.setScore(points)
	
