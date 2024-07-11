extends Area2D

@onready var animation_player = $AnimationPlayer
@onready var game_manager = %"Game Manager"


func _on_body_entered(body):
	game_manager.add_score()
	animation_player.play("pick_up")
