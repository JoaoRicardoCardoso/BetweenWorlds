extends Node2D

var points = 0
var secs:float = 0.0
var mins = 0
var playerAlive = true
var playerWon = false
var outside = false
var timeAfterDeath:float = 1.0

func _ready():
	$Music/Ambient.play()

func addPoints(value):
	points += value
	$GUI.setScore(points)
	
func playerDied():
	playerAlive = false
	Global.lives -= 1
	
func playerWon():
	var player = AudioStreamPlayer.new()
	self.add_child(player)
	player.stream = load("res://assets/sound/sfx/win.wav")
	player.play()
	playerWon = true
	$Music/Ambient.stop()
	
func _process(delta):
	if playerAlive and not playerWon:
		secs += delta
		if floor(secs) >= 60:
			mins += 1
			secs -= 60
		$GUI.setTime(mins,floor(secs))
	if outside:
		$Music/Outside/Wind.volume_db = min($Music/Outside/Wind.volume_db + 0.1, 0.0)
	else:
		$Music/Outside/Wind.volume_db = max($Music/Outside/Wind.volume_db - 0.1, -20.0)
	if $Music/Outside/Wind.volume_db == -20:
		$Music/Outside/Wind.stop()
		
	if not playerAlive:
		timeAfterDeath -= delta
		timeAfterDeath = max(timeAfterDeath,0)
		if timeAfterDeath == 0 and Global.lives > 0:
			get_tree().change_scene("res://Game.tscn")
		elif Global.lives <= 0:
			get_tree().change_scene("res://Menu.tscn")
		
func _input(event):
	if event.is_action_pressed("reset"):
		get_tree().change_scene("res://Game.tscn")


func _on_Outside_body_entered(body):
	if body is Player:
		$Music/Outside/Wind.play()
		outside = true

func _on_Outside_body_exited(body):
	if body is Player:
		outside = false
