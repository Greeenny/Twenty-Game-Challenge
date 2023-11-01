extends CharacterBody2D

@export var color : Color
var top_of_screen_y : float = -9999


@export var gravity : float = 15
@export var jump_count : int = 1
@export var jump_accelleration : float = -60
@export var max_velocity : float = 5000

#Will cut all upward accelleration if it will take dampening_time in seconds to reach
#the max height given accelleration.y = gravity
@export var dampening_time : float = 2

enum STATE{FALLING,JUMPING,DASHING}
var state = STATE.FALLING
var accelleration = Vector2.ZERO

var spacebar_hold_time : float = 0
const spacebar_max_hold_time : float = 0.5


func set_top_of_screen_y(input_y):
		top_of_screen_y = input_y
		
func _physics_process(delta):
	if position.y <= top_of_screen_y:
		position.y = top_of_screen_y
		velocity.y = 0
		accelleration.y = 0
		spacebar_hold_time = 0
		state = STATE.FALLING
	if Input.is_action_just_pressed("space_bar") and state == STATE.FALLING:
		if jump_count > 0:

			jump_count -= 1
			accelleration.y = jump_accelleration
			velocity = velocity/3+ accelleration*delta
			state = STATE.JUMPING
	
	if state == STATE.JUMPING:
		if Input.is_action_pressed("space_bar"):
			spacebar_hold_time += delta
			accelleration.y += jump_accelleration
		if Input.is_action_pressed("space_bar") == false:
			spacebar_hold_time -= delta 
		if spacebar_hold_time <= 0 or spacebar_hold_time > spacebar_max_hold_time:
			spacebar_hold_time = 0
			state = STATE.FALLING
	if state == STATE.FALLING:
		accelleration.y += gravity
		
	velocity = velocity + accelleration*delta
	if abs(velocity.y) > max_velocity:
		if velocity.y > 0:
			velocity.y = max_velocity
		elif velocity.y < 0:
			velocity.y = -max_velocity
	move_and_slide()
	queue_redraw()
	
func _draw():
	draw_circle(Vector2.ZERO,10.0,color)
