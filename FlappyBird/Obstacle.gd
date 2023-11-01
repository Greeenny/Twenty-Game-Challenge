extends Area2D

var top_of_screen_y : float
var bot_of_screen_y : float
var obstacle_width : float = 50
var opening_position : Vector2

var initialized : bool = false

var color : Color = Color.MEDIUM_PURPLE
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	pass
	
func create_obstacle(x_position,top_of_screen_limit,bot_of_screen_limit,opening_height):
	set_global_position(Vector2(x_position,top_of_screen_limit))
	top_of_screen_y = 0
	bot_of_screen_y = bot_of_screen_limit - top_of_screen_limit
	position_obstacle(opening_height)
	initialized = true
	
	
	
func position_obstacle(opening_height):

	opening_position = Vector2(0,randf_range(top_of_screen_y+opening_height, bot_of_screen_y-opening_height))
	var top_column_bottom_edge_y = opening_position.y - opening_height/2
	var top_column_size = Vector2(obstacle_width, top_column_bottom_edge_y - top_of_screen_y)
	var top_column_position = Vector2(0,top_column_bottom_edge_y - top_column_size.y/2)

	$Top.shape.set_size(top_column_size)
	$Top.set_position(top_column_position)
	
	#Here we find the scale as we want the sprite to be the same size as the collision box,
	#We know our sprite currently has size x, and x * scale = collision box size, therefore
	# collision box size / x = scale. Apply scale to x... ezpz
	var top_scale_to_apply = top_column_size/$Top/TopSprite.get_rect().size
	$Top/TopSprite.apply_scale(top_scale_to_apply)
#	$Top/TopSprite.set_region_rect(Rect2(Vector2(0,top_column_position),Vector2(obstacle_width,top_column_size_y)))
	
	var bot_column_top_edge_y = opening_position.y + opening_height/2
	var bot_column_size = Vector2(obstacle_width,bot_of_screen_y - bot_column_top_edge_y)
	var bot_column_position = Vector2(0,bot_column_top_edge_y + bot_column_size.y/2)
	$Bottom.shape.set_size(bot_column_size)
	$Bottom.set_position(bot_column_position)
	var bot_scale_to_apply = bot_column_size/$Bottom/BottomSprite.get_rect().size
	$Bottom/BottomSprite.apply_scale(bot_scale_to_apply)
	pass


func _on_mouse_entered():
	print("mouse entered")
	print(get_global_mouse_position())
	pass # Replace with function body.


func _on_mouse_exited():
	print("mouse exited")
	pass # Replace with function body.
