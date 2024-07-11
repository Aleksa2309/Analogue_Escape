extends Node

#Coin Score
var score = 0
@onready var coin_score = %coin_score


func add_score():
	score += 1
	coin_score.text = "You collected " + str(score) + " coins!"
