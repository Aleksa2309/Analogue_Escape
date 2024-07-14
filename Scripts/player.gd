extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const JUMP_ACCELARATION = -50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var prevVelocity: Vector2 = Vector2.ZERO

@onready var idle_timer = $idle_timer
@onready var sprite_2d = $Sprite2D
@onready var animation_tree = $AnimationTree
@onready var animation_player = $AnimationPlayer
@onready var state_machine = $AnimationTree.get("parameters/playback")


func _process(delta):
	update_animation_parameters()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		velocity.x = lerp(prevVelocity.x,velocity.x,0.1)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_released("jump"):
		velocity.y *= 0.4
	
	
	#Set the input direction
	var direction = Input.get_axis("move_left", "move_right")
	
	#Flip the sprite
	if direction > 0:
		sprite_2d.flip_h = false
	elif direction < 0:
		sprite_2d.flip_h = true
	
	#Play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("move end")
			if idle_timer.time_left == 0:
				idle_timer.start()
		else:
			#animation_player.play("run")
			idle_timer.stop()
	else:
		idle_timer.stop()
	#	animated_sprite_2d.play("jump")
	
	#Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	prevVelocity = velocity


func _on_idle_timer_timeout():
	animation_player.play("idle")

func update_animation_parameters():
	
	if velocity == Vector2.ZERO:
		if state_machine.get_current_node() == &"run":
			animation_tree["parameters/conditions/move_end"] = true
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/move_start"] = false
			animation_tree["parameters/conditions/is_moving"] = false
			print(state_machine.get_current_node() + "0")
			
		if state_machine.get_current_node() == &"move_end":
			animation_tree["parameters/conditions/move_end"] = false
			animation_tree["parameters/conditions/idle"] = true
			animation_tree["parameters/conditions/move_start"] = false
			animation_tree["parameters/conditions/is_moving"] = false
			print(state_machine.get_current_node() + "0")
		
		if state_machine.get_current_node() == &"move_start":
			animation_tree["parameters/conditions/move_end"] = true
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/move_start"] = false
			animation_tree["parameters/conditions/is_moving"] = false
			print(state_machine.get_current_node() + "0")
	else:
		if state_machine.get_current_node() == &"idle":
			animation_tree["parameters/conditions/move_end"] = false
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/move_start"] = true
			animation_tree["parameters/conditions/is_moving"] = false
			print(state_machine.get_current_node() + "1")
			
		if state_machine.get_current_node() == &"move_end":
			animation_tree["parameters/conditions/move_end"] = false
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/move_start"] = true
			animation_tree["parameters/conditions/is_moving"] = false
			print(state_machine.get_current_node() + "1")
		
		if state_machine.get_current_node() == &"move_start":
			animation_tree["parameters/conditions/move_end"] = false
			animation_tree["parameters/conditions/idle"] = false
			animation_tree["parameters/conditions/move_start"] = false
			animation_tree["parameters/conditions/is_moving"] = true
			print(state_machine.get_current_node() + "1")
