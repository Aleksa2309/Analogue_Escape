extends Area2D

@onready var timer = $Timer


func _on_body_entered(body):
	print("You died")
	body.get_node("CollisionShape2D").queue_free()
	timer.start()


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
