extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const JUMP_ACCELARATION = -50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var prevVelocity: Vector2 = Vector2.ZERO

@onready var animated_sprite_2d = $AnimatedSprite2D

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
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	#Play animation
	#if is_on_floor():
	#	if direction == 0:
	#		animated_sprite_2d.play("idle")
	#	else:
	#		animated_sprite_2d.play("run")
	#else:
	#	animated_sprite_2d.play("jump")
	
	
	#Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	prevVelocity = velocity
