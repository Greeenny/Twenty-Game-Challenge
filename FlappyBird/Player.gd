extends CharacterBody2D

@export var color : Color
var top_of_screen_y : float = -9999


@export var gravity : float = 15
@export var jump_count : int = 1
@export var jump_accelleration : float = -60
@export var dash_speed : float = 1000
@export_range(1,0,0.01) var dash_decelleration_ratio : float = 0.9

@export var max_velocity : float = 5000

#Will cut all upward accelleration if it will take dampening_time in seconds to reach
#the max height given accelleration.y = gravity
@export var dampening_time : float = 2

@export_range(0,1,0.01) var camera_offset_ratio : float
@export_range(0,1,0.01) var camera_follow_ratio : float
var camera_offset : float
var camera_follow_velocity : float = 0

enum STATE{FALLING,JUMPING,DASHING}
var state = STATE.FALLING
var accelleration = Vector2.ZERO

var spacebar_hold_time : float = 0
const spacebar_max_hold_time : float = 0.5

var dash_time : float = 0
const dash_time_max : float = .5
var start_dash_x : float 
var column_spacing : float 

func _ready():
	# We get the camera's offset by dividing the viewports x length by two,
	# Where when we multiply that by our offset ratio and add that to our x position
	# The camera will be set behind or in front of the player.
	camera_offset = get_viewport_rect().size.x/2*camera_offset_ratio
	$Camera2D.move_local_x(camera_offset)
	$Camera2D.set_as_top_level(true)


func set_top_of_screen_y(input_y):
		top_of_screen_y = input_y
		
func _physics_process(delta):
	
	# Note: 
	#      All accelleration will be calculated, and then multiplied by delta. 
	#      I don't really know why.
	
	# Top of screen check, if top of screen, set to falling and remove all momentum
	if position.y <= top_of_screen_y:
		position.y = top_of_screen_y
		velocity.y = 0
		accelleration.y = 0
		spacebar_hold_time = 0
		state = STATE.FALLING
	
	if Input.is_action_just_pressed("right") and state != STATE.DASHING:
		state = STATE.DASHING
		accelleration = Vector2.ZERO
		
		velocity = Vector2(dash_speed,0)
		start_dash_x = get_global_position().x
	
	if state == STATE.DASHING:
		velocity.x = dash_speed - dash_speed*dash_decelleration_ratio*(get_global_position().x - start_dash_x)**2/(column_spacing)**2
		if get_global_position().x >= start_dash_x + column_spacing:
			accelleration = Vector2.ZERO
			velocity = Vector2.ZERO
			state = STATE.FALLING
	# When falling, if space bar is pressed and there are remaining jumps,
	# Subtract one jump from the count, overpower all acelleration, save *some*
	# Velocity, but should be overpowered by accelleration.
	# Set state to jumping
	if Input.is_action_just_pressed("space_bar") and state == STATE.FALLING:
		if jump_count > 0:
			jump_count -= 1
			accelleration.y = jump_accelleration
			velocity = velocity/3+ accelleration*delta
			state = STATE.JUMPING
	
	# When jumping, if spacebar is pressed, accellerate more and keep track of time held.
	# Is spacebar not pressed, remove from spacebar timer.
	# If spacebar timer has ran out, or if held to max time, set state to falling.
	if state == STATE.JUMPING:
		if Input.is_action_pressed("space_bar"):
			spacebar_hold_time += delta
			accelleration.y += jump_accelleration
		if Input.is_action_pressed("space_bar") == false:
			spacebar_hold_time -= delta 
		if spacebar_hold_time <= 0 or spacebar_hold_time > spacebar_max_hold_time:
			spacebar_hold_time = 0
			state = STATE.FALLING
			
	# When falling, add gravity to our y accelleration. This will
	# Slowly overpower any positive accelleration.
	if state == STATE.FALLING:
		accelleration.y += gravity
		
	# Add accelleration to velocity.
	velocity = velocity + accelleration*delta
	if abs(velocity.y) > max_velocity:
		if velocity.y > 0:
			velocity.y = max_velocity
		elif velocity.y < 0:
			velocity.y = -max_velocity
	move_and_slide()
	queue_redraw()
	
	# Camera follow mechanic
	var distance_to_camera = $Camera2D.get_global_position().x - self.get_global_position().x 
	camera_follow_velocity = velocity.x
	$Camera2D.move_local_x(distance_to_camera*delta)
		
	




func _draw():
	draw_circle(Vector2.ZERO,10.0,color)
