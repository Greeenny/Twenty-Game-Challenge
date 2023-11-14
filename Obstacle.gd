extends Node2D

var screen_size : Vector2

var opening_height : float

enum STATES{IDLE,TRANSLATING,CHOMP_START,CHOMP_END}
var state = STATES.IDLE
var translate_distance : float
var chomping_distance : float

var velocity : Vector2 = Vector2.ZERO

@export var translation_speed : float = 500
@export var time_to_translate : float = 0.2
@export var time_to_chomp : float = 0.1

var pre_chomp_top_position : Vector2
var pre_chomp_bottom_position : Vector2
enum EDGE{NONE,BOTTOM,TOP}
var edge = EDGE.NONE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame. 
func _process(delta):
	if state == STATES.CHOMP_START:
		velocity = Vector2(0,opening_height * 1/time_to_chomp * 1/2)
		velocity = velocity*delta
		$Top.translate(velocity)
		$Bot.translate(-velocity)
		chomping_distance = chomping_distance - velocity.y
		if chomping_distance < 0:
			state = STATES.CHOMP_END
			chomping_distance = opening_height/2
	elif state == STATES.CHOMP_END:
		velocity = Vector2(0,opening_height * 1/time_to_translate * 1/2)
		velocity = velocity*delta

		$Top.translate(-velocity)
		$Bot.translate(velocity)
		chomping_distance = chomping_distance - velocity.y
		if chomping_distance <= 0:
			chomping_distance = 0
			velocity = Vector2.ZERO
			$Top.set_global_position(pre_chomp_top_position)
			$Bot.set_global_position(pre_chomp_bottom_position)
			state = STATES.IDLE
		
	if state == STATES.TRANSLATING:
		velocity = Vector2(0,translate_distance/time_to_translate)
#		if translate_distance > 0:
#			if translate_distance - translation_speed < 0:
#				velocity = Vector2(0,translate_distance)
#			else:
#				velocity = Vector2(0,translation_speed)
#			pass
#		elif translate_distance < 0:
#			if translate_distance + translation_speed > 0:
#				velocity = Vector2(0,translate_distance)
#			else:
#				velocity = Vector2(0,-translation_speed)
		velocity = velocity*delta
		translate_distance = translate_distance - velocity.y
		self.translate(velocity)
		
		if (velocity > Vector2.ZERO and translate_distance < 0) or (velocity < Vector2.ZERO and translate_distance > 0):
			state = STATES.IDLE
			velocity = Vector2.ZERO
			
func translate_obstacle(distance):

	var obstacle_size = $Top/CollisionShape2D.get_shape().size*Vector2(1,1.5)
	var top_bottom_edge = $Top.get_global_position() + Vector2(0,obstacle_size.y/2)
	var bottom_top_edge = $Bot.get_global_position() - Vector2(0,obstacle_size.y/2)
	var viewport_size = get_viewport_rect().size
	var count = 0
	if top_bottom_edge.y + distance <= -viewport_size.y/2 or bottom_top_edge.y + distance >= viewport_size.y/2:
		while top_bottom_edge.y + distance <= -viewport_size.y/2 or bottom_top_edge.y + distance >= viewport_size.y/2:
			if distance > 0:
				distance -= 2
				edge = EDGE.BOTTOM
			if distance < 0:
				distance += 2
				edge = EDGE.TOP
			if count == 50:
				distance = 0
			count += 1
	else:
		edge = EDGE.NONE
	state = STATES.TRANSLATING
	translate_distance = distance
	print(translate_distance)
	pass
func chomp_obstacle():
	chomping_distance = opening_height/2
	state = STATES.CHOMP_START
	pre_chomp_bottom_position = $Bot.get_global_position()
	pre_chomp_top_position = $Top.get_global_position()
	pass
	
func initialize_obstacle(x_position,obstacle_width,opening_height):
	self.opening_height = opening_height
	screen_size = get_viewport_rect().size
	var node_position = Vector2(x_position,-screen_size.y/2)
	self.set_global_position(node_position)
	# Want the opening to not be at the very top or very bottom, so we will choose
	# It's position between the ranges of the top and bottom of the screen +/- opening_height
	var opening_top_max = opening_height/2+1
	var opening_bot_max = screen_size.y-opening_height/2-1
	var opening_y = randf_range(opening_top_max,opening_bot_max)
	var opening_position = Vector2(0,opening_y)
	
	var obstacle_size = $Top.shape_owner_get_shape(0,0).size*Vector2(1,1.5)
	# Now to align the top obstacle based on this
	
	var top_bottom_edge = opening_position.y - opening_height/2
	# Easily found as the top of the screen is at y = 0
	var top_position = Vector2(0,top_bottom_edge - obstacle_size.y/2)
	$Top.set_position(top_position)
	
	
	# And the bot obstacle
	
	var bottom_top_edge = opening_position.y + opening_height/2
	var bot_position = Vector2(0,bottom_top_edge + obstacle_size.y/2)
	$Bot.set_position(bot_position)
	

	pass


func _on_mouse_entered():
	print("in")
	pass # Replace with function body.


func _on_mouse_exited():
	print("out")
	pass # Replace with function body.
