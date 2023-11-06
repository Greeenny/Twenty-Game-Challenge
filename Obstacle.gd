extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize_obstacle(x_position,obstacle_width,opening_height):
	var screen_size = get_viewport_rect().size
	var node_position = Vector2(x_position,-screen_size.y/2)
	self.set_global_position(node_position)
	# Want the opening to not be at the very top or very bottom, so we will choose
	# It's position between the ranges of the top and bottom of the screen +/- opening_height
	var opening_top_max = opening_height/2+1
	var opening_bot_max = screen_size.y-opening_height/2-1
	var opening_y = randf_range(opening_top_max,opening_bot_max)
	var opening_position = Vector2(0,opening_y)
	
	# Now to align the top obstacle based on this
	
	var top_bottom_edge = opening_position.y - opening_height/2
	# Easily found as the top of the screen is at y = 0
	var top_position = Vector2(0,top_bottom_edge / 2)
	var top_y_size = top_bottom_edge
	var top_shape_size = Vector2(obstacle_width,top_y_size)
	$Top/CollisionShape2D.shape.set_size(top_shape_size)
	$Top.set_position(top_position)
	
	var sprite_scale = top_shape_size/$Top/Sprite2D.get_rect().size
	$Top/Sprite2D.apply_scale(sprite_scale)
	
	# And the bot obstacle
	
	var bot_top_edge = opening_position.y + opening_height/2
	var bot_distance_to_bottom = screen_size.y - bot_top_edge
	var bot_size = Vector2(obstacle_width,bot_distance_to_bottom)
	var bot_position = Vector2(0,bot_size.y/2+bot_top_edge)
	$Bot/CollisionShape2D.shape.set_size(bot_size)
	$Bot.set_position(bot_position)
	
	sprite_scale = bot_size/$Bot/Sprite2D.get_rect().size
	$Bot/Sprite2D.apply_scale(sprite_scale)
	
	

	pass


func _on_mouse_entered():
	print("in")
	pass # Replace with function body.


func _on_mouse_exited():
	print("out")
	pass # Replace with function body.
